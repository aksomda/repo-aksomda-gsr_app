import '../entities/room.dart';
import '../repositories/room_repository.dart';

class GetAvailableRooms {
  final RoomRepository repository;

  GetAvailableRooms(this.repository);

  Future<List<Room>> call({
    required String date,
    required String startTime,
    required String endTime,
  }) {
    return repository.getAvailableRooms(
      date: date,
      startTime: startTime,
      endTime: endTime,
    );
  }
}
