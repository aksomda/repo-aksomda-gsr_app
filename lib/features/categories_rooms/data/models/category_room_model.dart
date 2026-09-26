import '../../domain/entities/category_room.dart';

class CategoryRoomModel extends CategoryRoom {
  CategoryRoomModel({
    super.id,
    required super.libelleCat,
    required super.type,
    required super.montantLocation,
    required super.actif,
  });

  factory CategoryRoomModel.fromJson(Map<String, dynamic> json) {
    final montant = double.tryParse(json['montant_location'].toString()) ?? 0;
    return CategoryRoomModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      libelleCat: json['libelle_cat'] ?? json['libelle'] ?? '',
      // Non stocké en base : dérivé du montant (0 => gratuite).
      type: json['type'] ?? (montant > 0 ? 'location' : 'gratuite'),
      montantLocation: montant,
      actif: json['actif'] is int
          ? json['actif']
          : int.tryParse(json['actif'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'libelle_cat': libelleCat,
      'montant_location': montantLocation,
      'actif': actif,
    };
  }

  factory CategoryRoomModel.fromEntity(CategoryRoom categoryRoom) {
    return CategoryRoomModel(
      id: categoryRoom.id,
      libelleCat: categoryRoom.libelleCat,
      type: categoryRoom.type,
      montantLocation: categoryRoom.montantLocation,
      actif: categoryRoom.actif,
    );
  }
}
