import '../../domain/entities/reservation_room.dart';
import '../../domain/repositories/reservation_room_repository.dart';
import '../datasources/reservation_room_remote_data_source.dart';
import '../../../../core/models/paged.dart';

class ReservationRoomRepositoryImpl implements ReservationRoomRepository {
  final ReservationRoomRemoteDataSource remoteDataSource;

  ReservationRoomRepositoryImpl(this.remoteDataSource);

  @override
  Future<Paged<ReservationRoom>> getMyReservations({int offset = 0}) =>
      remoteDataSource.getMyReservations(offset: offset);

  @override
  Future<Paged<ReservationRoom>> getAllReservations({int offset = 0}) =>
      remoteDataSource.getAllReservations(offset: offset);

  @override
  Future<String?> createReservation({
    required int roomId,
    required String meetingSubject,
    required String organizingStructure,
    required String date,
    required String startTime,
    required String endTime,
  }) {
    return remoteDataSource.createReservation(
      roomId: roomId,
      meetingSubject: meetingSubject,
      organizingStructure: organizingStructure,
      date: date,
      startTime: startTime,
      endTime: endTime,
    );
  }

  @override
  Future<bool> validateReservation(int id) =>
      remoteDataSource.validateReservation(id);

  @override
  Future<bool> rejectReservation(int id, {String? reason}) =>
      remoteDataSource.rejectReservation(id, reason: reason);
}
