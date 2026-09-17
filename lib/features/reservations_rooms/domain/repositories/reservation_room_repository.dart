import '../entities/reservation_room.dart';

abstract class ReservationRoomRepository {
  Future<List<ReservationRoom>> getReservationRooms();
  Future<bool> saveReservationRoom(ReservationRoom reservation);
  Future<bool> deleteReservationRoom(int id);
}
