import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'communities_screen.dart';
import 'workshop_page.dart';
import 'events_page.dart';
import 'notifications_screen.dart';
import 'messaging_screen.dart';
import 'search_screen.dart';
import 'video_upload_screen.dart';
import 'comments_screen.dart';
import 'ai_chatbot_screen.dart';

// ─── Data Model ───────────────────────────────────────────────────────────────

class _VideoItem {
  const _VideoItem({
    required this.creatorName,
    required this.caption,
    required this.category,
    required this.likes,
    required this.comments,
    required this.gradient,
  });

  final String creatorName;
  final String caption;
  final String category;
  final int likes;
  final String comments;
  final List<Color> gradient;
}

// ─── Home Page (Root Shell) ───────────────────────────────────────────────────

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      body: IndexedStack(
        index: _tabIndex,
        children: const [
          _FeedView(),
          WorkshopPage(),
          EventsPage(),
          CommunitiesScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _MainNav(
        currentIndex: _tabIndex,
        onTap: (i) => setState(() => _tabIndex = i),
      ),
    );
  }
}

// ─── Main Nav Bar ─────────────────────────────────────────────────────────────

class _MainNav extends StatelessWidget {
  const _MainNav({required this.currentIndex, required this.onTap});

  final int currentIndex;
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
              active: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavItem(
              icon: Icons.school_outlined,
              label: 'Workshops',
              active: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            _NavItem(
              icon: Icons.event_outlined,
              label: 'Events',
              active: currentIndex == 2,
              onTap: () => onTap(2),
            ),
            _NavItem(
              icon: Icons.groups_outlined,
              label: 'Communities',
              active: currentIndex == 3,
              onTap: () => onTap(3),
            ),
            _NavItem(
              icon: Icons.person_outline,
              label: 'Profile',
              active: currentIndex == 4,
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
    final color = active
        ? const Color(0xFFFF7A18)
        : Colors.white.withValues(alpha: 0.5);
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
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: active ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Feed View (Home Tab) ─────────────────────────────────────────────────────

class _FeedView extends StatefulWidget {
  const _FeedView();

  @override
  State<_FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<_FeedView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _videos = [
    _VideoItem(
      creatorName: 'Dr. Amina',
      caption: '3 prompts to learn any topic faster with AI 🤖',
      category: 'AI',
      likes: 12400,
      comments: '842',
      gradient: [Color(0xFF7C2D12), Color(0xFF9A3412), Color(0xFF09090B)],
    ),
    _VideoItem(
      creatorName: 'DesignWithSam',
      caption: 'How to critique UI like a senior designer',
      category: 'Design',
      likes: 8100,
      comments: '513',
      gradient: [Color(0xFF78350F), Color(0xFF9D174D), Color(0xFF09090B)],
    ),
    _VideoItem(
      creatorName: 'Finance Lab',
      caption: 'Budget framework for creators in 60 seconds 💰',
      category: 'Finance',
      likes: 9700,
      comments: '611',
      gradient: [Color(0xFF134E4A), Color(0xFF0F766E), Color(0xFF09090B)],
    ),
    _VideoItem(
      creatorName: 'Ibrahim N.',
      caption: 'Why Cairo tech startups fail in year one',
      category: 'Business',
      likes: 15200,
      comments: '1.1K',
      gradient: [Color(0xFF1E1B4B), Color(0xFF4338CA), Color(0xFF09090B)],
    ),
    _VideoItem(
      creatorName: 'Mona H.',
      caption: 'The psychology of color in product design 🎨',
      category: 'Design',
      likes: 6300,
      comments: '390',
      gradient: [Color(0xFF500724), Color(0xFF9F1239), Color(0xFF09090B)],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage < _videos.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _openCreateMenu() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => const _CreateMenuSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: _videos.length,
          onPageChanged: (page) => setState(() => _currentPage = page),
          itemBuilder: (context, index) => _VideoCard(
            key: ValueKey(index),
            item: _videos[index],
            isActive: index == _currentPage,
            onVideoEnd: _goToNextPage,
          ),
        ),
        _TopBar(
          onSearchTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchScreen()),
          ),
          onNotificationTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
          ),
          onMessageTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MessagingScreen()),
          ),
          onCreateTap: _openCreateMenu,
        ),
      ],
    );
  }
}

