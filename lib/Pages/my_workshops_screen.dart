import 'dart:ui';
import 'package:flutter/material.dart';

class MyWorkshopsScreen extends StatefulWidget {
  const MyWorkshopsScreen({super.key});

  @override
  State<MyWorkshopsScreen> createState() => _MyWorkshopsScreenState();
}

class _MyWorkshopsScreenState extends State<MyWorkshopsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<_WorkshopEntry> _upcoming = [
    _WorkshopEntry(title: 'Creative Branding Sprint', organizer: 'Sarah K.', dateTime: 'May 10 • 5:30 PM', location: 'Online (Zoom)', price: '\$49', category: 'Design', tokenSeats: 4),
    _WorkshopEntry(title: 'Mobile UI Motion Lab', organizer: 'Kareem T.', dateTime: 'May 22 • 8:00 PM', location: 'Online (Discord)', price: '\$59', category: 'Design', tokenSeats: 8),
  ];

  final List<_WorkshopEntry> _past = [
    _WorkshopEntry(title: 'AI Tools for Product Teams', organizer: 'Ibrahim N.', dateTime: 'Apr 14 • 7:00 PM', location: 'Flame Studio, Cairo', price: 'Free', category: 'AI', tokenSeats: 10),
    _WorkshopEntry(title: 'Monetization for Creators', organizer: 'Mona H.', dateTime: 'Mar 19 • 6:00 PM', location: 'Online (Google Meet)', price: '\$79', category: 'Business', tokenSeats: 3),
  ];

  final List<_WorkshopEntry> _created = [
    _WorkshopEntry(title: 'Intro to Figma Prototyping', organizer: 'You', dateTime: 'Apr 28 • 5:00 PM', location: 'Online (Zoom)', price: '\$35', category: 'Design', tokenSeats: 5),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      body: Stack(
        children: [
          Positioned(top: -80, right: -60, child: _GlowOrb(color: const Color(0xFFFF7A18).withValues(alpha: 0.16), size: 200)),
          Positioned(bottom: -100, left: -60, child: _GlowOrb(color: const Color(0xFF6D28D9).withValues(alpha: 0.14), size: 240)),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Row(
                    children: [
                      _BackButton(onTap: () => Navigator.of(context).pop()),
                      const SizedBox(width: 12),
                      const Text('My Workshops', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
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
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _WorkshopList(items: _upcoming, emptyMessage: 'No upcoming workshops. Browse and book one!', showActions: true),
                      _WorkshopList(items: _past, emptyMessage: 'No past workshops yet.', showRating: true),
                      _WorkshopList(items: _created, emptyMessage: 'You haven\'t created any workshops yet.', showManage: true),
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

class _WorkshopList extends StatelessWidget {
  const _WorkshopList({required this.items, required this.emptyMessage, this.showActions = false, this.showRating = false, this.showManage = false});

  final List<_WorkshopEntry> items;
  final String emptyMessage;
  final bool showActions;
  final bool showRating;
  final bool showManage;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.school_outlined, color: Color(0xFF374151), size: 48),
            const SizedBox(height: 12),
            Text(emptyMessage, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF6B7280))),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _WorkshopCard(item: items[i], showActions: showActions, showRating: showRating, showManage: showManage),
    );
  }
}

class _WorkshopCard extends StatelessWidget {
  const _WorkshopCard({required this.item, required this.showActions, required this.showRating, required this.showManage});

  final _WorkshopEntry item;
  final bool showActions;
  final bool showRating;
  final bool showManage;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFFF7A18).withValues(alpha: 0.18), borderRadius: BorderRadius.circular(999)),
                    child: Text(item.category, style: const TextStyle(color: Color(0xFFFF7A18), fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: item.price == 'Free' ? const Color(0xFF10B981).withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(item.price, style: TextStyle(color: item.price == 'Free' ? const Color(0xFF10B981) : Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(item.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              _Detail(icon: Icons.person_outline, text: item.organizer),
              _Detail(icon: Icons.schedule_rounded, text: item.dateTime),
              _Detail(icon: Icons.language_rounded, text: item.location),
              if (showActions) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: BorderSide(color: Colors.white.withValues(alpha: 0.2)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        icon: const Icon(Icons.calendar_today_outlined, size: 16),
                        label: const Text('Add to Calendar'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF7A18), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        icon: const Icon(Icons.link_rounded, size: 16),
                        label: const Text('Join Link'),
                      ),
                    ),
                  ],
                ),
              ],
              if (showRating) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Rate this workshop:', style: TextStyle(color: Color(0xFFB2B8CB), fontSize: 13)),
                    const SizedBox(width: 8),
                    ...List.generate(5, (i) => Icon(i < 4 ? Icons.star_rounded : Icons.star_border_rounded, color: const Color(0xFFFF7A18), size: 20)),
                  ],
                ),
              ],
              if (showManage) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: BorderSide(color: Colors.white.withValues(alpha: 0.2)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF7A18), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: const Text('Manage'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
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
          Expanded(child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFFB2B8CB), fontSize: 13))),
        ],
      ),
    );
  }
}

class _WorkshopEntry {
  const _WorkshopEntry({required this.title, required this.organizer, required this.dateTime, required this.location, required this.price, required this.category, required this.tokenSeats});

  final String title, organizer, dateTime, location, price, category;
  final int tokenSeats;
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: color, boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 30)]));
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
        width: 40, height: 40,
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.07), shape: BoxShape.circle, border: Border.all(color: Colors.white.withValues(alpha: 0.12))),
        child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
      ),
    );
  }
}
