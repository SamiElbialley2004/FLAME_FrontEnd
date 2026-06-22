import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/app_tab_scope.dart';
import '../social/notifications_screen.dart';
import 'my_workshops_screen.dart';
import 'workshop_models.dart';

class WorkshopPage extends StatefulWidget {
  const WorkshopPage({super.key});

  @override
  State<WorkshopPage> createState() => _WorkshopPageState();
}

class _WorkshopPageState extends State<WorkshopPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  List<WorkshopModel> _workshops = List<WorkshopModel>.from(
    WorkshopModel.defaults,
  );
  final Set<String> _bookedKeys = {};
  bool _loading = true;
  String? _bookingKey;

  List<String> get _categories =>
      <String>{'All', ..._workshops.map((w) => w.category)}.toList();

  List<WorkshopModel> get _filteredWorkshops {
    final search = _searchController.text.trim().toLowerCase();
    return _workshops.where((workshop) {
      final categoryMatch =
          _selectedCategory == 'All' || workshop.category == _selectedCategory;
      final searchMatch =
          search.isEmpty ||
          workshop.name.toLowerCase().contains(search) ||
          workshop.creator.toLowerCase().contains(search) ||
          workshop.description.toLowerCase().contains(search);
      return categoryMatch && searchMatch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = FirebaseAuth.instance.currentUser;
    final workshops = await WorkshopRepository.fetchWorkshops();
    final booked = user != null
        ? await WorkshopRepository.fetchUserBookingKeys(user.uid)
        : <String>{};
    if (!mounted) return;
    setState(() {
      _workshops = workshops;
      _bookedKeys
        ..clear()
        ..addAll(booked);
      _loading = false;
    });
  }

  Future<void> _bookWorkshop(WorkshopModel workshop) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showSnack('Please sign in to book a workshop.');
      return;
    }
    if (_bookedKeys.contains(workshop.bookingKey)) {
      _showSnack('You already booked this workshop.', isError: false);
      return;
    }
    if (workshop.availableSeats <= 0) {
      _showSnack('This workshop is fully booked.');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF18181B),
        title: const Text('Confirm booking', style: TextStyle(color: Colors.white)),
        content: Text(
          workshop.isFree
              ? 'Book "${workshop.name}" for free?'
              : 'Book "${workshop.name}" for ${workshop.priceLabel}?',
          style: const TextStyle(color: Color(0xFFC7CCDA)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF7A18),
            ),
            child: const Text('Book now'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _bookingKey = workshop.bookingKey);
    try {
      await WorkshopRepository.bookWorkshop(
        workshop: workshop,
        userId: user.uid,
        userName: user.displayName ?? user.email ?? 'User',
      );
      if (!mounted) return;
      setState(() {
        _bookedKeys.add(workshop.bookingKey);
        final index = _workshops.indexWhere(
          (w) => w.bookingKey == workshop.bookingKey,
        );
        if (index >= 0 && _workshops[index].availableSeats > 0) {
          _workshops[index] = _workshops[index].copyWith(
            availableSeats: _workshops[index].availableSeats - 1,
          );
        }
        _bookingKey = null;
      });
      _showSnack('Workshop booked successfully!', isError: false);
    } catch (_) {
      if (mounted) {
        setState(() => _bookingKey = null);
        _showSnack('Booking failed. Please try again.');
      }
    }
  }

  void _showSnack(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.deepOrange : const Color(0xFF10B981),
      ),
    );
  }

  Future<void> _openCreateWorkshopPanel() async {
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Create workshop',
      barrierColor: Colors.black.withValues(alpha: 0.75),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (context, _, _) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, _, __) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.94, end: 1).animate(curved),
            child: _CreateWorkshopDialog(
              onCreated: (workshop) {
                setState(() {
                  _workshops.insert(0, workshop);
                });
                _showSnack('Workshop created successfully!', isError: false);
              },
              onError: (message) => _showSnack(message),
            ),
          ),
        );
      },
    );
  }

  void _openMyWorkshops() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const MyWorkshopsScreen()),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = size.width < 700;
    final crossAxisCount = isMobile ? 1 : (size.width < 1120 ? 2 : 3);
    final workshops = _filteredWorkshops;

    return Scaffold(
      backgroundColor: const Color(0xFF07090F),
      body: Stack(
        children: [
          const _BackgroundGradient(),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const _BrandMark(),
                            const Spacer(),
                            _GlassIconButton(
                              icon: Icons.notifications_none_rounded,
                              onPressed: () => NotificationsScreen.show(context),
                            ),
                            const SizedBox(width: 10),
                            _GlassIconButton(
                              icon: Icons.school_outlined,
                              onPressed: _openMyWorkshops,
                            ),
                            const SizedBox(width: 10),
                            _GlassIconButton(
                              icon: Icons.person_outline_rounded,
                              onPressed: () =>
                                  AppTabScope.maybeOf(context)?.selectTab(4),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'Workshop Marketplace',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Discover, create, and book premium learning experiences.',
                          style: TextStyle(
                            color: Color(0xFFC7CCDA),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _SearchInput(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 42,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _categories.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final category = _categories[index];
                              final selected = category == _selectedCategory;
                              return _CategoryChip(
                                label: category,
                                selected: selected,
                                onTap: () => setState(
                                  () => _selectedCategory = category,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              '${workshops.length} Workshops',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            ElevatedButton.icon(
                              onPressed: _openCreateWorkshopPanel,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF7A18),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Create'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 6, 20, 110),
                  sliver: _loading
                      ? const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFFF7A18),
                              ),
                            ),
                          ),
                        )
                      : workshops.isEmpty
                      ? const SliverToBoxAdapter(child: _EmptyState())
                      : SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: isMobile ? 0.86 : 0.92,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            childCount: workshops.length,
                            (context, index) {
                              final workshop = workshops[index];
                              return _WorkshopCard(
                                workshop: workshop,
                                animationDelay: index * 70,
                                isBooked: _bookedKeys.contains(
                                  workshop.bookingKey,
                                ),
                                isBooking: _bookingKey == workshop.bookingKey,
                                onBook: () => _bookWorkshop(workshop),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundGradient extends StatelessWidget {
  const _BackgroundGradient();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F172A), Color(0xFF09090B), Color(0xFF09090B)],
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFFF7A18), Color(0xFFB83280)],
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Flame Workshops',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SearchInput extends StatelessWidget {
  const _SearchInput({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search workshops, creators, or topics',
        hintStyle: const TextStyle(color: Color(0xFFB2B8CB)),
        prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFB2B8CB)),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.06),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFFF7A18), width: 1.1),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFFF7A18).withValues(alpha: 0.24)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? const Color(0xFFFFB073)
                : Colors.white.withValues(alpha: 0.11),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFFC7CCDA),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _WorkshopCard extends StatefulWidget {
  const _WorkshopCard({
    required this.workshop,
    required this.animationDelay,
    required this.isBooked,
    required this.isBooking,
    required this.onBook,
  });

  final WorkshopModel workshop;
  final int animationDelay;
  final bool isBooked;
  final bool isBooking;
  final VoidCallback onBook;

  @override
  State<_WorkshopCard> createState() => _WorkshopCardState();
}

