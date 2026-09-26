import '../repositories/reservation_room_repository.dart';

class RejectReservation {
  final ReservationRoomRepository repository;

  RejectReservation(this.repository);

  Future<bool> call(int id, {String? reason}) =>
      repository.rejectReservation(id, reason: reason);
}
