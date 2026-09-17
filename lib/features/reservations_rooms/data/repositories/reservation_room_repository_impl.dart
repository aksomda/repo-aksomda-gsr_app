import '../../domain/entities/reservation_room.dart';
import '../../domain/repositories/reservation_room_repository.dart';
import '../datasources/reservation_room_remote_data_source.dart';
import '../models/reservation_room_model.dart';

class ReservationRoomRepositoryImpl implements ReservationRoomRepository {
  final ReservationRoomRemoteDataSource remoteDataSource;

  ReservationRoomRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ReservationRoom>> getReservationRooms() async {
    return await remoteDataSource.getReservationRooms();
  }

  @override
  Future<bool> saveReservationRoom(ReservationRoom reservation) async {
    return await remoteDataSource.saveReservationRoom(
      ReservationRoomModel.fromEntity(reservation),
    );
  }

  @override
  Future<bool> deleteReservationRoom(int id) async {
    return await remoteDataSource.deleteReservationRoom(id);
  }
}
