import '../entities/structure.dart';

abstract class StructureRepository {
  Future<List<Structure>> getStructures();
  Future<bool> saveStructure(Structure structure);
  Future<bool> deleteStructure(String codeCdi);
}
