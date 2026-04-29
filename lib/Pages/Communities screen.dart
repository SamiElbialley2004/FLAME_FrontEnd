import 'package:flutter/material.dart';

// ─── Color Palette ────────────────────────────────────────────────────────────
class _AppColors {
  static const background = Color(0xFF1D1A1A);
  static const surface = Color(0xFF353030);
  static const surfaceElevated = Color(0xFF3E3939);
  static const primaryOrange = Color(0xFFD7640C);
  static const lightPeach = Color(0xFFFBBE89);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFAAAAAA);
  static const textMuted = Color(0xFF777777);
  static const divider = Color(0xFF444040);
  static const badgeWarning = Color(0xFF5A3A00);
  static const badgeWarningText = Color(0xFFFBBE89);
  static const badgeSuccess = Color(0xFF0A3A1A);
  static const badgeSuccessText = Color(0xFF4ADE80);
}

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
      'The International Association for Management of Technology. It is an international non-profit organization.',
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
    final q = _searchController.text.toLowerCase();
    if (q.isEmpty) return _communities;
    return _communities
        .where(
          (c) =>
      c.name.toLowerCase().contains(q) ||
          c.location.toLowerCase().contains(q) ||
          c.categories.any((cat) => cat.toLowerCase().contains(q)),
    )
        .toList();
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
      backgroundColor: _AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
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
                    color: _AppColors.divider,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const Text(
                'Request to Join',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Send a request to join. The host will review and approve it.',
                style: TextStyle(fontSize: 14, color: _AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              const Text(
                'Notes',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: notesController,
                maxLines: 4,
                style: const TextStyle(fontSize: 14, color: _AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Any additional info about your request...',
                  hintStyle: const TextStyle(color: _AppColors.textMuted),
                  filled: true,
                  fillColor: _AppColors.surfaceElevated,
                  contentPadding: const EdgeInsets.all(14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: _AppColors.primaryOrange,
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
                      colors: [_AppColors.primaryOrange, _AppColors.lightPeach],
                    ),
                    borderRadius: BorderRadius.circular(14),
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
                          backgroundColor: _AppColors.primaryOrange,
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: _AppColors.background,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────────
          Container(
            color: _AppColors.surface,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              bottom: 12,
            ),
            child: Row(
              children: [
                // Brand
                const Text(
                  'Flame',
                  style: TextStyle(
                    color: _AppColors.primaryOrange,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const Spacer(),
                // For You / Following pills
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: const [
                      _PillTab(label: 'For You', active: true),
                      _PillTab(label: 'Following', active: false),
                    ],
                  ),
                ),
                const Spacer(),
                // Bell
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_outlined, size: 24),
                      color: _AppColors.textPrimary,
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: _AppColors.primaryOrange,
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
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline, size: 22),
                  color: _AppColors.textPrimary,
                ),
              ],
            ),
          ),

          // ── Search ───────────────────────────────────────────────────────────
          Container(
            color: _AppColors.surface,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(fontSize: 14, color: _AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search communities...',
                hintStyle: const TextStyle(color: _AppColors.textMuted, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: _AppColors.textMuted, size: 20),
                filled: true,
                fillColor: _AppColors.surfaceElevated,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: _AppColors.divider, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: _AppColors.primaryOrange, width: 1.5),
                ),
              ),
            ),
          ),

          // Thin divider between header and list
          Container(height: 1, color: _AppColors.divider),

          // ── List ─────────────────────────────────────────────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
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
                  onShare: () {},
                );
              },
            ),
          ),
        ],
      ),

      // ── FAB ──────────────────────────────────────────────────────────────────
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [_AppColors.primaryOrange, _AppColors.lightPeach],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x66D7640C),
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
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
    return Container(
      decoration: BoxDecoration(
        color: _AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _AppColors.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row: logo + name ─────────────────────────────────────────
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
                    border: Border.all(color: _AppColors.divider),
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
                          color: _AppColors.textPrimary,
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
                                color: const Color(0xFF2A1F00),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: _AppColors.primaryOrange.withValues(alpha: 0.5),
                                ),
                              ),
                              child: Text(
                                cat,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _AppColors.lightPeach,
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

            // ── Description ──────────────────────────────────────────────────
            if (community.description.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                community.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: _AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],

            const SizedBox(height: 12),

            // ── Divider ──────────────────────────────────────────────────────
            Container(height: 1, color: _AppColors.divider),
            const SizedBox(height: 12),

            // ── Location ─────────────────────────────────────────────────────
            Row(
              children: const [
                Icon(Icons.location_on_outlined, size: 15, color: _AppColors.primaryOrange),
                SizedBox(width: 4),
                Text(
                  '',
                  style: TextStyle(fontSize: 13, color: _AppColors.textSecondary),
                ),
              ],
            ),

            // We rebuild location text with community data:
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 15, color: _AppColors.primaryOrange),
                const SizedBox(width: 4),
                Text(
                  community.location,
                  style: const TextStyle(fontSize: 13, color: _AppColors.textSecondary),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // ── Host ─────────────────────────────────────────────────────────
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: _AppColors.primaryOrange.withValues(alpha: 0.2),
                  child: Text(
                    community.hostName[0],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _AppColors.primaryOrange,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  community.hostName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _AppColors.textPrimary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Mutual + members ─────────────────────────────────────────────
            Row(
              children: [
                Text(
                  community.mutualMembers == 0
                      ? 'No mutual members'
                      : '${community.mutualMembers} mutual members',
                  style: const TextStyle(fontSize: 12, color: _AppColors.textMuted),
                ),
                const Spacer(),
                const Icon(Icons.people_outline, size: 14, color: _AppColors.primaryOrange),
                const SizedBox(width: 4),
                Text(
                  '${community.totalMembers}/${community.maxMembers}',
                  style: const TextStyle(fontSize: 12, color: _AppColors.textSecondary),
                ),
              ],
            ),

            // ── Approval badge ───────────────────────────────────────────────
            if (community.requiresApproval && !isRequested) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                decoration: BoxDecoration(
                  color: _AppColors.badgeWarning,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _AppColors.primaryOrange.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.shield_outlined, size: 16, color: _AppColors.lightPeach),
                    SizedBox(width: 8),
                    Text(
                      'Approval required to join',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _AppColors.badgeWarningText,
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
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                decoration: BoxDecoration(
                  color: _AppColors.badgeSuccess,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF166534)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.check_circle_outline, size: 16, color: _AppColors.badgeSuccessText),
                    SizedBox(width: 8),
                    Text(
                      'Request sent — pending approval',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _AppColors.badgeSuccessText,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 12),

            // ── Action row ───────────────────────────────────────────────────
            Row(
              children: [
                Expanded(child: _buildJoinButton()),
                const SizedBox(width: 10),
                _SmallActionButton(
                  icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked ? _AppColors.primaryOrange : _AppColors.textMuted,
                  onTap: onBookmark,
                ),
                const SizedBox(width: 8),
                _SmallActionButton(
                  icon: Icons.ios_share_outlined,
                  color: _AppColors.textMuted,
                  onTap: onShare,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJoinButton() {
    // Already joined
    if (isJoined) {
      return GestureDetector(
        onTap: onJoin,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: _AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _AppColors.divider),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.check, color: _AppColors.lightPeach, size: 18),
              SizedBox(width: 6),
              Text(
                'Joined',
                style: TextStyle(
                  color: _AppColors.lightPeach,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Request already sent
    if (isRequested) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: _AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _AppColors.divider),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.hourglass_top, color: _AppColors.textMuted, size: 18),
            SizedBox(width: 6),
            Text(
              'Requested',
              style: TextStyle(
                color: _AppColors.textMuted,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }

    // Join / Request to join (gradient button)
    return GestureDetector(
      onTap: onJoin,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_AppColors.primaryOrange, _AppColors.lightPeach],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: _AppColors.primaryOrange.withValues(alpha: 0.35),
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
          color: _AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _AppColors.divider),
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
          colors: [_AppColors.primaryOrange, _AppColors.lightPeach],
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
          color: active ? Colors.white : _AppColors.textMuted,
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