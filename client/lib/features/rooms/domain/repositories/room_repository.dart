import '../entities/room.dart';

abstract class RoomRepository {
  Future<List<Room>> getRooms();
  Future<bool> saveRoom(Room room);
  Future<bool> deleteRoom(int id);
}
