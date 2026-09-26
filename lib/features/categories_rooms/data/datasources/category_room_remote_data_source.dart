import '../../../../core/network/api_client.dart';
import '../models/category_room_model.dart';

class CategoryRoomRemoteDataSource {
  /// Lève une [ApiException] si le chargement échoue.
  Future<List<CategoryRoomModel>> getCategoryRooms() async {
    final data = await ApiClient.getList('/categories');
    return data.map((json) => CategoryRoomModel.fromJson(json)).toList();
  }

  Future<bool> saveCategoryRoom(CategoryRoomModel roomModel) async {
    try {
      await ApiClient.post('/categories/save', body: roomModel.toJson());
      return true;
    } on ApiException {
      return false;
    }
  }

  Future<bool> deleteCategoryRoom(int id) async {
    try {
      await ApiClient.post('/categories/delete', body: {'id': id});
      return true;
    } on ApiException {
      return false;
    }
  }
}
