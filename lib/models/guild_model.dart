class Guild {
  final String id;
  final String name;
  final int totalTrees;
  final String country;

  Guild({
    required this.id,
    required this.name,
    this.totalTrees = 0,
    required this.country,
  });

  factory Guild.fromFirestore(Map<String, dynamic> data, String id) {
    return Guild(
      id: id,
      name: data['name'] ?? '',
      totalTrees: data['totalTrees'] ?? 0,
      country: data['country'] ?? 'Global',
    );
  }
}
