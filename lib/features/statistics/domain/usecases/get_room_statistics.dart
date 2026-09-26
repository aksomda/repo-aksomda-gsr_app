import '../entities/room_statistics.dart';
import '../repositories/statistics_repository.dart';

class GetRoomStatistics {
  final StatisticsRepository repository;

  GetRoomStatistics(this.repository);

  Future<RoomStatistics> call() => repository.getRoomStatistics();
}
