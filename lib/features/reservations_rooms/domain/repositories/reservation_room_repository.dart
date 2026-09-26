import '../entities/reservation_room.dart';
import '../../../../core/models/paged.dart';

abstract class ReservationRoomRepository {
  /// Pages de résultats : [offset] = nombre d'éléments déjà chargés.
  Future<Paged<ReservationRoom>> getMyReservations({int offset = 0});
  Future<Paged<ReservationRoom>> getAllReservations({int offset = 0});

  /// Renvoie null en cas de succès, sinon le message d'erreur du serveur
  /// (ex: créneau indisponible).
  Future<String?> createReservation({
    required int roomId,
    required String meetingSubject,
    required String organizingStructure,
    required String date,
    required String startTime,
    required String endTime,
  });

  Future<bool> validateReservation(int id);
  Future<bool> rejectReservation(int id, {String? reason});
}
