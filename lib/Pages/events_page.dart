import 'dart:ui';
import 'package:flutter/material.dart';
import 'profile_screen.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<_EventItem> _events = const [
    _EventItem(
      name: 'Flame Creator Summit 2025',
      description:
          'An exclusive gathering of top educators, creators, and learners to shape the future of short-form learning.',
      organizer: 'Flame Team',
      dateTime: 'Jun 5 • 10:00 AM',
      location: 'Cairo Tech Hub, Nasr City',
      category: 'Summit',
      imageUrl:
          'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=1200',
      attendees: 320,
      isFree: false,
      price: 120.0,
      isOnline: false,
    ),
    _EventItem(
      name: 'AI in Education Webinar',
      description:
          'Learn how artificial intelligence is transforming how we teach and learn across all disciplines.',
      organizer: 'Ibrahim N.',
      dateTime: 'Jun 12 • 6:00 PM',
      location: 'Online (Zoom)',
      category: 'AI',
      imageUrl:
          'https://images.unsplash.com/photo-1591453089816-0fbb971b454c?w=1200',
      attendees: 540,
      isFree: true,
      price: 0,
      isOnline: true,
    ),
    _EventItem(
      name: 'Design Thinking Bootcamp',
      description:
          'A full-day hands-on bootcamp exploring design thinking methods used by global product teams.',
      organizer: 'Sarah K.',
      dateTime: 'Jun 18 • 9:00 AM',
      location: 'AUC New Cairo',
      category: 'Design',
      imageUrl:
          'https://images.unsplash.com/photo-1558655146-d09347e92766?w=1200',
      attendees: 90,
      isFree: false,
      price: 85.0,
      isOnline: false,
    ),
    _EventItem(
      name: 'Open Mic: Knowledge Night',
      description:
          'A casual evening where creators share short talks on what they\'ve been learning this month.',
      organizer: 'Mona H.',
      dateTime: 'Jun 22 • 7:30 PM',
      location: 'The Greek Campus, Dokki',
      category: 'Community',
      imageUrl:
          'https://images.unsplash.com/photo-1478720568477-152d9b164e26?w=1200',
      attendees: 150,
      isFree: true,
      price: 0,
      isOnline: false,
    ),
  ];

  List<String> get _categories => <String>{
    'All',
    ..._events.map((e) => e.category),
  }.toList();

  List<_EventItem> get _filteredEvents {
    final search = _searchController.text.trim().toLowerCase();
    return _events.where((event) {
      final categoryMatch =
          _selectedCategory == 'All' || event.category == _selectedCategory;
      final searchMatch =
          search.isEmpty ||
          event.name.toLowerCase().contains(search) ||
          event.organizer.toLowerCase().contains(search) ||
          event.description.toLowerCase().contains(search);
      return categoryMatch && searchMatch;
    }).toList();
  }

  Future<void> _openCreateEventDialog() async {
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Create event',
      barrierColor: Colors.black.withValues(alpha: 0.75),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (context, _, _) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, _, __) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.94, end: 1).animate(curved),
            child: const _CreateEventDialog(),
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
    final events = _filteredEvents;

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
                          'Events',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Discover live events, summits, and community meetups.',
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
                                onTap: () =>
                                    setState(() => _selectedCategory = category),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              '${events.length} Events',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            ElevatedButton.icon(
                              onPressed: _openCreateEventDialog,
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
                  sliver: events.isEmpty
                      ? const SliverToBoxAdapter(child: _EmptyState())
                      : SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: isMobile ? 0.82 : 0.88,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            childCount: events.length,
                            (context, index) => _EventCard(
                              event: events[index],
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
    );
  }
}

// ─── Background ───────────────────────────────────────────────────────────────

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

// ─── Header ───────────────────────────────────────────────────────────────────

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
          'Flame Events',
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

// ─── Search & Filter ──────────────────────────────────────────────────────────

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
        hintText: 'Search events, organizers, or topics',
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

// ─── Event Card ───────────────────────────────────────────────────────────────

class _EventCard extends StatefulWidget {
  const _EventCard({required this.event, required this.animationDelay});

  final _EventItem event;
  final int animationDelay;

