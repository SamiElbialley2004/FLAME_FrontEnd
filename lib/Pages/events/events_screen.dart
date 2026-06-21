import 'package:flutter/material.dart';

class _AppColors {
  static const background = Color(0xFF09090B);
  static const surface = Color(0xFF18181B);
  static const surfaceElevated = Color(0xFF27272A);
  static const primaryOrange = Color(0xFFFB923C);
  static const secondaryOrange = Color(0xFFEF4444);
  static const textPrimary = Colors.white;
  static const textSecondary = Colors.white70;
  static const divider = Colors.white12;
}

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final List<_EventItem> _events = const [
    _EventItem(
      title: 'AI in Education Summit',
      date: 'Oct 24, 2024 • 6:00 PM',
      location: 'Online • Zoom',
      host: 'Dr. Amina',
      category: 'Technology',
      imageGradient: [Color(0xFF7C2D12), Color(0xFF9A3412)],
    ),
    _EventItem(
      title: 'UI/UX Design Workshop',
      date: 'Nov 02, 2024 • 10:00 AM',
      location: 'Nile University, Giza',
      host: 'DesignWithSam',
      category: 'Design',
      imageGradient: [Color(0xFF134E4A), Color(0xFF0F766E)],
    ),
    _EventItem(
      title: 'Startup Networking Night',
      date: 'Nov 15, 2024 • 7:30 PM',
      location: 'Greek Campus, Cairo',
      host: 'Samy Elbialley',
      category: 'Business',
      imageGradient: [Color(0xFF1E1B4B), Color(0xFF312E81)],
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
          'Events',
          style: TextStyle(
            color: _AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: _AppColors.textPrimary),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          return _EventCard(event: event);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: _AppColors.primaryOrange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});

  final _EventItem event;

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
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: event.imageGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Center(
              child: Icon(
                Icons.event,
                size: 48,
                color: Colors.white.withValues(alpha: 0.5),
              ),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _AppColors.primaryOrange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        event.category,
                        style: const TextStyle(
                          color: _AppColors.primaryOrange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.bookmark_border,
                      color: _AppColors.textSecondary,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  event.title,
                  style: const TextStyle(
                    color: _AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: _AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Text(
                      event.date,
                      style: const TextStyle(color: _AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: _AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Text(
                      event.location,
                      style: const TextStyle(color: _AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: _AppColors.primaryOrange.withValues(alpha: 0.2),
                      child: Text(
                        event.host[0],
                        style: const TextStyle(fontSize: 10, color: _AppColors.primaryOrange),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Hosted by ${event.host}',
                      style: const TextStyle(
                        color: _AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _AppColors.primaryOrange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: const Text('Register'),
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

class _EventItem {
  const _EventItem({
    required this.title,
    required this.date,
    required this.location,
    required this.host,
    required this.category,
    required this.imageGradient,
  });

  final String title;
  final String date;
  final String location;
  final String host;
  final String category;
  final List<Color> imageGradient;
}
