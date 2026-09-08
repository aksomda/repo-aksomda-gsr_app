import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:repo_aksomda_gsr_app/features/rooms/domain/entities/room.dart';
import '../rooms/data/models/room_model.dart';

class ApiService {
  // URL de l'API Node.js (Ex: 10.0.2.2 pour l'émulateur Android, localhost pour le web/desktop)
  static const String baseUrl = 'http://localhost:3000/api/gsr';

  Future<List<Object?>> getRooms() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/rooms'));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((json) => Room.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> saveRoom(Room room) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/rooms/save'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(room.toJson()),
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
