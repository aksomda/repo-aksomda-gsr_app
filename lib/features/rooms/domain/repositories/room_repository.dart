import '../entities/room.dart';

abstract class RoomRepository {
  Future<List<Room>> getRooms();
  Future<List<Room>> getAvailableRooms({
    required String date,
    required String startTime,
    required String endTime,
  });
  Future<bool> saveRoom(Room room);
  Future<bool> deleteRoom(int id);
}
