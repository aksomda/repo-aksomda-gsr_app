import '../entities/room.dart';
import '../repositories/room_repository.dart';

class SaveRoom {
  final RoomRepository repository;

  SaveRoom(this.repository);

  Future<bool> call(Room room) async {
    return await repository.saveRoom(room);
  }
}
