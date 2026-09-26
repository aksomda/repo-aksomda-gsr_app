import '../../../../core/network/api_client.dart';
import '../models/reservation_room_model.dart';
import '../../../../core/models/paged.dart';

class ReservationRoomRemoteDataSource {
  /// Une page des réservations de l'utilisateur courant. Lève une
  /// [ApiException] si le chargement échoue.
  Future<Paged<ReservationRoomModel>> getMyReservations({
    int offset = 0,
  }) async {
    final page = await ApiClient.getPage('/reservations/mine', offset: offset);
    return page.map((json) => ReservationRoomModel.fromJson(json));
  }

  /// Une page de toutes les réservations (admin). Lève une [ApiException] si
  /// le chargement échoue.
  Future<Paged<ReservationRoomModel>> getAllReservations({
    int offset = 0,
  }) async {
    final page = await ApiClient.getPage('/reservations', offset: offset);
    return page.map((json) => ReservationRoomModel.fromJson(json));
  }

  /// Renvoie null en cas de succès, sinon le message d'erreur à afficher
  /// (créneau déjà pris, salle indisponible, serveur injoignable...).
  Future<String?> createReservation({
    required int roomId,
    required String meetingSubject,
    required String organizingStructure,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    try {
      await ApiClient.post(
        '/reservations',
        body: {
          'room_id': roomId,
          'meeting_subject': meetingSubject,
          'organizing_structure': organizingStructure,
          'date': date,
          'start_time': startTime,
          'end_time': endTime,
        },
      );
      return null;
    } on ApiException catch (e) {
      return e.message;
    }
  }

  Future<bool> validateReservation(int id) async {
    try {
      await ApiClient.post('/reservations/$id/validate');
      return true;
    } on ApiException {
      return false;
    }
  }

  Future<bool> rejectReservation(int id, {String? reason}) async {
    try {
      await ApiClient.post(
        '/reservations/$id/reject',
        body: {'reason': reason},
      );
      return true;
    } on ApiException {
      return false;
    }
  }
}