class _WorkshopCardState extends State<_WorkshopCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.workshop;
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 380 + widget.animationDelay),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 28 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedScale(
          scale: _hovered ? 1.015 : 1,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(item.imageUrl, fit: BoxFit.cover),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.7),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: _PillTag(label: item.category),
                          ),
                          Positioned(
                            left: 12,
                            bottom: 12,
                            child: _PillTag(
                              label: item.isFree
                                  ? 'Free'
                                  : '\$${item.price.toStringAsFixed(0)}',
                              solid: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFC2C8D7),
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _CardDetail(
                            icon: Icons.person_outline,
                            text: item.creator,
                          ),
                          _CardDetail(
                            icon: Icons.schedule_rounded,
                            text: item.dateTime,
                          ),
                          _CardDetail(
                            icon: Icons.event_seat_outlined,
                            text:
                                '${item.availableSeats} seats • ${item.tokenSeats} token seats',
                          ),
                          _CardDetail(
                            icon: Icons.language_rounded,
                            text: item.location,
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: widget.isBooked || widget.isBooking
                                  ? null
                                  : widget.onBook,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.isBooked
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFFF7A18),
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: widget.isBooked
                                    ? const Color(0xFF10B981).withValues(alpha: 0.6)
                                    : const Color(0xFFFF7A18).withValues(alpha: 0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: widget.isBooking
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      widget.isBooked
                                          ? 'Booked'
                                          : item.availableSeats <= 0
                                          ? 'Full'
                                          : 'Book',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardDetail extends StatelessWidget {
  const _CardDetail({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFFBFC5D5)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFFBFC5D5), fontSize: 12.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _PillTag extends StatelessWidget {
  const _PillTag({required this.label, this.solid = false});

  final String label;
  final bool solid;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: solid
            ? const Color(0xFFFF7A18)
            : Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CreateWorkshopDialog extends StatefulWidget {
  const _CreateWorkshopDialog({
    required this.onCreated,
    required this.onError,
  });

  final ValueChanged<WorkshopModel> onCreated;
  final ValueChanged<String> onError;

  @override
  State<_CreateWorkshopDialog> createState() => _CreateWorkshopDialogState();
}

class _CreateWorkshopDialogState extends State<_CreateWorkshopDialog> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _seatsController = TextEditingController();
  final _tokenSeatsController = TextEditingController();
  final _priceController = TextEditingController();
  final _dateController = TextEditingController();
  final _categoryController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  final _imagePicker = ImagePicker();

  bool _isPaid = false;
  bool _creating = false;
  String _paymentMethod = 'Credit card';
  Uint8List? _coverImageBytes;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _seatsController.dispose();
    _tokenSeatsController.dispose();
    _priceController.dispose();
    _dateController.dispose();
    _categoryController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickCoverImage() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image == null || !mounted) return;

    final bytes = await image.readAsBytes();
    setState(() => _coverImageBytes = bytes);
  }

  Future<void> _createWorkshop() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      widget.onError('Please enter a workshop name.');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      widget.onError('Please sign in to create a workshop.');
      return;
    }

    setState(() => _creating = true);
    try {
      final workshop = await WorkshopRepository.createWorkshop(
        userId: user.uid,
        creatorName: user.displayName ?? user.email ?? 'Anonymous',
        name: name,
        description: _descController.text.trim(),
        availableSeats: int.tryParse(_seatsController.text.trim()) ?? 0,
        tokenSeats: int.tryParse(_tokenSeatsController.text.trim()) ?? 0,
        isPaid: _isPaid,
        paymentMethod: _paymentMethod,
        price: double.tryParse(_priceController.text.trim()) ?? 0,
        dateTime: _dateController.text.trim(),
        category: _categoryController.text.trim(),
        location: _locationController.text.trim(),
        notes: _notesController.text.trim(),
        coverImageBytes: _coverImageBytes,
      );

      if (!mounted) return;
      Navigator.of(context).pop();
      widget.onCreated(workshop);
    } catch (e) {
      if (mounted) {
        widget.onError(WorkshopRepository.friendlyError(e));
      }
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    final width = media.width * 0.8;
    final height = media.height * 0.8;

    return Center(
      child: Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(18),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: const Color(0xFF0E1119).withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: Colors.white.withValues(alpha: 0.11)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x66000000),
                    blurRadius: 30,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 12, 14),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Create Workshop',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Fill in the details and publish your workshop.',
                                style: TextStyle(color: Color(0xFFB7BECE)),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.white.withValues(alpha: 0.1),
                    height: 1,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                      child: Wrap(
                        spacing: 14,
                        runSpacing: 14,
                        children: [
                          _FormFieldBlock(
                            label: 'Workshop name',
                            child: _StyledTextField(
                              hint: 'Enter workshop name',
                              controller: _nameController,
                            ),
                          ),
                          _FormFieldBlock(
                            label: 'Workshop description',
                            wide: true,
                            child: _StyledTextField(
                              hint: 'Describe what participants will learn',
                              maxLines: 4,
                              controller: _descController,
                            ),
                          ),
                          _FormFieldBlock(
                            label: 'Upload cover image',
                            wide: true,
                            child: _UploadPlaceholder(
                              imageBytes: _coverImageBytes,
                              onTap: _pickCoverImage,
                            ),
                          ),
                          _FormFieldBlock(
                            label: 'Number of seats',
                            child: _StyledTextField(
                              hint: 'e.g. 30',
                              keyboardType: TextInputType.number,
                              controller: _seatsController,
                            ),
                          ),
                          _FormFieldBlock(
                            label: 'Token seats',
                            child: _StyledTextField(
                              hint: 'e.g. 5',
                              keyboardType: TextInputType.number,
                              controller: _tokenSeatsController,
                            ),
                          ),
                          _FormFieldBlock(
                            label: 'Pricing',
                            wide: true,
                            child: Row(
                              children: [
                                Expanded(
                                  child: SwitchListTile(
                                    value: _isPaid,
                                    onChanged: (value) =>
                                        setState(() => _isPaid = value),
                                    title: Text(
                                      _isPaid
                                          ? 'Paid workshop'
                                          : 'Free workshop',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    activeThumbColor: const Color(0xFFFF7A18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_isPaid)
                            _FormFieldBlock(
                              label: 'Payment method',
                              child: _StyledDropdown(
                                value: _paymentMethod,
                                onChanged: (value) =>
                                    setState(() => _paymentMethod = value!),
                                items: const [
                                  'Credit card',
                                  'Wallet',
                                  'Bank transfer',
                                ],
                              ),
                            ),
                          if (_isPaid)
                            _FormFieldBlock(
                              label: 'Price',
                              child: _StyledTextField(
                                hint: 'e.g. 49',
                                keyboardType: TextInputType.number,
                                controller: _priceController,
                              ),
                            ),
                          _FormFieldBlock(
                            label: 'Date and time',
                            child: _StyledTextField(
                              hint: 'May 10, 5:30 PM',
                              controller: _dateController,
                            ),
                          ),
                          _FormFieldBlock(
                            label: 'Category',
                            child: _StyledTextField(
                              hint: 'Design / AI / Business',
                              controller: _categoryController,
                            ),
                          ),
                          _FormFieldBlock(
                            label: 'Location or online link',
                            wide: true,
                            child: _StyledTextField(
                              hint: 'Venue address or meeting link',
                              controller: _locationController,
                            ),
                          ),
                          _FormFieldBlock(
                            label: 'Requirements / notes (optional)',
                            wide: true,
                            child: _StyledTextField(
                              hint: 'Any prerequisites or attendee notes',
                              maxLines: 3,
                              controller: _notesController,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _creating ? null : _createWorkshop,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF7A18),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            disabledBackgroundColor: const Color(
                              0xFFFF7A18,
                            ).withValues(alpha: 0.4),
                          ),
                          child: _creating
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Create Workshop'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormFieldBlock extends StatelessWidget {
  const _FormFieldBlock({
    required this.label,
    required this.child,
    this.wide = false,
  });

  final String label;
  final Widget child;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final blockWidth = wide
        ? width
        : (width > 900 ? (width * 0.8 - 74) / 2 : width);
    return SizedBox(
      width: blockWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _StyledTextField extends StatelessWidget {
  const _StyledTextField({
    required this.hint,
    this.controller,
    this.maxLines = 1,
    this.keyboardType,
  });

  final String hint;
  final TextEditingController? controller;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF98A0B5)),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFFF7A18)),
        ),
      ),
    );
  }
}

class _StyledDropdown extends StatelessWidget {
  const _StyledDropdown({
    required this.value,
    required this.onChanged,
    required this.items,
  });

  final String value;
  final ValueChanged<String?> onChanged;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      dropdownColor: const Color(0xFF101521),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      iconEnabledColor: Colors.white,
      onChanged: onChanged,
      items: items
          .map(
            (item) => DropdownMenuItem<String>(value: item, child: Text(item)),
          )
          .toList(),
    );
  }
}

class _UploadPlaceholder extends StatelessWidget {
  const _UploadPlaceholder({required this.onTap, this.imageBytes});

  final VoidCallback onTap;
  final Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageBytes != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 120,
        decoration: BoxDecoration(
          color: hasImage
              ? const Color(0xFFFF7A18).withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasImage
                ? const Color(0xFFFF7A18)
                : Colors.white.withValues(alpha: 0.15),
          ),
        ),
        child: hasImage
            ? ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.memory(imageBytes!, fit: BoxFit.cover),
                    Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.65),
                          ],
                        ),
                      ),
                      child: const Text(
                        'Tap to change image',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      color: Colors.white70,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Drop image or click to upload',
                      style: TextStyle(color: Color(0xFFC2C8D7)),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Material(
          color: Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(14),
            child: Ink(
              width: 42,
              height: 42,
              child: Icon(icon, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: const Row(
        children: [
          Icon(Icons.auto_awesome_rounded, color: Colors.white70),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'No workshops found for this search. Try another category or query.',
              style: TextStyle(color: Color(0xFFC7CCDA)),
            ),
          ),
        ],
      ),
    );
  }
}
