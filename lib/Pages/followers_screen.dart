import 'dart:ui';
import 'package:flutter/material.dart';

class FollowersScreen extends StatefulWidget {
  const FollowersScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  final Set<int> _following = {1, 3, 4};

  final List<_UserEntry> _followers = [
    _UserEntry(id: 0, name: 'Dr. Amina', username: '@dramina', category: 'AI & Learning', followers: '28K'),
    _UserEntry(id: 1, name: 'DesignWithSam', username: '@designwithsam', category: 'Design', followers: '15K'),
    _UserEntry(id: 2, name: 'Finance Lab', username: '@financelab', category: 'Finance', followers: '41K'),
    _UserEntry(id: 3, name: 'Ibrahim N.', username: '@ibrahimn', category: 'AI & Product', followers: '9.3K'),
    _UserEntry(id: 4, name: 'Kareem T.', username: '@kareemt', category: 'Design', followers: '5.1K'),
    _UserEntry(id: 5, name: 'Mona H.', username: '@monah', category: 'Business', followers: '12K'),
  ];

  final List<_UserEntry> _followingList = [
    _UserEntry(id: 1, name: 'DesignWithSam', username: '@designwithsam', category: 'Design', followers: '15K'),
    _UserEntry(id: 3, name: 'Ibrahim N.', username: '@ibrahimn', category: 'AI & Product', followers: '9.3K'),
    _UserEntry(id: 4, name: 'Kareem T.', username: '@kareemt', category: 'Design', followers: '5.1K'),
    _UserEntry(id: 6, name: 'CodeWithAhmed', username: '@codeahmed', category: 'Tech', followers: '7.8K'),
    _UserEntry(id: 7, name: 'Samy E.', username: '@samyelsa', category: 'Business', followers: '3.2K'),
  ];

  List<_UserEntry> _filter(List<_UserEntry> list) {
    if (_query.isEmpty) return list;
    return list.where((u) => u.name.toLowerCase().contains(_query) || u.username.toLowerCase().contains(_query)).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialTab);
    _following.addAll(_followingList.map((u) => u.id));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
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
                      const Text('Jana Amr', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
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
                    Tab(text: 'Followers (${_followers.length})'),
                    Tab(text: 'Following (${_followingList.length})'),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _query = v.toLowerCase()),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: const TextStyle(color: Color(0xFF6B7280)),
                      prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF6B7280)),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.06),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFFF7A18), width: 1.1)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _UserList(users: _filter(_followers), following: _following, onToggle: (id) => setState(() => _following.contains(id) ? _following.remove(id) : _following.add(id))),
                      _UserList(users: _filter(_followingList), following: _following, onToggle: (id) => setState(() => _following.contains(id) ? _following.remove(id) : _following.add(id))),
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

class _UserList extends StatelessWidget {
  const _UserList({required this.users, required this.following, required this.onToggle});

  final List<_UserEntry> users;
  final Set<int> following;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const Center(child: Text('No users found', style: TextStyle(color: Color(0xFF6B7280))));
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: users.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final u = users[i];
        final isFollowing = following.contains(u.id);
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFFFF7A18).withValues(alpha: 0.2),
                    child: Text(u.name[0], style: const TextStyle(color: Color(0xFFFF7A18), fontWeight: FontWeight.w800, fontSize: 18)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(u.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      Text(u.username, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12)),
                      const SizedBox(height: 3),
                      Text('${u.followers} followers  ·  ${u.category}', style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
                    ]),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => onToggle(u.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isFollowing ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFFF7A18),
                        borderRadius: BorderRadius.circular(12),
                        border: isFollowing ? Border.all(color: Colors.white.withValues(alpha: 0.15)) : null,
                      ),
                      child: Text(
                        isFollowing ? 'Following' : 'Follow',
                        style: TextStyle(color: isFollowing ? const Color(0xFFB2B8CB) : Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _UserEntry {
  const _UserEntry({required this.id, required this.name, required this.username, required this.category, required this.followers});

  final int id;
  final String name, username, category, followers;
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
