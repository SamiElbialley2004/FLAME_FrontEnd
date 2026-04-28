import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/components/button.dart';
import 'package:flame/components/text_field.dart';
import 'profile_screen.dart';

class WorkshopPage extends StatefulWidget {
  const WorkshopPage({super.key});

  @override
  State<WorkshopPage> createState() => _WorkshopPageState();
}

class _WorkshopPageState extends State<WorkshopPage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedNavIndex = 1;
  String _selectedCategory = 'All';

  final List<_WorkshopItem> _workshops = const [
    _WorkshopItem(
      name: 'Creative Branding Sprint',
      description:
          'Learn how to build a magnetic brand system in one practical session.',
      creator: 'Sarah K.',
      dateTime: 'May 10 • 5:30 PM',
      availableSeats: 18,
      tokenSeats: 4,
      isFree: false,
      price: 49.0,
      category: 'Design',
      location: 'Online (Zoom)',
      imageUrl:
          'https://images.unsplash.com/photo-1517048676732-d65bc937f952?w=1200',
    ),
    _WorkshopItem(
      name: 'AI Tools for Product Teams',
      description:
          'A practical workflow to automate discovery, writing, and handoff using AI.',
      creator: 'Ibrahim N.',
      dateTime: 'May 14 • 7:00 PM',
      availableSeats: 35,
      tokenSeats: 10,
      isFree: true,
      price: 0,
      category: 'AI',
      location: 'Flame Studio, Cairo',
      imageUrl:
          'https://images.unsplash.com/photo-1677442135136-760c813028c0?w=1200',
    ),
    _WorkshopItem(
      name: 'Monetization for Creators',
      description:
          'Build sustainable revenue streams with memberships, products, and events.',
      creator: 'Mona H.',
      dateTime: 'May 19 • 6:00 PM',
      availableSeats: 12,
      tokenSeats: 3,
      isFree: false,
      price: 79.0,
      category: 'Business',
      location: 'Online (Google Meet)',
      imageUrl:
          'https://images.unsplash.com/photo-1552664730-d307ca884978?w=1200',
    ),
    _WorkshopItem(
      name: 'Mobile UI Motion Lab',
      description:
          'Design polished interactions with modern motion principles and prototyping patterns.',
      creator: 'Kareem T.',
      dateTime: 'May 22 • 8:00 PM',
      availableSeats: 22,
      tokenSeats: 8,
      isFree: false,
      price: 59.0,
      category: 'Design',
      location: 'Online (Discord Stage)',
      imageUrl:
          'https://images.unsplash.com/photo-1545239351-1141bd82e8a6?w=1200',
    ),
  ];

  List<String> get _categories => <String>{
    'All',
    ..._workshops.map((w) => w.category),
  }.toList();

  List<_WorkshopItem> get _filteredWorkshops {
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

  Future<void> _openCreateWorkshopPanel() async {
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Create workshop',
      barrierColor: Colors.black.withValues(alpha: 0.75),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (context, _, _) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, _, __) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.94, end: 1).animate(curved),
            child: const _CreateWorkshopDialog(),
          ),
        );
      },
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
                              onPressed: () {},
                            ),
                            const SizedBox(width: 10),
                            _GlassIconButton(
                              icon: Icons.person_outline_rounded,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ProfileScreen(),
                                  ),
                                );
                              },
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
                          style: TextStyle(color: Color(0xFFC7CCDA), height: 1.3),
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
                            separatorBuilder: (_, _) => const SizedBox(width: 8),
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
                  sliver: workshops.isEmpty
                      ? const SliverToBoxAdapter(child: _EmptyState())
                      : SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: isMobile ? 0.86 : 0.92,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            childCount: workshops.length,
                            (context, index) => _WorkshopCard(
                              workshop: workshops[index],
                              animationDelay: index * 70,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        selectedIndex: _selectedNavIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).maybePop();
            return;
          }

          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
            return;
          }

          setState(() {
            _selectedNavIndex = index;
          });
        },
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
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -70,
            child: _GlowOrb(
              color: const Color(0xFFFF7A18).withValues(alpha: 0.35),
              size: 260,
            ),
          ),
          Positioned(
            bottom: -140,
            left: -90,
            child: _GlowOrb(
              color: const Color(0xFF6D28D9).withValues(alpha: 0.28),
              size: 290,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [BoxShadow(color: color, blurRadius: 120, spreadRadius: 40)],
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
            gradient: LinearGradient(colors: [Color(0xFFFF7A18), Color(0xFFB83280)]),
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
  const _WorkshopCard({required this.workshop, required this.animationDelay});

  final _WorkshopItem workshop;
  final int animationDelay;

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
                  border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
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
                          _CardDetail(icon: Icons.person_outline, text: item.creator),
                          _CardDetail(icon: Icons.schedule_rounded, text: item.dateTime),
                          _CardDetail(
                            icon: Icons.event_seat_outlined,
                            text: '${item.availableSeats} seats • ${item.tokenSeats} token seats',
                          ),
                          _CardDetail(
                            icon: Icons.language_rounded,
                            text: item.location,
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO(firebase): Connect booking flow to Firestore and payments.
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF7A18),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Book',
                                style: TextStyle(fontWeight: FontWeight.w700),
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
  const _CreateWorkshopDialog();

  @override
  State<_CreateWorkshopDialog> createState() => _CreateWorkshopDialogState();
}

class _CreateWorkshopDialogState extends State<_CreateWorkshopDialog> {
  bool _isPaid = false;
  String _paymentMethod = 'Credit card';

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
                                'Build your workshop details and publish later with Firebase.',
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
                  Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                      child: Wrap(
                        spacing: 14,
                        runSpacing: 14,
                        children: [
                          const _FormFieldBlock(
                            label: 'Workshop name',
                            child: _StyledTextField(hint: 'Enter workshop name'),
                          ),
                          const _FormFieldBlock(
                            label: 'Workshop description',
                            wide: true,
                            child: _StyledTextField(
                              hint: 'Describe what participants will learn',
                              maxLines: 4,
                            ),
                          ),
                          const _FormFieldBlock(
                            label: 'Upload cover image',
                            wide: true,
                            child: _UploadPlaceholder(),
                          ),
                          const _FormFieldBlock(
                            label: 'Number of seats',
                            child: _StyledTextField(
                              hint: 'e.g. 30',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const _FormFieldBlock(
                            label: 'Token seats',
                            child: _StyledTextField(
                              hint: 'e.g. 5',
                              keyboardType: TextInputType.number,
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
                                      _isPaid ? 'Paid workshop' : 'Free workshop',
                                      style: const TextStyle(color: Colors.white),
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
                                onChanged: (value) => setState(
                                  () => _paymentMethod = value!,
                                ),
                                items: const [
                                  'Credit card',
                                  'Wallet',
                                  'Bank transfer',
                                ],
                              ),
                            ),
                          if (_isPaid)
                            const _FormFieldBlock(
                              label: 'Price',
                              child: _StyledTextField(
                                hint: 'e.g. 49',
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          const _FormFieldBlock(
                            label: 'Date and time',
                            child: _StyledTextField(hint: 'May 10, 5:30 PM'),
                          ),
                          const _FormFieldBlock(
                            label: 'Category',
                            child: _StyledTextField(hint: 'Design / AI / Business'),
                          ),
                          const _FormFieldBlock(
                            label: 'Location or online link',
                            wide: true,
                            child: _StyledTextField(
                              hint: 'Venue address or meeting link',
                            ),
                          ),
                          const _FormFieldBlock(
                            label: 'Requirements / notes (optional)',
                            wide: true,
                            child: _StyledTextField(
                              hint: 'Any prerequisites or attendee notes',
                              maxLines: 3,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              'TODO(firebase): Connect this form to Firebase Auth, Storage, and Firestore when backend is ready.',
                              style: TextStyle(
                                color: Color(0xFF919AB1),
                                fontSize: 12,
                              ),
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
                          onPressed: () {
                            // TODO(firebase): Create workshop document and upload cover image.
                            Navigator.of(context).pop();
                          },
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
                          ),
                          child: const Text('Create Workshop'),
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
    final blockWidth = wide ? width : (width > 900 ? (width * 0.8 - 74) / 2 : width);
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
    this.maxLines = 1,
    this.keyboardType,
  });

  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
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
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
    );
  }
}

class _UploadPlaceholder extends StatelessWidget {
  const _UploadPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_photo_alternate_outlined, color: Colors.white70),
            SizedBox(height: 8),
            Text(
              'Drop image or click to upload',
              style: TextStyle(color: Color(0xFFC2C8D7)),
            ),
          ],
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

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
        decoration: BoxDecoration(
          color: const Color(0xE509090B),
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavItem(
              icon: Icons.home_outlined,
              label: 'Home',
              active: selectedIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavItem(
              icon: Icons.school_outlined,
              label: 'Workshops',
              active: selectedIndex == 1,
              onTap: () => onTap(1),
            ),
            _NavItem(
              icon: Icons.event_outlined,
              label: 'Events',
              active: selectedIndex == 2,
              onTap: () => onTap(2),
            ),
            _NavItem(
              icon: Icons.groups_outlined,
              label: 'Communities',
              active: selectedIndex == 3,
              onTap: () => onTap(3),
            ),
            _NavItem(
              icon: Icons.person_outline,
              label: 'Profile',
              active: selectedIndex == 4,
              onTap: () => onTap(4),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.white : Colors.white70;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 1),
            Text(label, style: TextStyle(color: color, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _WorkshopItem {
  const _WorkshopItem({
    required this.name,
    required this.description,
    required this.creator,
    required this.dateTime,
    required this.availableSeats,
    required this.tokenSeats,
    required this.isFree,
    required this.price,
    required this.category,
    required this.location,
    required this.imageUrl,
  });

  final String name;
  final String description;
  final String creator;
  final String dateTime;
  final int availableSeats;
  final int tokenSeats;
  final bool isFree;
  final double price;
  final String category;
  final String location;
  final String imageUrl;
}
