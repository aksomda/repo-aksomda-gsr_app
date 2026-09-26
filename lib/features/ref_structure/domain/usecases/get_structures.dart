import '../entities/structure.dart';
import '../repositories/structure_repository.dart';

class GetStructures {
  final StructureRepository repository;

  GetStructures(this.repository);

  Future<List<Structure>> call() => repository.getStructures();
}
