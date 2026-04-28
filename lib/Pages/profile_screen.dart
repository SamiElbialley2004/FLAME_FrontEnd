import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _Header(),
            const SizedBox(height: 20),
            _StatsSection(),
            const SizedBox(height: 20),
            _MenuSection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

//////////////////// HEADER ////////////////////

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFB923C), Color(0xFF09090B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        // ✅ COVER IMAGE (ASSET FIXED)
        image: DecorationImage(
          image: AssetImage('assets/images/my_image.jpg'),
          fit: BoxFit.cover,
          opacity: 0.5,
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 40,
            right: 20,
            child: Icon(
              Icons.settings_outlined,
              color: Colors.white,
            ),
          ),

          // PROFILE SECTION
          Positioned(
            bottom: 20,
            left: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // PROFILE IMAGE (ASSET FIXED)
                Stack(
                  children: [
                    Container(
                      width: 85,
                      height: 85,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF09090B),
                          width: 3,
                        ),

                        image: const DecorationImage(
                          image: AssetImage(
                            'assets/images/profile_image.jpg',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // edit icon
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFB923C),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 12),

                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Jana Amr",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "@janaamr",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//////////////////// STATS ////////////////////

class _StatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(title: "Following", value: "500"),
          _Divider(),
          _StatItem(title: "Followers", value: "1.2K"),
          _Divider(),
          _StatItem(title: "Learned", value: "54"),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;

  const _StatItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 35,
      color: Colors.white12,
    );
  }
}

//////////////////// MENU ////////////////////

class _MenuSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _MenuItem(
          icon: Icons.video_library_outlined,
          title: "My Learning",
          subtitle: "150 videos",
        ),
        _MenuItem(
          icon: Icons.favorite_border,
          title: "Liked Videos",
          subtitle: "89 videos",
        ),
        _MenuItem(
          icon: Icons.bookmark_border,
          title: "Saved Videos",
          subtitle: "130 videos",
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F24),
              borderRadius: BorderRadius.circular(12),
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
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.white38,
          ),
        ],
      ),
    );
  }
}