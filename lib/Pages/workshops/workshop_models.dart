import 'package:cloud_firestore/cloud_firestore.dart';

class WorkshopModel {
  const WorkshopModel({
    this.id,
    required this.name,
    required this.description,
    required this.creator,
    required this.dateTime,
    required this.availableSeats,
    required this.tokenSeats,
    required this.isFree,
    required this.price,
    required this.category,
    required this.location,
    required this.imageUrl,
    this.creatorId,
    this.notes,
  });

  final String? id;
  final String name;
  final String description;
  final String creator;
  final String dateTime;
  final int availableSeats;
  final int tokenSeats;
  final bool isFree;
  final double price;
  final String category;
  final String location;
  final String imageUrl;
  final String? creatorId;
  final String? notes;

  String get bookingKey => id ?? name;

  String get priceLabel =>
      isFree ? 'Free' : '\$${price.toStringAsFixed(0)}';

  WorkshopModel copyWith({
    int? availableSeats,
  }) {
    return WorkshopModel(
      id: id,
      name: name,
      description: description,
      creator: creator,
      dateTime: dateTime,
      availableSeats: availableSeats ?? this.availableSeats,
      tokenSeats: tokenSeats,
      isFree: isFree,
      price: price,
      category: category,
      location: location,
      imageUrl: imageUrl,
      creatorId: creatorId,
      notes: notes,
    );
  }

  factory WorkshopModel.fromFirestore(String id, Map<String, dynamic> data) {
    return WorkshopModel(
      id: id,
      name: data['name'] as String? ?? 'Untitled Workshop',
      description: data['description'] as String? ?? '',
      creator: data['creatorName'] as String? ?? 'Creator',
      dateTime: data['dateTime'] as String? ?? 'TBD',
      availableSeats: (data['availableSeats'] as num?)?.toInt() ?? 0,
      tokenSeats: (data['tokenSeats'] as num?)?.toInt() ?? 0,
      isFree: data['isFree'] as bool? ?? true,
      price: (data['price'] as num?)?.toDouble() ?? 0,
      category: data['category'] as String? ?? 'General',
      location: data['location'] as String? ?? 'Online',
      imageUrl: data['coverImageUrl'] as String? ??
          'https://images.unsplash.com/photo-1517048676732-d65bc937f952?w=1200',
      creatorId: data['creatorId'] as String?,
      notes: data['notes'] as String?,
    );
  }

  static const List<WorkshopModel> defaults = [
    WorkshopModel(
      name: 'Creative Branding Sprint',
      description:
          'Learn how to build a magnetic brand system in one practical session.',
      creator: 'Sarah K.',
      dateTime: 'May 10 • 5:30 PM',
      availableSeats: 18,
      tokenSeats: 4,
      isFree: false,
      price: 49.0,
      category: 'Design',
      location: 'Online (Zoom)',
      imageUrl:
          'https://images.unsplash.com/photo-1517048676732-d65bc937f952?w=1200',
    ),
    WorkshopModel(
      name: 'AI Tools for Product Teams',
      description:
          'A practical workflow to automate discovery, writing, and handoff using AI.',
      creator: 'Ibrahim N.',
      dateTime: 'May 14 • 7:00 PM',
      availableSeats: 35,
      tokenSeats: 10,
      isFree: true,
      price: 0,
      category: 'AI',
      location: 'Flame Studio, Cairo',
      imageUrl:
          'https://images.unsplash.com/photo-1677442135136-760c813028c0?w=1200',
    ),
    WorkshopModel(
      name: 'Monetization for Creators',
      description:
          'Build sustainable revenue streams with memberships, products, and events.',
      creator: 'Mona H.',
      dateTime: 'May 19 • 6:00 PM',
      availableSeats: 12,
      tokenSeats: 3,
      isFree: false,
      price: 79.0,
      category: 'Business',
      location: 'Online (Google Meet)',
      imageUrl:
          'https://images.unsplash.com/photo-1552664730-d307ca884978?w=1200',
    ),
    WorkshopModel(
      name: 'Mobile UI Motion Lab',
      description:
          'Design polished interactions with modern motion principles and prototyping patterns.',
      creator: 'Kareem T.',
      dateTime: 'May 22 • 8:00 PM',
      availableSeats: 22,
      tokenSeats: 8,
      isFree: false,
      price: 59.0,
      category: 'Design',
      location: 'Online (Discord Stage)',
      imageUrl:
          'https://images.unsplash.com/photo-1545239351-1141bd82e8a6?w=1200',
    ),
  ];
}

