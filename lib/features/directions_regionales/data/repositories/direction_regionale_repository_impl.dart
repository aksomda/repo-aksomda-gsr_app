import '../../domain/entities/direction_regionale.dart';
import '../../domain/repositories/direction_regionale_repository.dart';
import '../datasources/direction_regionale_remote_data_source.dart';

class DirectionRegionaleRepositoryImpl implements DirectionRegionaleRepository {
  final DirectionRegionaleRemoteDataSource remoteDataSource;

  DirectionRegionaleRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<DirectionRegionale>> getDirectionsRegionales() {
    return remoteDataSource.getDirectionsRegionales();
  }
}
