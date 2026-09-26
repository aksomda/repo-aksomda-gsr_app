import '../../domain/entities/room.dart';

/// `room.status` est un entier en base (voir server/sql/README.md).
const _statusByCode = {
  1: 'disponible',
  2: 'reservé',
  3: 'en refection',
  4: 'dégradé',
  5: 'en construction',
  6: 'occupé',
};

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
    super.categoryId,
    super.directionRegionaleId,
    required super.rentalAmount,
    required super.status,
  });

  /// Lit une ligne de la table `room` (colonnes réelles). region/province/city
  /// (entiers hérités) sont ignorés au profit de region_name/province_name/
  /// city_name/location.
  factory RoomModel.fromJson(Map<String, dynamic> json) {
    String text(dynamic v) => v is String ? v : '';
    int? intOrNull(dynamic v) => v == null ? null : int.tryParse(v.toString());
    final rawStatus = json['status'];

    return RoomModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      name: json['name'] ?? '',
      region: text(json['region_name']),
      province: text(json['province_name']),
      city: text(json['city_name']),
      location: text(json['location']),
      hasComputer: json['hasComputer'] == 1 || json['hasComputer'] == true,
      computerCount: intOrNull(json['computerCount']) ?? 0,
      categoryId: intOrNull(json['category_room_id']),
      directionRegionaleId: json['structure_code']?.toString(),
      rentalAmount: double.tryParse(json['rentalAmount'].toString()) ?? 0.0,
      status: rawStatus is String
          ? rawStatus
          : _statusByCode[intOrNull(rawStatus)] ?? _statusByCode[1]!,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'region_name': region,
      'province_name': province,
      'city_name': city,
      'location': location,
      'hasLocation': 0,
      'hasComputer': hasComputer ? 1 : 0,
      'computerCount': computerCount,
      'category_room_id': categoryId,
      'structure_code': directionRegionaleId,
      'rentalAmount': rentalAmount,
      'status': _statusByCode.entries
          .firstWhere(
            (e) => e.value == status,
            orElse: () => _statusByCode.entries.first,
          )
          .key,
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
      categoryId: room.categoryId,
      directionRegionaleId: room.directionRegionaleId,
      rentalAmount: room.rentalAmount,
      status: room.status,
    );
  }
}