// ─── Top Bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.onSearchTap,
    required this.onNotificationTap,
    required this.onMessageTap,
    required this.onCreateTap,
  });

  final VoidCallback onSearchTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onMessageTap;
  final VoidCallback onCreateTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xCC000000), Color(0x00000000)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            children: [
              ShaderMask(
                shaderCallback: (r) => const LinearGradient(
                  colors: [Color(0xFFFF7A18), Color(0xFFFFB073)],
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
              _TopBtn(icon: Icons.add_rounded, onTap: onCreateTap),
              const SizedBox(width: 8),
              _TopBtn(icon: Icons.search_rounded, onTap: onSearchTap),
              const SizedBox(width: 8),
              _TopBtn(
                icon: Icons.notifications_outlined,
                onTap: onNotificationTap,
              ),
              const SizedBox(width: 8),
              _TopBtn(icon: Icons.send_outlined, onTap: onMessageTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBtn extends StatelessWidget {
  const _TopBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.45),
          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        ),
        child: Icon(icon, color: Colors.white, size: 19),
      ),
    );
  }
}

// ─── Video Card ───────────────────────────────────────────────────────────────

class _VideoCard extends StatefulWidget {
  const _VideoCard({
    super.key,
    required this.item,
    required this.isActive,
    required this.onVideoEnd,
  });

  final _VideoItem item;
  final bool isActive;
  final VoidCallback onVideoEnd;