  @override
  State<_EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<_EventCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.event;
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
                            top: 12,
                            left: 12,
                            child: _PillTag(
                              label: item.isOnline ? 'Online' : 'In-Person',
                              color: item.isOnline
                                  ? const Color(0xFFFF7A18)
                                  : const Color(0xFF10B981),
                            ),
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
                            text: item.organizer,
                          ),
                          _CardDetail(
                            icon: Icons.schedule_rounded,
                            text: item.dateTime,
                          ),
                          _CardDetail(
                            icon: Icons.people_outline_rounded,
                            text: '${item.attendees} attending',
                          ),
                          _CardDetail(
                            icon: item.isOnline
                                ? Icons.language_rounded
                                : Icons.location_on_outlined,
                            text: item.location,
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO(firebase): Connect RSVP/booking flow to Firestore and payments.
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF7A18),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'RSVP',
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
  const _PillTag({required this.label, this.solid = false, this.color});

  final String label;
  final bool solid;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final bg = color ?? (solid ? const Color(0xFFFF7A18) : Colors.black.withValues(alpha: 0.45));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
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

// ─── Empty State ──────────────────────────────────────────────────────────────

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
          Icon(Icons.event_busy_rounded, color: Colors.white70),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'No events found for this search. Try another category or query.',
              style: TextStyle(color: Color(0xFFC7CCDA)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Create Event Dialog ──────────────────────────────────────────────────────

class _CreateEventDialog extends StatefulWidget {
  const _CreateEventDialog();

  @override
  State<_CreateEventDialog> createState() => _CreateEventDialogState();
}

class _CreateEventDialogState extends State<_CreateEventDialog> {
  bool _isPaid = false;
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    final width = media.width * 0.8;
    final height = media.height * 0.82;

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
                                'Create Event',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Schedule a live or in-person learning event.',
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
                            label: 'Event name',
                            child: _StyledTextField(hint: 'Enter event name'),
                          ),
                          const _FormFieldBlock(
                            label: 'Description',
                            wide: true,
                            child: _StyledTextField(
                              hint: 'What will attendees experience?',
                              maxLines: 4,
                            ),
                          ),
                          const _FormFieldBlock(
                            label: 'Upload cover image',
                            wide: true,
                            child: _UploadPlaceholder(),
                          ),
                          const _FormFieldBlock(
                            label: 'Date',
                            child: _StyledTextField(hint: 'e.g. June 5, 2025'),
                          ),
                          const _FormFieldBlock(
                            label: 'Time',
                            child: _StyledTextField(hint: 'e.g. 6:00 PM'),
                          ),
                          _FormFieldBlock(
                            label: 'Event format',
                            wide: true,
                            child: Row(
                              children: [
                                Expanded(
                                  child: SwitchListTile(
                                    value: _isOnline,
                                    onChanged: (v) =>
                                        setState(() => _isOnline = v),
                                    title: Text(
                                      _isOnline ? 'Online event' : 'In-person event',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    activeThumbColor: const Color(0xFFFF7A18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _FormFieldBlock(
                            label: _isOnline ? 'Meeting link' : 'Venue address',
                            wide: true,
                            child: _StyledTextField(
                              hint: _isOnline
                                  ? 'Zoom / Google Meet link'
                                  : 'Full venue address',
                            ),
                          ),
                          const _FormFieldBlock(
                            label: 'Category',
                            child: _StyledTextField(
                              hint: 'Summit / AI / Design / Community',
                            ),
                          ),
                          const _FormFieldBlock(
                            label: 'Expected attendees',
                            child: _StyledTextField(
                              hint: 'e.g. 200',
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
                                    onChanged: (v) =>
                                        setState(() => _isPaid = v),
                                    title: Text(
                                      _isPaid ? 'Paid event' : 'Free event',
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
                            const _FormFieldBlock(
                              label: 'Ticket price',
                              child: _StyledTextField(
                                hint: 'e.g. 120',
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          const _FormFieldBlock(
                            label: 'Additional notes (optional)',
                            wide: true,
                            child: _StyledTextField(
                              hint: 'Schedule, dress code, requirements…',
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
                            // TODO(firebase): Create event document and upload cover image.
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
                          child: const Text('Create Event'),
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

// ─── Form helpers (reused from workshop pattern) ──────────────────────────────

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
    final blockWidth =
        wide ? width : (width > 900 ? (width * 0.8 - 74) / 2 : width);
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

// ─── Data Model ───────────────────────────────────────────────────────────────

class _EventItem {
  const _EventItem({
    required this.name,
    required this.description,
    required this.organizer,
    required this.dateTime,
    required this.location,
    required this.category,
    required this.imageUrl,
    required this.attendees,
    required this.isFree,
    required this.price,
    required this.isOnline,
  });

  final String name;
  final String description;
  final String organizer;
  final String dateTime;
  final String location;
  final String category;
  final String imageUrl;
  final int attendees;
  final bool isFree;
  final double price;
  final bool isOnline;
}
