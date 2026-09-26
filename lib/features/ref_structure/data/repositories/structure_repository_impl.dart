import '../../domain/entities/structure.dart';
import '../../domain/repositories/structure_repository.dart';
import '../datasources/structure_remote_data_source.dart';
import '../models/structure_model.dart';

class StructureRepositoryImpl implements StructureRepository {
  final StructureRemoteDataSource remoteDataSource;

  StructureRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Structure>> getStructures() => remoteDataSource.getStructures();

  @override
  Future<bool> saveStructure(Structure structure) {
    return remoteDataSource.saveStructure(StructureModel.fromEntity(structure));
  }

  @override
  Future<bool> deleteStructure(String codeCdi) =>
      remoteDataSource.deleteStructure(codeCdi);
}
