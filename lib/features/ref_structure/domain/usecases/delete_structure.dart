import '../repositories/structure_repository.dart';

class DeleteStructure {
  final StructureRepository repository;

  DeleteStructure(this.repository);

  Future<bool> call(String codeCdi) => repository.deleteStructure(codeCdi);
}
