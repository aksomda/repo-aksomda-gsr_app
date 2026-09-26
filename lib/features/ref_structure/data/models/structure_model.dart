import '../../domain/entities/structure.dart';

class StructureModel extends Structure {
  StructureModel({required super.codeCdi, required super.libelleLongCdi});

  factory StructureModel.fromJson(Map<String, dynamic> json) {
    return StructureModel(
      codeCdi: json['code_cdi'] ?? '',
      libelleLongCdi: json['libelle_long_cdi'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'code_cdi': codeCdi, 'libelle_long_cdi': libelleLongCdi};
  }

  factory StructureModel.fromEntity(Structure entity) {
    return StructureModel(
      codeCdi: entity.codeCdi,
      libelleLongCdi: entity.libelleLongCdi,
    );
  }
}
