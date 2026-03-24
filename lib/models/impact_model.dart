import 'package:cloud_firestore/cloud_firestore.dart';

class CountryScore {
  final String countryCode;
  final String countryName;
  final int totalGreenScore;

  CountryScore({
    required this.countryCode,
    required this.countryName,
    this.totalGreenScore = 0,
  });

  factory CountryScore.fromFirestore(Map<String, dynamic> data) {
    return CountryScore(
      countryCode: data['countryCode'] ?? '',
      countryName: data['countryName'] ?? '',
      totalGreenScore: data['greenScore'] ?? 0,
    );
  }
}

class KarmaPost {
  final String id;
  final String userId;
  final String imageUrl;
  final GeoPoint location;
  final String description;
  final DateTime timestamp;

  KarmaPost({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.location,
    required this.description,
    required this.timestamp,
  });

  factory KarmaPost.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return KarmaPost(
      id: doc.id,
      userId: data['userId'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      location: data['location'] ?? const GeoPoint(0, 0),
      description: data['description'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
