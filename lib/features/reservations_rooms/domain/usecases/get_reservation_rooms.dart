import '../entities/reservation_room.dart';
import '../repositories/reservation_room_repository.dart';

class GetReservationRooms {
  final ReservationRoomRepository repository;

  GetReservationRooms(this.repository);

  Future<List<ReservationRoom>> call() async {
    return await repository.getReservationRooms();
  }
}
