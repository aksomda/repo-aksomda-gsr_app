import '../../domain/entities/direction_regionale.dart';

class DirectionRegionaleModel extends DirectionRegionale {
  DirectionRegionaleModel({super.id, required super.nom});

  factory DirectionRegionaleModel.fromJson(Map<String, dynamic> json) {
    return DirectionRegionaleModel(
      id: json['code_cdi']?.toString(),
      nom: json['libelle_long_cdi'] ?? '',
    );
  }
}
