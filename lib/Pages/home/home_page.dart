import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../profile/profile_screen.dart';
import '../social/communities/communities_screen.dart';
import '../events/events_screen.dart';
import '../workshops/workshops_screen.dart';
import 'comments_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedNavIndex = 0;

  final List<_VideoItem> _videos = const [
    _VideoItem(
      creatorName: 'Dr. Amina',
      caption: '3 prompts to learn any topic faster with AI',
      category: 'AI',
      likes: '12.4K',
      comments: '842',
      actionLabel: 'Save for later',
      gradient: [Color(0xFF7C2D12), Color(0xFF9A3412), Color(0xFF09090B)],
    ),
    _VideoItem(
      creatorName: 'DesignWithSam',
      caption: 'How to critique UI like a senior designer',
      category: 'Design',
      likes: '8.1K',
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
                  onCreateTap: _openCreateMenu
              );
            },
          ),
          const _TopHeader(),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        selectedIndex: _selectedNavIndex,
        onTap: (index) {
          if (index == 0) {
            setState(() => _selectedNavIndex = index);
          } else {
            Widget nextPage;
            switch (index) {
              case 1: nextPage = const WorkshopsScreen(); break;
              case 2: nextPage = const EventsScreen(); break;
              case 3: nextPage = const CommunitiesScreen(); break;
              case 4: nextPage = const ProfileScreen(); break;
              default: return;
            }
            Navigator.push(context, MaterialPageRoute(builder: (_) => nextPage));
          }
        },
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

class _VideoCardState extends State<_VideoCard> {
  bool isLiked = false;
  bool isSaved = false;

  // Unified Like Logic (No more popup message)
  void _handleLike() {
    setState(() => isLiked = !isLiked);
  }

  void _handleShare() {
    Share.share("Check out ${widget.item.creatorName}'s video on FLAME: ${widget.item.caption}");
  }

  void _handleSave() {
    setState(() => isSaved = !isSaved);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isSaved ? "Saved to your list!" : "Removed from list"),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Detect double tap on the screen to like
      onDoubleTap: _handleLike,
      child: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: widget.item.gradient,
              ),
            ),
          ),
          Container(color: Colors.black38),

          // Side Action Buttons
          Positioned(
            right: 12,
            bottom: 145,
            child: _SideActions(
              item: widget.item,
              onCreateTap: widget.onCreateTap,
              isLiked: isLiked,
              onLike: _handleLike,
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
              isSaved: isSaved,
              onSave: _handleSave,
            ),
          ),

          const Positioned(
            left: 12, right: 86, bottom: 16,
            child: _FeedSearchBar(),
          ),
        ],
      ),
    );
  }
}

class _VideoItem {
  final String creatorName;
  final String caption;
  final String category;
  final String likes;
  final String comments;
  final String actionLabel;
  final List<Color> gradient;

  const _VideoItem({
    required this.creatorName,
    required this.caption,
    required this.category,
    required this.likes,
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
                    child: const Icon(Icons.person, color: Colors.black, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(item.creatorName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
                    ),
                    child: Text(item.category, style: const TextStyle(color: Color(0xFFFED7AA), fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(item.caption, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.25)),
              const SizedBox(height: 12),
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: isSaved ? Colors.orange : Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                    side: BorderSide(color: isSaved ? Colors.orange : Colors.white.withValues(alpha: 0.2)),
                  ),
                ),
                onPressed: onSave,
                icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border, size: 18),
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
    required this.onLike,
    required this.onShare,
  });

  final _VideoItem item;
  final Future<void> Function() onCreateTap;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ActionIcon(
          icon: isLiked ? Icons.favorite : Icons.favorite_border,
          label: 'Like',
          value: item.likes,
          color: isLiked ? Colors.red : Colors.white,
          onTap: onLike,
        ),
        const SizedBox(height: 16),
        _ActionIcon(
          icon: Icons.chat_bubble_outline,
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

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    this.color = Colors.white,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader();
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50, left: 20, right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("For You", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.white), onPressed: () {}),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.selectedIndex, required this.onTap});
  final int selectedIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.white54,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.work), label: "Workshops"),
        BottomNavigationBarItem(icon: Icon(Icons.event), label: "Events"),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: "Groups"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
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
        decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

class _CreateMenuSheet extends StatelessWidget {
  const _CreateMenuSheet();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: const Center(child: Text("Upload Video Options", style: TextStyle(color: Colors.white))),
    );
  }
}

class _FeedSearchBar extends StatelessWidget {
  const _FeedSearchBar();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 40,
      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20)),
      child: const Row(
        children: [
          Icon(Icons.search, color: Colors.white54, size: 20),
          SizedBox(width: 10),
          const Text("Search content...", style: TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }
}
