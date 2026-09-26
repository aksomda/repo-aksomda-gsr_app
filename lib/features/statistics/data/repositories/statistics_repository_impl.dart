import '../../domain/entities/room_statistics.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../datasources/statistics_remote_datasource.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final StatisticsRemoteDataSource remoteDataSource;

  StatisticsRepositoryImpl(this.remoteDataSource);

  @override
  Future<RoomStatistics> getRoomStatistics() =>
      remoteDataSource.getRoomStatistics();
}
