import 'dart:ui';
import 'package:flutter/material.dart';
import 'notifications_screen.dart';
import 'messaging_screen.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _joinedIds = {};
  final Set<int> _requestedIds = {};
  final Set<int> _bookmarkedIds = {};
  int _selectedTab = 0; // 0 = For You, 1 = Following

  final List<_Community> _communities = const [
    _Community(
      id: 0,
      name: 'Nile University',
      logoText: 'NU',
      location: 'Giza',
      hostName: 'Fatma Selim',
      mutualMembers: 0,
      totalMembers: 15,
      maxMembers: 5000,
      requiresApproval: true,
      categories: [],
      description: '',
      gradientColors: [Color(0xFF1a6b8a), Color(0xFF0e4d6e)],
    ),
    _Community(
      id: 1,
      name: 'TRAVERSE',
      logoText: 'TR',
      location: 'Cairo',
      hostName: 'Zeina Abdelrazaak',
      mutualMembers: 0,
      totalMembers: 15,
      maxMembers: 5000,
      requiresApproval: false,
      categories: [],
      description: '',
      gradientColors: [Color(0xFF6b2fa0), Color(0xFFa855f7)],
    ),
    _Community(
      id: 2,
      name: 'IAMOT',
      logoText: 'IA',
      location: 'International',
      hostName: 'Heba Kaoud',
      mutualMembers: 3,
      totalMembers: 240,
      maxMembers: 5000,
      requiresApproval: false,
      categories: ['Business', 'Technology'],
      description:
          'The International Association for Management of Technology. An international non-profit organization.',
      gradientColors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
    ),
    _Community(
      id: 3,
      name: 'Design Minds',
      logoText: 'DM',
      location: 'Cairo',
      hostName: 'Sara Hassan',
      mutualMembers: 5,
      totalMembers: 87,
      maxMembers: 1000,
      requiresApproval: true,
      categories: ['Design', 'Art'],
      description: 'A creative community for designers and visual artists.',
      gradientColors: [Color(0xFF7C2D12), Color(0xFF9A3412)],
    ),
    _Community(
      id: 4,
      name: 'AI Hub Egypt',
      logoText: 'AI',
      location: 'Cairo',
      hostName: 'Mohamed Tarek',
      mutualMembers: 12,
      totalMembers: 430,
      maxMembers: 5000,
      requiresApproval: false,
      categories: ['Technology', 'AI'],
      description: 'Connecting AI enthusiasts and professionals across Egypt.',
      gradientColors: [Color(0xFF134E4A), Color(0xFF0F766E)],
    ),
  ];

  List<_Community> get _filtered {
    // Following tab: strictly show only joined communities
    var list = _selectedTab == 1
        ? _communities.where((c) => _joinedIds.contains(c.id)).toList()
        : _communities;
    final q = _searchController.text.toLowerCase();
    if (q.isEmpty) return list;
    return list
        .where(
          (c) =>
              c.name.toLowerCase().contains(q) ||
              c.location.toLowerCase().contains(q) ||
              c.categories.any((cat) => cat.toLowerCase().contains(q)),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleJoin(_Community community) {
    if (community.requiresApproval) {
      _showRequestSheet(community);
    } else {
      setState(() {
        if (_joinedIds.contains(community.id)) {
          _joinedIds.remove(community.id);
        } else {
          _joinedIds.add(community.id);
        }
      });
    }
  }

  void _showRequestSheet(_Community community) {
    final notesController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF09090B).withValues(alpha: 0.92),
                border: const Border(
                  top: BorderSide(color: Color(0x1FFFFFFF)),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const Text(
                    'Request to Join',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Send a request to join. The host will review and approve it.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Notes',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: notesController,
                    maxLines: 4,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Any additional info about your request...',
                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.35),
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.07),
                      contentPadding: const EdgeInsets.all(14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Color(0xFFFF7A18),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF7A18), Color(0xFFFFB073)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF7A18).withValues(alpha: 0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          setState(() {
                            _requestedIds.add(community.id);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Request sent to ${community.name}!'),
                              backgroundColor: const Color(0xFFFF7A18),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Submit Request',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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

  Widget _buildEmptyState() {
    final isFollowing = _selectedTab == 1;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF7A18).withValues(alpha: 0.1),
                border: Border.all(color: const Color(0xFFFF7A18).withValues(alpha: 0.3)),
              ),
              child: Icon(
                isFollowing ? Icons.groups_outlined : Icons.search_off_rounded,
                color: const Color(0xFFFF7A18),
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isFollowing ? 'No communities yet' : 'No results found',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isFollowing
                  ? 'Join communities from the For You tab and they will appear here.'
                  : 'Try a different search term.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 13,
                height: 1.45,
              ),
            ),
            if (isFollowing) ...[
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => setState(() => _selectedTab = 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF7A18), Color(0xFFFFB073)],
                    ),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF7A18).withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Discover communities',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showShareSheet(String communityName) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (ctx) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            decoration: BoxDecoration(
              color: const Color(0xFF09090B).withValues(alpha: 0.93),
              border: const Border(top: BorderSide(color: Color(0x1AFFFFFF))),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Share Community',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      communityName,
                      style: const TextStyle(color: Color(0xFFFF7A18), fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _CommShareOption(
                        icon: Icons.chat_rounded,
                        label: 'WhatsApp',
                        color: const Color(0xFF25D366),
                        onTap: () {
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(_snackBar('Opening WhatsApp...'));
                        },
                      ),
                      _CommShareOption(
                        icon: Icons.facebook_rounded,
                        label: 'Facebook',
                        color: const Color(0xFF1877F2),
                        onTap: () {
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(_snackBar('Opening Facebook...'));
                        },
                      ),
                      _CommShareOption(
                        icon: Icons.auto_awesome_rounded,
                        label: 'Flame DM',
                        color: const Color(0xFFFF7A18),
                        onTap: () {
                          Navigator.of(ctx).pop();
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const MessagingScreen()));
                        },
                      ),
                      _CommShareOption(
                        icon: Icons.link_rounded,
                        label: 'Copy Link',
                        color: Colors.white54,
                        onTap: () {
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(_snackBar('Link copied!'));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SnackBar _snackBar(String msg) => SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Text(msg),
          ],
        ),
        backgroundColor: const Color(0xFFFF7A18),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 20),
      );

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0F0A00), Color(0xFF09090B)],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // ── Header ──────────────────────────────────────────────────
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          ShaderMask(
                            shaderCallback: (r) => const LinearGradient(
                              colors: [Color(0xFFFF7A18), Color(0xFFB83280)],
                            ).createShader(r),
                            child: const Text(
                              'Flame',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.07),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => setState(() => _selectedTab = 0),
                                    child: _PillTab(label: 'For You', active: _selectedTab == 0),
                                  ),
                                  GestureDetector(
                                    onTap: () => setState(() => _selectedTab = 1),
                                    child: _PillTab(label: 'Following', active: _selectedTab == 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              IconButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                                ),
                                icon: const Icon(
                                  Icons.notifications_outlined,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFF7A18),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '1',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const MessagingScreen()),
                            ),
                            icon: const Icon(
                              Icons.chat_bubble_outline,
                              size: 22,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Search ───────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search communities...',
                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.35),
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white.withValues(alpha: 0.4),
                        size: 20,
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.06),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Color(0xFFFF7A18),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),

                // ── List ─────────────────────────────────────────────────────
                Expanded(
                  child: filtered.isEmpty
                      ? _buildEmptyState()
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, i) {
                            final c = filtered[i];
                            return _CommunityCard(
                              community: c,
                              isJoined: _joinedIds.contains(c.id),
                              isRequested: _requestedIds.contains(c.id),
                              isBookmarked: _bookmarkedIds.contains(c.id),
                              onJoin: () => _handleJoin(c),
                              onBookmark: () {
                                setState(() {
                                  if (_bookmarkedIds.contains(c.id)) {
                                    _bookmarkedIds.remove(c.id);
                                  } else {
                                    _bookmarkedIds.add(c.id);
                                  }
                                });
                              },
                              onShare: () => _showShareSheet(c.name),
                            );
                          },
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

