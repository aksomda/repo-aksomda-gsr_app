import '../../../../core/network/api_client.dart';
import '../models/room_model.dart';

class RoomRemoteDataSource {
  /// Lève une [ApiException] si le chargement échoue.
  Future<List<RoomModel>> getRooms() async {
    final data = await ApiClient.getList('/rooms');
    return data.map((json) => RoomModel.fromJson(json)).toList();
  }

  /// Salles sans réservation (en attente ou validée) chevauchant le créneau
  /// [date] [startTime]-[endTime] (heures au format HH:mm).
  Future<List<RoomModel>> getAvailableRooms({
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    final data = await ApiClient.getList(
      '/rooms/available',
      query: {'date': date, 'start_time': startTime, 'end_time': endTime},
    );
    return data.map((json) => RoomModel.fromJson(json)).toList();
  }

  Future<bool> saveRoom(RoomModel roomModel) async {
    try {
      await ApiClient.post('/rooms/save', body: roomModel.toJson());
      return true;
    } on ApiException {
      return false;
    }
  }

  Future<bool> deleteRoom(int id) async {
    try {
      await ApiClient.post('/rooms/delete', body: {'id': id});
      return true;
    } on ApiException {
      return false;
    }
  }
}
