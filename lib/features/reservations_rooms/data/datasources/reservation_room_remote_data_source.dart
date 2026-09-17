import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/reservation_room_model.dart';

class ReservationRoomRemoteDataSource {
  static const String baseUrl = 'http://localhost:3000/api/gsr';

  Future<List<ReservationRoomModel>> getReservationRooms() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/reservations_rooms'));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((json) => ReservationRoomModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> saveReservationRoom(ReservationRoomModel model) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reservations_rooms/save'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(model.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteReservationRoom(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reservations_rooms/delete'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'id': id}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
