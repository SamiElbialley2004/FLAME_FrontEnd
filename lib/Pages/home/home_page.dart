import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../features/search_screen.dart';
import '../social/messaging_screen.dart';
import '../social/notifications_screen.dart';
import 'comments_screen.dart';
import 'video_upload_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<_VideoItem> _videos = const [
    _VideoItem(
      id: 'v1',
      creatorName: 'Dr. Amina',
      caption: '3 prompts to learn any topic faster with AI',
      category: 'AI',
      likeCount: 12400,
      comments: '842',
      actionLabel: 'Save for later',
      gradient: [Color(0xFF7C2D12), Color(0xFF9A3412), Color(0xFF09090B)],
    ),
    _VideoItem(
      id: 'v2',
      creatorName: 'DesignWithSam',
      caption: 'How to critique UI like a senior designer',
      category: 'Design',
      likeCount: 8100,
      comments: '513',
      actionLabel: 'Learn more',
      gradient: [Color(0xFF78350F), Color(0xFF9D174D), Color(0xFF09090B)],
    ),
  ];

  Future<void> _openCreateMenu() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF09090B),
      barrierColor: Colors.black54,
      useSafeArea: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const _CreateMenuSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      body: Stack(
        children: [
          PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: _videos.length,
            itemBuilder: (context, index) {
              return _VideoCard(
                item: _videos[index],
                onCreateTap: _openCreateMenu,
              );
            },
          ),
          const _TopHeader(),
        ],
      ),
    );
  }
}

class _VideoCard extends StatefulWidget {
  const _VideoCard({required this.item, required this.onCreateTap});

  final _VideoItem item;
  final Future<void> Function() onCreateTap;

  @override
  State<_VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<_VideoCard> with TickerProviderStateMixin {
  bool _isLiked = false;
  bool _isSaved = false;
  late int _likeCount;

  late final AnimationController _likeBounceController;
  late final Animation<double> _likeBounceScale;

  final List<AnimationController> _heartControllers = [];
  final List<Offset> _heartPositions = [];

  @override
  void initState() {
    super.initState();
    _likeCount = widget.item.likeCount;
    _likeBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _likeBounceScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.35), weight: 45),
      TweenSequenceItem(tween: Tween(begin: 1.35, end: 1.0), weight: 55),
    ]).animate(CurvedAnimation(
      parent: _likeBounceController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _likeBounceController.dispose();
    for (final controller in _heartControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String get _formattedLikeCount => _formatCount(_likeCount);

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
    if (count >= 10000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  void _playLikeBounce() {
    _likeBounceController.forward(from: 0);
  }

  void _spawnHeartAt(Offset localPosition) {
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    final index = _heartControllers.length;

    setState(() {
      _heartControllers.add(controller);
      _heartPositions.add(localPosition);
    });

    controller.forward().then((_) {
      if (!mounted) {
        controller.dispose();
        return;
      }
      setState(() {
        if (index < _heartControllers.length &&
            _heartControllers[index] == controller) {
          _heartControllers.removeAt(index);
          _heartPositions.removeAt(index);
        }
      });
      controller.dispose();
    });
  }

  /// TikTok: side button toggles like on/off and updates the count.
  void _toggleLikeFromButton() {
    HapticFeedback.lightImpact();
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
    _playLikeBounce();
  }

  /// TikTok: double-tap only likes (never unlikes) and shows a heart at the tap point.
  void _handleDoubleTapDown(TapDownDetails details) {
    final box = context.findRenderObject() as RenderBox?;
    final localPosition = box != null
        ? box.globalToLocal(details.globalPosition)
        : details.localPosition;

    HapticFeedback.lightImpact();
    _spawnHeartAt(localPosition);

    if (!_isLiked) {
      setState(() {
        _isLiked = true;
        _likeCount += 1;
      });
      _playLikeBounce();
    }
  }

  void _handleShare() {
    Share.share(
      "Check out ${widget.item.creatorName}'s video on FLAME: ${widget.item.caption}",
    );
  }

  void _handleSave() {
    setState(() => _isSaved = !_isSaved);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isSaved ? "Saved to your list!" : "Removed from list"),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onDoubleTapDown: _handleDoubleTapDown,
          child: Stack(
            children: [
              // Background Gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: widget.item.gradient,
                  ),
                ),
              ),
              Container(color: Colors.black38),

              for (var i = 0; i < _heartControllers.length; i++)
                _FloatingHeart(
                  position: _heartPositions[i],
                  controller: _heartControllers[i],
                ),

              // Side Action Buttons
              Positioned(
                right: 12,
                bottom: 145,
                child: _SideActions(
                  item: widget.item,
                  onCreateTap: widget.onCreateTap,
                  isLiked: _isLiked,
                  likeCountLabel: _formattedLikeCount,
                  likeBounceScale: _likeBounceScale,
                  onLike: _toggleLikeFromButton,
                  onShare: _handleShare,
                ),
              ),

              // Video Text/Context Info
              Positioned(
                left: 12,
                right: 86,
                bottom: 65,
                child: _LearningContext(
                  item: widget.item,
                  isSaved: _isSaved,
                  onSave: _handleSave,
                ),
              ),
            ],
          ),
        ),
        const Positioned(
          left: 12,
          right: 86,
          bottom: 16,
          child: _FeedSearchBar(),
        ),
      ],
    );
  }
}

