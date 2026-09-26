import '../entities/reservation_room.dart';
import '../repositories/reservation_room_repository.dart';
import '../../../../core/models/paged.dart';

class GetAllReservations {
  final ReservationRoomRepository repository;

  GetAllReservations(this.repository);

  Future<Paged<ReservationRoom>> call({int offset = 0}) =>
      repository.getAllReservations(offset: offset);
}
