import '../repositories/reservation_room_repository.dart';

class ValidateReservation {
  final ReservationRoomRepository repository;

  ValidateReservation(this.repository);

  Future<bool> call(int id) => repository.validateReservation(id);
}
