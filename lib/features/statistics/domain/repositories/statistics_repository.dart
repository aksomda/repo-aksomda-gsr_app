import '../entities/room_statistics.dart';

abstract class StatisticsRepository {
  Future<RoomStatistics> getRoomStatistics();
}
