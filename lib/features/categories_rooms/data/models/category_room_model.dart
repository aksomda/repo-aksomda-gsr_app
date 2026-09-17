import '../../domain/entities/category_room.dart';

class CategoryRoomModel extends CategoryRoom {
  CategoryRoomModel({
    super.id,
    required super.libelleCat,
    required super.montantLocation,
    required super.actif,
  });

  factory CategoryRoomModel.fromJson(Map<String, dynamic> json) {
    return CategoryRoomModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      libelleCat: json['libelleCat'] ?? '',
      montantLocation: json['computer_count'] ?? 0,
      actif: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'libelleCat': libelleCat,
      'montantLocation': montantLocation,
      'actif': actif,
    };
  }

  factory CategoryRoomModel.fromEntity(CategoryRoom categoryRoom) {
    return CategoryRoomModel(
      id: categoryRoom.id,
      libelleCat: categoryRoom.libelleCat,
      montantLocation: categoryRoom.montantLocation,
      actif: categoryRoom.actif,
    );
  }
}
