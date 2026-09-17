import '../entities/reservation_room.dart';
import '../repositories/reservation_room_repository.dart';

class SaveReservationRoom {
  final ReservationRoomRepository repository;

  SaveReservationRoom(this.repository);

  Future<bool> call(ReservationRoom reservation) async {
    return await repository.saveReservationRoom(reservation);
  }
}
