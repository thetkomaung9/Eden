class UserModel {
  final String id;
  final String name;
  final int steps;
  final int points;
  final String country;

  UserModel({
    required this.id,
    required this.name,
    this.steps = 0,
    this.points = 0,
    this.country = 'Global',
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      name: data['name'] ?? '',
      steps: data['steps'] ?? 0,
      points: data['points'] ?? 0,
      country: data['country'] ?? 'Global',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'steps': steps,
      'points': points,
      'country': country,
    };
  }
}
