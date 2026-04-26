import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    _VideoItem(
      creatorName: 'Finance Lab',
      caption: 'Budget framework for creators in 60 seconds',
      category: 'Finance',
      likes: '9.7K',
      comments: '611',
      actionLabel: 'Save for later',
      gradient: [Color(0xFF134E4A), Color(0xFF0F766E), Color(0xFF09090B)],
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
      builder: (context) {
        return const _CreateMenuSheet();
      },
    );
  }

  Future<void> _showProfileActions() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF111113),
      barrierColor: Colors.black54,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text(
                    'Sign out',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await FirebaseAuth.instance.signOut();
                  },
                ),
              ],
            ),
          ),
        );
      },
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
              final video = _videos[index];
              return _VideoCard(item: video, onCreateTap: _openCreateMenu);
            },
          ),
          const _TopHeader(),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        selectedIndex: _selectedNavIndex,
        onTap: (index) async {
          if (index == 4) {
            await _showProfileActions();
          }

          setState(() {
            _selectedNavIndex = index;
          });
        },
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        ignoring: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xAA000000), Color(0x00000000)],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                const _BrandLogo(),
                const Spacer(),
                _IconCircleButton(
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                _IconCircleButton(
                  icon: Icons.send_outlined,
                  label: 'Direct messages',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandLogo extends StatelessWidget {
  const _BrandLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFFB923C), Color(0xFFEF4444)],
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'Flame',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _VideoCard extends StatelessWidget {
  const _VideoCard({required this.item, required this.onCreateTap});

  final _VideoItem item;
  final Future<void> Function() onCreateTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: item.gradient,
            ),
          ),
        ),
        Container(color: Colors.black38),
        Positioned(
          right: 12,
          bottom: 145,
          child: _SideActions(item: item, onCreateTap: onCreateTap),
        ),
        Positioned(
          left: 12,
          right: 86,
          bottom: 65,
          child: _LearningContext(item: item),
        ),
        Positioned(
          left: 12,
          right: 86,
          bottom: 16,
          child: const _FeedSearchBar(),
        ),
      ],
    );
  }
}

class _LearningContext extends StatelessWidget {
  const _LearningContext({required this.item});

  final _VideoItem item;

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
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(Icons.bookmark_border, size: 18),
                label: Text(item.actionLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SideActions extends StatelessWidget {
  const _SideActions({required this.item, required this.onCreateTap});

  final _VideoItem item;
  final Future<void> Function() onCreateTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ActionIcon(
          icon: Icons.favorite_border,
          label: 'Like',
          value: item.likes,
        ),
        const SizedBox(height: 16),
        _ActionIcon(
          icon: Icons.chat_bubble_outline,
          label: 'Comment',
          value: item.comments,
        ),
        const SizedBox(height: 16),
        const _ActionIcon(
          icon: Icons.reply_outlined,
          label: 'Share',
          value: 'Share',
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
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return _HoverableActionButton(
      icon: icon,
      label: label,
      value: value,
      onTap: () {},
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.selectedIndex, required this.onTap});

  final int selectedIndex;
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
              active: selectedIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavItem(
              icon: Icons.school_outlined,
              label: 'Workshops',
              active: selectedIndex == 1,
              onTap: () => onTap(1),
            ),
            _NavItem(
              icon: Icons.event_outlined,
              label: 'Events',
              active: selectedIndex == 2,
              onTap: () => onTap(2),
            ),
            _NavItem(
              icon: Icons.groups_outlined,
              label: 'Communities',
              active: selectedIndex == 3,
              onTap: () => onTap(3),
            ),
            _NavItem(
              icon: Icons.person_outline,
              label: 'Profile',
              active: selectedIndex == 4,
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
    final color = active ? Colors.white : Colors.white70;
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
            Text(label, style: TextStyle(color: color, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _CreateActionIcon extends StatelessWidget {
  const _CreateActionIcon({required this.onTap});

  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withValues(alpha: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(26),
            onTap: onTap,
            hoverColor: Colors.orange.withValues(alpha: 0.18),
            child: Ink(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFB923C),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x66FB923C),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 40),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateMenuSheet extends StatelessWidget {
  const _CreateMenuSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Create with Flame',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12),
          _CreateOptionTile(
            icon: Icons.video_library_outlined,
            title: 'Create a Reel',
            subtitle: 'Share a quick educational video.',
          ),
          _CreateOptionTile(
            icon: Icons.menu_book_outlined,
            title: 'Create a Workshop',
            subtitle: 'Host a structured learning session.',
          ),
          _CreateOptionTile(
            icon: Icons.event_available_outlined,
            title: 'Create an Event',
            subtitle: 'Schedule a live or in-person learning event.',
          ),
          _CreateOptionTile(
            icon: Icons.diversity_3_outlined,
            title: 'Create a Community',
            subtitle: 'Start a focused knowledge group.',
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
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => Navigator.of(context).pop(),
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
      ),
    );
  }
}

class _FeedSearchBar extends StatelessWidget {
  const _FeedSearchBar();

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search topics, creators, or workshops',
        hintStyle: const TextStyle(color: Colors.white70, fontSize: 13),
        prefixIcon: const Icon(Icons.search, color: Colors.white70, size: 20),
        filled: true,
        fillColor: Colors.black.withValues(alpha: 0.45),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.orange.withValues(alpha: 0.35)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFFB923C), width: 1.2),
        ),
      ),
    );
  }
}

class _IconCircleButton extends StatelessWidget {
  const _IconCircleButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: Colors.black.withValues(alpha: 0.45),
        foregroundColor: Colors.white,
      ),
      tooltip: label,
      icon: Icon(icon, size: 20),
    );
  }
}

class _HoverableActionButton extends StatefulWidget {
  const _HoverableActionButton({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  State<_HoverableActionButton> createState() => _HoverableActionButtonState();
}

class _HoverableActionButtonState extends State<_HoverableActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isHovered
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.5),
            ),
            child: IconButton(
              onPressed: widget.onTap,
              tooltip: widget.label,
              color: Colors.white,
              icon: Icon(widget.icon),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _VideoItem {
  const _VideoItem({
    required this.creatorName,
    required this.caption,
    required this.category,
    required this.likes,
    required this.comments,
    required this.actionLabel,
    required this.gradient,
  });

  final String creatorName;
  final String caption;
  final String category;
  final String likes;
  final String comments;
  final String actionLabel;
  final List<Color> gradient;
}
