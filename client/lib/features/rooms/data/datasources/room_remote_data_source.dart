import 'package:http/http.dart' as http;
import 'dart:convert'; // Nécessaire pour décoder le JSON (jsonDecode)
import '../models/room_model.dart';

class RoomRemoteDataSource {
  static const String baseUrl = 'http://localhost:3000/api/gsr';

  Future<List<RoomModel>> getRooms() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/rooms'));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((json) => RoomModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> saveRoom(RoomModel roomModel) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/rooms/save'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(roomModel.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteRoom(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/rooms/delete'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'id': id}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
