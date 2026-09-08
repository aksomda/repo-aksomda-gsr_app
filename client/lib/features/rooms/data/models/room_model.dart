import '../../domain/entities/room.dart';

class RoomModel extends Room {
  RoomModel({
    super.id,
    required super.name,
    required super.region,
    required super.province,
    required super.city,
    required super.location,
    required super.hasComputer,
    required super.computerCount,
    required super.category,
    required super.rentalAmount,
    required super.status,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      name: json['name'] ?? '',
      region: json['region'] ?? '',
      province: json['province'] ?? '',
      city: json['city'] ?? '',
      location: json['location'] ?? '',
      hasComputer: json['has_computer'] == 1 || json['has_computer'] == true,
      computerCount: json['computer_count'] ?? 0,
      category: json['category'] ?? 'gratuit',
      rentalAmount: double.tryParse(json['rental_amount'].toString()) ?? 0.0,
      status: json['status'] ?? 'disponible',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'region': region,
      'province': province,
      'city': city,
      'location': location,
      'has_computer': hasComputer ? 1 : 0,
      'computer_count': computerCount,
      'category': category,
      'rental_amount': rentalAmount,
      'status': status,
    };
  }

  factory RoomModel.fromEntity(Room room) {
    return RoomModel(
      id: room.id,
      name: room.name,
      region: room.region,
      province: room.province,
      city: room.city,
      location: room.location,
      hasComputer: room.hasComputer,
      computerCount: room.computerCount,
      category: room.category,
      rentalAmount: room.rentalAmount,
      status: room.status,
    );
  }
}
