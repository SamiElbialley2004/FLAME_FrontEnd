import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import 'workshop_models.dart';

class MyWorkshopsScreen extends StatefulWidget {
  const MyWorkshopsScreen({super.key});

  @override
  State<MyWorkshopsScreen> createState() => _MyWorkshopsScreenState();
}

class _MyWorkshopsScreenState extends State<MyWorkshopsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _loading = true;

  List<WorkshopBooking> _upcoming = [];
  List<WorkshopBooking> _past = [];
  List<WorkshopModel> _created = [];

  static final List<WorkshopBooking> _fallbackUpcoming = [
    WorkshopBooking(
      workshopId: 'mock-1',
      workshopName: 'Creative Branding Sprint',
      organizer: 'Sarah K.',
      dateTime: 'May 10 • 5:30 PM',
      location: 'https://zoom.us/j/example',
      priceLabel: r'$49',
      category: 'Design',
      tokenSeats: 4,
    ),
    WorkshopBooking(
      workshopId: 'mock-2',
      workshopName: 'Mobile UI Motion Lab',
      organizer: 'Kareem T.',
      dateTime: 'May 22 • 8:00 PM',
      location: 'https://discord.gg/example',
      priceLabel: r'$59',
      category: 'Design',
      tokenSeats: 8,
    ),
  ];

  static final List<WorkshopBooking> _fallbackPast = [
    WorkshopBooking(
      workshopId: 'mock-3',
      workshopName: 'AI Tools for Product Teams',
      organizer: 'Ibrahim N.',
      dateTime: 'Apr 14 • 7:00 PM',
      location: 'Flame Studio, Cairo',
      priceLabel: 'Free',
      category: 'AI',
      tokenSeats: 10,
      isPast: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _upcoming = _fallbackUpcoming;
        _past = _fallbackPast;
        _loading = false;
      });
      return;
    }

    final bookings = await WorkshopRepository.fetchUserBookings(user.uid);
    final created = await WorkshopRepository.fetchCreatedWorkshops(user.uid);

    final upcoming = bookings.where((b) => !b.isPast).toList();
    final past = bookings.where((b) => b.isPast).toList();

    if (!mounted) return;
    setState(() {
      _upcoming = upcoming.isEmpty ? _fallbackUpcoming : upcoming;
      _past = past.isEmpty ? _fallbackPast : past;
      _created = created;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showSnack(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? const Color(0xFF10B981) : Colors.deepOrange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -60,
            child: _GlowOrb(
              color: const Color(0xFFFF7A18).withValues(alpha: 0.16),
              size: 200,
            ),
          ),
          Positioned(
            bottom: -100,
            left: -60,
            child: _GlowOrb(
              color: const Color(0xFF6D28D9).withValues(alpha: 0.14),
              size: 240,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Row(
                    children: [
                      _BackButton(onTap: () => Navigator.of(context).pop()),
                      const SizedBox(width: 12),
                      const Text(
                        'My Workshops',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                TabBar(
                  controller: _tabController,
                  indicatorColor: const Color(0xFFFF7A18),
                  indicatorWeight: 2,
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF6B7280),
                  labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                  dividerColor: Colors.white.withValues(alpha: 0.08),
                  tabs: [
                    Tab(text: 'Upcoming (${_upcoming.length})'),
                    Tab(text: 'Past (${_past.length})'),
                    Tab(text: 'Created (${_created.length})'),
                  ],
                ),
                Expanded(
                  child: _loading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFFF7A18),
                          ),
                        )
                      : TabBarView(
                          controller: _tabController,
                          children: [
                            _BookingList(
                              items: _upcoming,
                              emptyMessage:
                                  'No upcoming workshops. Browse and book one!',
                              showActions: true,
                              onSnack: _showSnack,
                            ),
                            _BookingList(
                              items: _past,
                              emptyMessage: 'No past workshops yet.',
                              showRating: true,
                              onSnack: _showSnack,
                            ),
                            _CreatedList(
                              items: _created,
                              emptyMessage:
                                  "You haven't created any workshops yet.",
                              onSnack: _showSnack,
                              onRefresh: _loadData,
                            ),
                          ],
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

class _BookingList extends StatelessWidget {
  const _BookingList({
    required this.items,
    required this.emptyMessage,
    required this.onSnack,
    this.showActions = false,
    this.showRating = false,
  });

  final List<WorkshopBooking> items;
  final String emptyMessage;
  final void Function(String message, {bool success}) onSnack;
  final bool showActions;
  final bool showRating;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _EmptyList(message: emptyMessage);
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _BookingCard(
        item: items[i],
        showActions: showActions,
        showRating: showRating,
        onSnack: onSnack,
      ),
    );
  }
}

class _CreatedList extends StatelessWidget {
  const _CreatedList({
    required this.items,
    required this.emptyMessage,
    required this.onSnack,
    required this.onRefresh,
  });

  final List<WorkshopModel> items;
  final String emptyMessage;
  final void Function(String message, {bool success}) onSnack;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _EmptyList(message: emptyMessage);
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _CreatedCard(
        item: items[i],
        onSnack: onSnack,
        onRefresh: onRefresh,
      ),
    );
  }
}

class _BookingCard extends StatefulWidget {
  const _BookingCard({
    required this.item,
    required this.showActions,
    required this.showRating,
    required this.onSnack,
  });

  final WorkshopBooking item;
  final bool showActions;
  final bool showRating;
  final void Function(String message, {bool success}) onSnack;

  @override
  State<_BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<_BookingCard> {
  int _rating = 0;

  void _addToCalendar() {
    final text =
        '${widget.item.workshopName}\n${widget.item.dateTime}\n${widget.item.location}';
    Clipboard.setData(ClipboardData(text: text));
    widget.onSnack('Workshop details copied — paste into your calendar.', success: true);
  }

  void _openJoinLink() {
    final link = widget.item.location;
    if (link.startsWith('http')) {
      Share.share('Join my workshop: ${widget.item.workshopName}\n$link');
    } else {
      Clipboard.setData(ClipboardData(text: link));
      widget.onSnack('Location copied to clipboard.', success: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TagsRow(category: item.category, price: item.priceLabel),
          const SizedBox(height: 10),
          Text(
            item.workshopName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          _Detail(icon: Icons.person_outline, text: item.organizer),
          _Detail(icon: Icons.schedule_rounded, text: item.dateTime),
          _Detail(icon: Icons.language_rounded, text: item.location),
          if (widget.showActions) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _addToCalendar,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.calendar_today_outlined, size: 16),
                    label: const Text('Add to Calendar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _openJoinLink,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7A18),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.link_rounded, size: 16),
                    label: const Text('Join Link'),
                  ),
                ),
              ],
            ),
          ],
          if (widget.showRating) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Text(
                  'Rate this workshop:',
                  style: TextStyle(color: Color(0xFFB2B8CB), fontSize: 13),
                ),
                const SizedBox(width: 8),
                ...List.generate(5, (i) {
                  return GestureDetector(
                    onTap: () {
                      setState(() => _rating = i + 1);
                      widget.onSnack(
                        'Thanks for rating ${item.workshopName}!',
                        success: true,
                      );
                    },
                    child: Icon(
                      i < _rating
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: const Color(0xFFFF7A18),
                      size: 20,
                    ),
                  );
                }),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _CreatedCard extends StatelessWidget {
  const _CreatedCard({
    required this.item,
    required this.onSnack,
    required this.onRefresh,
  });

  final WorkshopModel item;
  final void Function(String message, {bool success}) onSnack;
  final VoidCallback onRefresh;

  Future<void> _editWorkshop(BuildContext context) async {
    final controller = TextEditingController(text: item.name);
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF18181B),
        title: const Text('Edit workshop', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Workshop name',
            labelStyle: TextStyle(color: Color(0xFFB2B8CB)),
          ),
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
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (saved != true || item.id == null) {
      if (saved == true) onSnack('Only Firebase workshops can be edited.');
      controller.dispose();
      return;
    }
    try {
      await FirebaseFirestore.instance
          .collection('workshops')
          .doc(item.id)
          .update({'name': controller.text.trim()});
      controller.dispose();
      onSnack('Workshop updated.', success: true);
      onRefresh();
    } catch (_) {
      controller.dispose();
      onSnack('Failed to update workshop.');
    }
  }

  void _manageWorkshop(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF18181B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${item.availableSeats} seats available • ${item.tokenSeats} token seats',
              style: const TextStyle(color: Color(0xFFB2B8CB)),
            ),
            const SizedBox(height: 8),
            Text(
              item.dateTime,
              style: const TextStyle(color: Color(0xFFB2B8CB)),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Share.share(
                    'Join my workshop "${item.name}" on Flame!\n${item.location}',
                  );
                },
                icon: const Icon(Icons.share_outlined),
                label: const Text('Share workshop'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7A18),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TagsRow(category: item.category, price: item.priceLabel),
          const SizedBox(height: 10),
          Text(
            item.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          _Detail(icon: Icons.person_outline, text: item.creator),
          _Detail(icon: Icons.schedule_rounded, text: item.dateTime),
          _Detail(icon: Icons.language_rounded, text: item.location),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _editWorkshop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _manageWorkshop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7A18),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Manage'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _TagsRow extends StatelessWidget {
  const _TagsRow({required this.category, required this.price});

  final String category;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFF7A18).withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            category,
            style: const TextStyle(
              color: Color(0xFFFF7A18),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: price == 'Free'
                ? const Color(0xFF10B981).withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            price,
            style: TextStyle(
              color: price == 'Free' ? const Color(0xFF10B981) : Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.school_outlined, color: Color(0xFF374151), size: 48),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF9CA3AF)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFFB2B8CB), fontSize: 13),
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
        boxShadow: [
          BoxShadow(color: color, blurRadius: 100, spreadRadius: 30),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.07),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}
