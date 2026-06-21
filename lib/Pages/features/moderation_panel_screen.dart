import 'dart:ui';
import 'package:flutter/material.dart';

class ModerationPanelScreen extends StatefulWidget {
  const ModerationPanelScreen({super.key});

  @override
  State<ModerationPanelScreen> createState() => _ModerationPanelScreenState();
}

class _ModerationPanelScreenState extends State<ModerationPanelScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<_ModerationItem> _items = [
    _ModerationItem(id: 0, title: '5 AI tools that changed my workflow', creator: 'NewUser123', category: 'AI', submitted: '2h ago', status: 'pending', gradient: [Color(0xFF1E3A5F), Color(0xFF001020)]),
    _ModerationItem(id: 1, title: 'Quick Figma tips for beginners', creator: 'DesignLearner', category: 'Design', submitted: '4h ago', status: 'pending', gradient: [Color(0xFF78350F), Color(0xFF1A0A00)]),
    _ModerationItem(id: 2, title: 'Basics of stock market investing', creator: 'MoneyMoves', category: 'Finance', submitted: '6h ago', status: 'pending', gradient: [Color(0xFF134E4A), Color(0xFF001A18)]),
    _ModerationItem(id: 3, title: 'Learn Python in 60 seconds', creator: 'CodeFast', category: 'Tech', submitted: '1d ago', status: 'approved', gradient: [Color(0xFF4C1D95), Color(0xFF0A0020)]),
    _ModerationItem(id: 4, title: 'Viral content strategy 2025', creator: 'MarketingGuru', category: 'Business', submitted: '1d ago', status: 'approved', gradient: [Color(0xFF7C2D12), Color(0xFF1A0A00)]),
    _ModerationItem(id: 5, title: 'Get rich quick trick', creator: 'SpamUser99', category: 'Finance', submitted: '2d ago', status: 'rejected', gradient: [Color(0xFF450A0A), Color(0xFF1A0000)]),
  ];

  List<_ModerationItem> _byStatus(String status) => _items.where((i) => i.status == status).toList();

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

  void _approve(int id) => setState(() => _items.firstWhere((i) => i.id == id).status = 'approved');
  void _reject(int id) => setState(() => _items.firstWhere((i) => i.id == id).status = 'rejected');

  @override
  Widget build(BuildContext context) {
    final pending = _byStatus('pending');
    final approved = _byStatus('approved');
    final rejected = _byStatus('rejected');

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
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
                  child: Row(
                    children: [
                      _BackButton(onTap: () => Navigator.of(context).pop()),
                      const SizedBox(width: 12),
                      const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Moderation Panel', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                        Text('Admin only', style: TextStyle(color: Color(0xFFEF4444), fontSize: 12, fontWeight: FontWeight.w600)),
                      ]),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _StatCard(label: 'Pending', count: pending.length, color: const Color(0xFFFF7A18)),
                      const SizedBox(width: 10),
                      _StatCard(label: 'Approved', count: approved.length, color: const Color(0xFF10B981)),
                      const SizedBox(width: 10),
                      _StatCard(label: 'Rejected', count: rejected.length, color: const Color(0xFFEF4444)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                TabBar(
                  controller: _tabController,
                  indicatorColor: const Color(0xFFFF7A18),
                  indicatorWeight: 2,
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF6B7280),
                  labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                  dividerColor: Colors.white.withValues(alpha: 0.08),
                  tabs: [
                    Tab(text: 'Pending (${pending.length})'),
                    Tab(text: 'Approved (${approved.length})'),
                    Tab(text: 'Rejected (${rejected.length})'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _ModerationList(items: pending, onApprove: _approve, onReject: _reject, showActions: true),
                      _ModerationList(items: approved, onApprove: _approve, onReject: _reject),
                      _ModerationList(items: rejected, onApprove: _approve, onReject: _reject),
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

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.count, required this.color});

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withValues(alpha: 0.3))),
        child: Column(
          children: [
            Text('$count', style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _ModerationList extends StatelessWidget {
  const _ModerationList({required this.items, required this.onApprove, required this.onReject, this.showActions = false});

  final List<_ModerationItem> items;
  final ValueChanged<int> onApprove;
  final ValueChanged<int> onReject;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('Nothing here', style: TextStyle(color: Color(0xFF6B7280))));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _ModerationCard(item: items[i], onApprove: onApprove, onReject: onReject, showActions: showActions),
    );
  }
}

class _ModerationCard extends StatelessWidget {
  const _ModerationCard({required this.item, required this.onApprove, required this.onReject, required this.showActions});

  final _ModerationItem item;
  final ValueChanged<int> onApprove;
  final ValueChanged<int> onReject;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: SizedBox(
                  height: 100,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(decoration: BoxDecoration(gradient: LinearGradient(colors: item.gradient))),
                      Container(color: Colors.black26),
                      const Center(child: Icon(Icons.play_circle_outline_rounded, color: Colors.white54, size: 36)),
                      Positioned(top: 10, left: 12,
                        child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFFF7A18), borderRadius: BorderRadius.circular(999)), child: Text(item.category, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)))),
                      Positioned(top: 10, right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: item.status == 'pending' ? const Color(0xFFFF7A18).withValues(alpha: 0.85) : item.status == 'approved' ? const Color(0xFF10B981).withValues(alpha: 0.85) : const Color(0xFFEF4444).withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(item.status.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
                        )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 14, color: Color(0xFF9CA3AF)),
                        const SizedBox(width: 4),
                        Text(item.creator, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12)),
                        const Spacer(),
                        const Icon(Icons.schedule_rounded, size: 14, color: Color(0xFF6B7280)),
                        const SizedBox(width: 4),
                        Text(item.submitted, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                      ],
                    ),
                    if (showActions) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => onReject(item.id),
                              style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFEF4444), side: const BorderSide(color: Color(0xFFEF4444)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                              icon: const Icon(Icons.close_rounded, size: 16),
                              label: const Text('Reject'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => onApprove(item.id),
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                              icon: const Icon(Icons.check_rounded, size: 16),
                              label: const Text('Approve'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModerationItem {
  _ModerationItem({required this.id, required this.title, required this.creator, required this.category, required this.submitted, required this.status, required this.gradient});

  final int id;
  final String title, creator, category, submitted;
  String status;
  final List<Color> gradient;
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
