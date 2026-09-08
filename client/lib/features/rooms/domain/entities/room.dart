class Room {
  final int? id;
  final String name;
  final String region;
  final String province;
  final String city;
  final String location;
  final bool hasComputer;
  final int computerCount;
  final String category;
  final double rentalAmount;
  final String status;

  Room({
    this.id,
    required this.name,
    required this.region,
    required this.province,
    required this.city,
    required this.location,
    required this.hasComputer,
    required this.computerCount,
    required this.category,
    required this.rentalAmount,
    required this.status,
  });

  static Object? fromJson(json) {}
}
