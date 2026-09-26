import '../entities/structure.dart';
import '../repositories/structure_repository.dart';

class SaveStructure {
  final StructureRepository repository;

  SaveStructure(this.repository);

  Future<bool> call(Structure structure) => repository.saveStructure(structure);
}
