import 'package:flutter/material.dart';

class _AppColors {
  static const background = Color(0xFF09090B);
  static const surface = Color(0xFF18181B);
  static const primaryOrange = Color(0xFFFB923C);
  static const textPrimary = Colors.white;
  static const textSecondary = Colors.white70;
  static const divider = Colors.white12;
}

class WorkshopsScreen extends StatefulWidget {
  const WorkshopsScreen({super.key});

  @override
  State<WorkshopsScreen> createState() => _WorkshopsScreenState();
}

class _WorkshopsScreenState extends State<WorkshopsScreen> {
  final List<_WorkshopItem> _workshops = const [
    _WorkshopItem(
      title: 'Mastering Flutter UI',
      instructor: 'Samy Elbialley',
      duration: '4 Weeks',
      level: 'Advanced',
      price: 'Free',
      gradient: [Color(0xFF4338CA), Color(0xFF6366F1)],
    ),
    _WorkshopItem(
      title: 'Firebase for Beginners',
      instructor: 'Dr. Amina',
      duration: '2 Weeks',
      level: 'Beginner',
      price: 'Free',
      gradient: [Color(0xFFB45309), Color(0xFFD97706)],
    ),
    _WorkshopItem(
      title: 'UI Design Principles',
      instructor: 'DesignWithSam',
      duration: '3 Weeks',
      level: 'Intermediate',
      price: 'Free',
      gradient: [Color(0xFFBE185D), Color(0xFFDB2777)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppColors.background,
      appBar: AppBar(
        backgroundColor: _AppColors.background,
        elevation: 0,
        title: const Text(
          'Workshops',
          style: TextStyle(color: _AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: _AppColors.textPrimary),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _workshops.length,
        itemBuilder: (context, index) {
          final workshop = _workshops[index];
          return _WorkshopCard(workshop: workshop);
        },
      ),
    );
  }
}

class _WorkshopCard extends StatelessWidget {
  const _WorkshopCard({required this.workshop});

  final _WorkshopItem workshop;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: workshop.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: const Center(
              child: Icon(Icons.school, size: 48, color: Colors.white54),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      workshop.level,
                      style: const TextStyle(color: _AppColors.primaryOrange, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      workshop.duration,
                      style: const TextStyle(color: _AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  workshop.title,
                  style: const TextStyle(color: _AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.white10,
                      child: Text(workshop.instructor[0], style: const TextStyle(fontSize: 10, color: Colors.white)),
                    ),
                    const SizedBox(width: 8),
                    Text(workshop.instructor, style: const TextStyle(color: _AppColors.textSecondary, fontSize: 13)),
                    const Spacer(),
                    Text(workshop.price, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
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

class _WorkshopItem {
  const _WorkshopItem({
    required this.title,
    required this.instructor,
    required this.duration,
    required this.level,
    required this.price,
    required this.gradient,
  });

  final String title;
  final String instructor;
  final String duration;
  final String level;
  final String price;
  final List<Color> gradient;
}
