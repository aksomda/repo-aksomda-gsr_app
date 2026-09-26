import '../repositories/reservation_room_repository.dart';

class CreateReservation {
  final ReservationRoomRepository repository;

  CreateReservation(this.repository);

  Future<String?> call({
    required int roomId,
    required String meetingSubject,
    required String organizingStructure,
    required String date,
    required String startTime,
    required String endTime,
  }) {
    return repository.createReservation(
      roomId: roomId,
      meetingSubject: meetingSubject,
      organizingStructure: organizingStructure,
      date: date,
      startTime: startTime,
      endTime: endTime,
    );
  }
}