class WorkshopBooking {
  const WorkshopBooking({
    required this.workshopId,
    required this.workshopName,
    required this.organizer,
    required this.dateTime,
    required this.location,
    required this.priceLabel,
    required this.category,
    required this.tokenSeats,
    this.isPast = false,
  });

  final String workshopId;
  final String workshopName;
  final String organizer;
  final String dateTime;
  final String location;
  final String priceLabel;
  final String category;
  final int tokenSeats;
  final bool isPast;

  factory WorkshopBooking.fromMap(Map<String, dynamic> data) {
    return WorkshopBooking(
      workshopId: data['workshopId'] as String? ?? '',
      workshopName: data['workshopName'] as String? ?? 'Workshop',
      organizer: data['organizer'] as String? ?? 'Host',
      dateTime: data['dateTime'] as String? ?? 'TBD',
      location: data['location'] as String? ?? 'Online',
      priceLabel: data['priceLabel'] as String? ?? 'Free',
      category: data['category'] as String? ?? 'General',
      tokenSeats: (data['tokenSeats'] as num?)?.toInt() ?? 0,
      isPast: data['isPast'] as bool? ?? false,
    );
  }
}

class WorkshopRepository {
  static Future<List<WorkshopModel>> fetchWorkshops() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('workshops')
          .orderBy('createdAt', descending: true)
          .get();
      final remote = snap.docs
          .map((d) => WorkshopModel.fromFirestore(d.id, d.data()))
          .toList();
      return [...remote, ...WorkshopModel.defaults];
    } catch (_) {
      return List<WorkshopModel>.from(WorkshopModel.defaults);
    }
  }

  static Future<Set<String>> fetchUserBookingKeys(String userId) async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('workshop_bookings')
          .where('userId', isEqualTo: userId)
          .get();
      return snap.docs
          .map((d) => d.data()['bookingKey'] as String? ?? '')
          .where((k) => k.isNotEmpty)
          .toSet();
    } catch (_) {
      return {};
    }
  }

  static Future<List<WorkshopBooking>> fetchUserBookings(String userId) async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('workshop_bookings')
          .where('userId', isEqualTo: userId)
          .orderBy('bookedAt', descending: true)
          .get();
      return snap.docs
          .map((d) => WorkshopBooking.fromMap(d.data()))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<List<WorkshopModel>> fetchCreatedWorkshops(String userId) async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('workshops')
          .where('creatorId', isEqualTo: userId)
          .get();
      return snap.docs
          .map((d) => WorkshopModel.fromFirestore(d.id, d.data()))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> bookWorkshop({
    required WorkshopModel workshop,
    required String userId,
    required String userName,
  }) async {
    final bookingKey = workshop.bookingKey;
    await FirebaseFirestore.instance.collection('workshop_bookings').add({
      'userId': userId,
      'userName': userName,
      'workshopId': workshop.id ?? bookingKey,
      'bookingKey': bookingKey,
      'workshopName': workshop.name,
      'organizer': workshop.creator,
      'dateTime': workshop.dateTime,
      'location': workshop.location,
      'priceLabel': workshop.priceLabel,
      'category': workshop.category,
      'tokenSeats': workshop.tokenSeats,
      'isPast': false,
      'bookedAt': FieldValue.serverTimestamp(),
    });

    if (workshop.id != null && workshop.availableSeats > 0) {
      await FirebaseFirestore.instance
          .collection('workshops')
          .doc(workshop.id)
          .update({'availableSeats': workshop.availableSeats - 1});
    }
  }
}
