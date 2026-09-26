import '../repositories/room_repository.dart';

class DeleteRoom {
  final RoomRepository repository;

  DeleteRoom(this.repository);

  Future<bool> call(int id) => repository.deleteRoom(id);
}