class _VideoItem {
  final String id;
  final String creatorName;
  final String caption;
  final String category;
  final int likeCount;
  final String comments;
  final String actionLabel;
  final List<Color> gradient;

  const _VideoItem({
    required this.id,
    required this.creatorName,
    required this.caption,
    required this.category,
    required this.likeCount,
    required this.comments,
    required this.actionLabel,
    required this.gradient,
  });
}

class _LearningContext extends StatelessWidget {
  const _LearningContext({
    required this.item,
    required this.isSaved,
    required this.onSave,
  });

  final _VideoItem item;
  final bool isSaved;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.35),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.orange.shade300,
                    child: const Icon(
                      Icons.person,
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.creatorName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      item.category,
                      style: const TextStyle(
                        color: Color(0xFFFED7AA),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                item.caption,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: isSaved ? Colors.orange : Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                    side: BorderSide(
                      color: isSaved
                          ? Colors.orange
                          : Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                onPressed: onSave,
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  size: 18,
                ),
                label: Text(isSaved ? "Saved" : item.actionLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SideActions extends StatelessWidget {
  const _SideActions({
    required this.item,
    required this.onCreateTap,
    required this.isLiked,
    required this.likeCountLabel,
    required this.likeBounceScale,
    required this.onLike,
    required this.onShare,
  });

  final _VideoItem item;
  final Future<void> Function() onCreateTap;
  final bool isLiked;
  final String likeCountLabel;
  final Animation<double> likeBounceScale;
  final VoidCallback onLike;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LikeActionButton(
          isLiked: isLiked,
          label: likeCountLabel,
          bounceScale: likeBounceScale,
          onTap: onLike,
        ),
        const SizedBox(height: 16),
        _ActionIcon(
          icon: Icons.chat_bubble_outline_rounded,
          label: 'Comment',
          value: item.comments,
          onTap: () => CommentsScreen.show(context),
        ),
        const SizedBox(height: 16),
        _ActionIcon(
          icon: Icons.reply_outlined,
          label: 'Share',
          value: 'Share',
          onTap: onShare,
        ),
        const SizedBox(height: 16),
        _CreateActionIcon(onTap: onCreateTap),
      ],
    );
  }
}

class _LikeActionButton extends StatelessWidget {
  const _LikeActionButton({
    required this.isLiked,
    required this.label,
    required this.bounceScale,
    required this.onTap,
  });

  static const _tiktokRed = Color(0xFFFE2C55);

  final bool isLiked;
  final String label;
  final Animation<double> bounceScale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedBuilder(
            animation: bounceScale,
            builder: (context, child) {
              return Transform.scale(
                scale: bounceScale.value,
                child: child,
              );
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: isLiked ? _tiktokRed : Colors.white,
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isLiked ? _tiktokRed : Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingHeart extends StatelessWidget {
  const _FloatingHeart({
    required this.position,
    required this.controller,
  });

  static const _tiktokRed = Color(0xFFFE2C55);

  final Offset position;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final scale = Tween<double>(begin: 0, end: 1.25).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.55, curve: Curves.easeOutBack),
      ),
    );
    final opacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.35, 1, curve: Curves.easeOut),
      ),
    );
    final drift = Tween<double>(begin: 0, end: -28).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Positioned(
          left: position.dx - 44,
          top: position.dy - 44 + drift.value,
          child: Opacity(
            opacity: opacity.value,
            child: Transform.scale(
              scale: scale.value,
              child: child,
            ),
          ),
        );
      },
      child: const Icon(
        Icons.favorite_rounded,
        color: _tiktokRed,
        size: 88,
        shadows: [
          Shadow(color: Color(0x66FE2C55), blurRadius: 18),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader();

  void _openMessages(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const MessagingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _HeaderIconButton(
            icon: Icons.send_rounded,
            tooltip: 'Messages',
            onTap: () => _openMessages(context),
          ),
          const SizedBox(width: 10),
          _HeaderIconButton(
            icon: Icons.notifications_none_rounded,
            tooltip: 'Notifications',
            onTap: () => NotificationsScreen.show(context),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.45),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

class _CreateActionIcon extends StatelessWidget {
  const _CreateActionIcon({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

class _CreateMenuSheet extends StatelessWidget {
  const _CreateMenuSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create with Flame',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          _CreateOptionTile(
            icon: Icons.video_library_outlined,
            title: 'Upload a Reel',
            subtitle: 'Share a quick educational video.',
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const VideoUploadScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CreateOptionTile extends StatelessWidget {
  const _CreateOptionTile({
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
    return Material(
      color: const Color(0xFF18181B),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFFFB923C)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
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

class _FeedSearchBar extends StatelessWidget {
  const _FeedSearchBar();

  void _openSearch(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SearchScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openSearch(context),
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: const Row(
            children: [
              Icon(Icons.search_rounded, color: Colors.white54, size: 20),
              SizedBox(width: 10),
              Text(
                'Search content...',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