  @override
  State<_VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<_VideoCard> with TickerProviderStateMixin {
  late final AnimationController _progressCtrl;
  late final AnimationController _likeCtrl;
  late final Animation<double> _likeScale;

  bool _isLiked = false;
  bool _isPaused = false;
  bool _showOverlay = false;
  bool _isFollowing = false;
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.item.likes;

    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addStatusListener((s) {
        if (s == AnimationStatus.completed && mounted) widget.onVideoEnd();
      });

    _likeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _likeScale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.55), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.55, end: 1.0), weight: 60),
    ]).animate(CurvedAnimation(parent: _likeCtrl, curve: Curves.easeOut));

    if (widget.isActive) _progressCtrl.forward();
  }

  @override
  void didUpdateWidget(_VideoCard old) {
    super.didUpdateWidget(old);
    if (widget.isActive && !old.isActive) {
      _progressCtrl.reset();
      if (mounted) setState(() { _isPaused = false; _showOverlay = false; });
      _progressCtrl.forward();
    } else if (!widget.isActive && old.isActive) {
      _progressCtrl.stop();
    }
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    _likeCtrl.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
    _likeCtrl.forward(from: 0);
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      _showOverlay = true;
    });
    if (_isPaused) {
      _progressCtrl.stop();
    } else {
      _progressCtrl.forward();
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) setState(() => _showOverlay = false);
      });
    }
  }

  void _share() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Text('Link copied to clipboard!'),
          ],
        ),
        backgroundColor: const Color(0xFFFF7A18),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 90),
      ),
    );
  }

  String get _likesLabel =>
      _likeCount >= 1000 ? '${(_likeCount / 1000).toStringAsFixed(1)}K' : '$_likeCount';

  @override
  Widget build(BuildContext context) {
    const floor = 20.0;

    return GestureDetector(
      onTap: _togglePause,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background gradient ──────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: widget.item.gradient,
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            color: Colors.black.withValues(alpha: _isPaused ? 0.58 : 0.28),
          ),

          // ── Play / Pause overlay ─────────────────────────────────────────
          IgnorePointer(
            child: AnimatedOpacity(
              opacity: (_isPaused || _showOverlay) ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                  child: Icon(
                    _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),

          // ── Progress bar ─────────────────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: floor - 4,
            child: AnimatedBuilder(
              animation: _progressCtrl,
              builder: (_, __) => LinearProgressIndicator(
                value: _progressCtrl.value,
                backgroundColor: Colors.white.withValues(alpha: 0.18),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFFFF7A18)),
                minHeight: 3,
              ),
            ),
          ),

          // ── Right action rail ────────────────────────────────────────────
          Positioned(
            right: 10,
            bottom: floor + 40,
            child: _ActionRail(
              isLiked: _isLiked,
              likeScale: _likeScale,
              likesLabel: _likesLabel,
              comments: widget.item.comments,
              onLike: _toggleLike,
              onComment: () => CommentsScreen.show(context),
              onShare: _share,
              onAI: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AIChatbotScreen()),
              ),
            ),
          ),

          // ── Creator info card ────────────────────────────────────────────
          Positioned(
            left: 12,
            right: 70,
            bottom: floor + 4,
            child: _CreatorCard(
              item: widget.item,
              isFollowing: _isFollowing,
              onFollowToggle: () =>
                  setState(() => _isFollowing = !_isFollowing),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Action Rail (right side) ─────────────────────────────────────────────────

class _ActionRail extends StatelessWidget {
  const _ActionRail({
    required this.isLiked,
    required this.likeScale,
    required this.likesLabel,
    required this.comments,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onAI,
  });

  final bool isLiked;
  final Animation<double> likeScale;
  final String likesLabel;
  final String comments;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onAI;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Like
        _RailBtn(
          onTap: onLike,
          label: likesLabel,
          child: ScaleTransition(
            scale: likeScale,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
              child: Icon(
                isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                key: ValueKey(isLiked),
                color: isLiked ? const Color(0xFFFF4757) : Colors.white,
                size: 28,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Comment
        _RailBtn(
          onTap: onComment,
          label: comments,
          child: const Icon(
            Icons.chat_bubble_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),

        const SizedBox(height: 20),

        // Share
        _RailBtn(
          onTap: onShare,
          label: 'Share',
          child: const Icon(Icons.reply_outlined, color: Colors.white, size: 26),
        ),

        const SizedBox(height: 20),

        // Ask AI
        GestureDetector(
          onTap: onAI,
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF7A18), Color(0xFFB83280)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF7A18).withValues(alpha: 0.45),
                      blurRadius: 14,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Ask AI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RailBtn extends StatelessWidget {
  const _RailBtn({
    required this.child,
    required this.label,
    required this.onTap,
  });

  final Widget child;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withValues(alpha: 0.45),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: Center(child: child),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Creator Info Card ────────────────────────────────────────────────────────

class _CreatorCard extends StatelessWidget {
  const _CreatorCard({
    required this.item,
    required this.isFollowing,
    required this.onFollowToggle,
  });

  final _VideoItem item;
  final bool isFollowing;
  final VoidCallback onFollowToggle;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.42),
            border: Border.all(color: Colors.white.withValues(alpha: 0.13)),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor:
                        const Color(0xFFFF7A18).withValues(alpha: 0.25),
                    child: Text(
                      item.creatorName[0],
                      style: const TextStyle(
                        color: Color(0xFFFF7A18),
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.creatorName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onFollowToggle,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isFollowing
                            ? Colors.white.withValues(alpha: 0.12)
                            : const Color(0xFFFF7A18),
                        borderRadius: BorderRadius.circular(999),
                        border: isFollowing
                            ? Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                              )
                            : null,
                      ),
                      child: Text(
                        isFollowing ? 'Following' : '+ Follow',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      item.category,
                      style: const TextStyle(
                        color: Color(0xFFFED7AA),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.caption,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Create Menu Sheet ────────────────────────────────────────────────────────

class _CreateMenuSheet extends StatelessWidget {
  const _CreateMenuSheet();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
                  'Create with Flame',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                _CreateTile(
                  icon: Icons.video_library_outlined,
                  title: 'Create a Reel',
                  subtitle: 'Share a quick educational video.',
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VideoUploadScreen(),
                      ),
                    );
                  },
                ),
                _CreateTile(
                  icon: Icons.menu_book_outlined,
                  title: 'Host a Workshop',
                  subtitle: 'Lead a structured live learning session.',
                  onTap: () => Navigator.of(context).pop(),
                ),
                _CreateTile(
                  icon: Icons.event_available_outlined,
                  title: 'Create an Event',
                  subtitle: 'Schedule a live or in-person event.',
                  onTap: () => Navigator.of(context).pop(),
                ),
                _CreateTile(
                  icon: Icons.diversity_3_outlined,
                  title: 'Create a Community',
                  subtitle: 'Start a focused knowledge group.',
                  onTap: () => Navigator.of(context).pop(),
                ),
                _CreateTile(
                  icon: Icons.auto_awesome_rounded,
                  title: 'Ask Flame AI',
                  subtitle: 'Get help from your AI learning assistant.',
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AIChatbotScreen(),
                      ),
                    );
                  },
                ),
                _CreateTile(
                  icon: Icons.logout_rounded,
                  title: 'Sign out',
                  subtitle: 'Sign out of your Flame account.',
                  onTap: () async {
                    Navigator.of(context).pop();
                    await FirebaseAuth.instance.signOut();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CreateTile extends StatelessWidget {
  const _CreateTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7A18).withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: const Color(0xFFFF7A18), size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.55),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withValues(alpha: 0.3),
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