// ─── Community Card ───────────────────────────────────────────────────────────

class _CommunityCard extends StatelessWidget {
  const _CommunityCard({
    required this.community,
    required this.isJoined,
    required this.isRequested,
    required this.isBookmarked,
    required this.onJoin,
    required this.onBookmark,
    required this.onShare,
  });

  final _Community community;
  final bool isJoined;
  final bool isRequested;
  final bool isBookmarked;
  final VoidCallback onJoin;
  final VoidCallback onBookmark;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top row: logo + name ───────────────────────────────────
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: community.gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          community.logoText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            community.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          if (community.categories.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              children: community.categories
                                  .map(
                                    (cat) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFFFF7A18,
                                        ).withValues(alpha: 0.12),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                        border: Border.all(
                                          color: const Color(
                                            0xFFFF7A18,
                                          ).withValues(alpha: 0.4),
                                        ),
                                      ),
                                      child: Text(
                                        cat,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFFFB073),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),

                // ── Description ──────────────────────────────────────────
                if (community.description.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    community.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.6),
                      height: 1.4,
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
                const SizedBox(height: 12),

                // ── Location ─────────────────────────────────────────────
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: Color(0xFFFF7A18),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      community.location,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // ── Host ─────────────────────────────────────────────────
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: const Color(
                        0xFFFF7A18,
                      ).withValues(alpha: 0.18),
                      child: Text(
                        community.hostName[0],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFF7A18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      community.hostName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ── Mutual + members ──────────────────────────────────────
                Row(
                  children: [
                    Text(
                      community.mutualMembers == 0
                          ? 'No mutual members'
                          : '${community.mutualMembers} mutual members',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.people_outline,
                      size: 14,
                      color: Color(0xFFFF7A18),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${community.totalMembers}/${community.maxMembers}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),

                // ── Approval badge ────────────────────────────────────────
                if (community.requiresApproval && !isRequested) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7A18).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFFF7A18).withValues(alpha: 0.35),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.shield_outlined,
                          size: 16,
                          color: Color(0xFFFFB073),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Approval required to join',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFFFB073),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (isRequested) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF10B981).withValues(alpha: 0.4),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 16,
                          color: Color(0xFF34D399),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Request sent — pending approval',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF34D399),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                // ── Action row ────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(child: _buildJoinButton()),
                    const SizedBox(width: 10),
                    _SmallActionButton(
                      icon: isBookmarked
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: isBookmarked
                          ? const Color(0xFFFF7A18)
                          : Colors.white.withValues(alpha: 0.4),
                      onTap: onBookmark,
                    ),
                    const SizedBox(width: 8),
                    _SmallActionButton(
                      icon: Icons.ios_share_outlined,
                      color: Colors.white.withValues(alpha: 0.4),
                      onTap: onShare,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJoinButton() {
    if (isJoined) {
      return GestureDetector(
        onTap: onJoin,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check, color: Color(0xFFFFB073), size: 18),
              SizedBox(width: 6),
              Text(
                'Joined',
                style: TextStyle(
                  color: Color(0xFFFFB073),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (isRequested) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_top,
              color: Colors.white.withValues(alpha: 0.4),
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              'Requested',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onJoin,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF7A18), Color(0xFFFFB073)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF7A18).withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              community.requiresApproval
                  ? Icons.send_outlined
                  : Icons.person_add_outlined,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              community.requiresApproval ? 'Request to Join' : 'Join',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Small Action Button ──────────────────────────────────────────────────────

class _SmallActionButton extends StatelessWidget {
  const _SmallActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

// ─── Pill Tab ─────────────────────────────────────────────────────────────────

class _PillTab extends StatelessWidget {
  const _PillTab({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        gradient: active
            ? const LinearGradient(
                colors: [Color(0xFFFF7A18), Color(0xFFFFB073)],
              )
            : null,
        color: active ? null : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: active ? Colors.white : Colors.white.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

// ─── Model ────────────────────────────────────────────────────────────────────

class _Community {
  const _Community({
    required this.id,
    required this.name,
    required this.logoText,
    required this.location,
    required this.hostName,
    required this.mutualMembers,
    required this.totalMembers,
    required this.maxMembers,
    required this.requiresApproval,
    required this.categories,
    required this.description,
    required this.gradientColors,
  });

  final int id;
  final String name;
  final String logoText;
  final String location;
  final String hostName;
  final int mutualMembers;
  final int totalMembers;
  final int maxMembers;
  final bool requiresApproval;
  final List<String> categories;
  final String description;
  final List<Color> gradientColors;
}

// ─── Share Option ─────────────────────────────────────────────────────────────

class _CommShareOption extends StatelessWidget {
  const _CommShareOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
