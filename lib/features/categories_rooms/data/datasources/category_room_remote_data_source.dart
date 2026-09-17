import 'package:http/http.dart' as http;
import 'dart:convert'; // Nécessaire pour décoder le JSON (jsonDecode)
import '../models/category_room_model.dart';

class CategoryRoomRemoteDataSource {
  static const String baseUrl = 'http://localhost:3000/api/gsr';

  Future<List<CategoryRoomModel>> getCategoryRooms() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories_rooms'));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((json) => CategoryRoomModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> saveCategoryRoom(CategoryRoomModel roomModel) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/categories_rooms/save'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(roomModel.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteCategoryRoom(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/categories_rooms/delete'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'id': id}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
