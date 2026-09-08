import '../entities/category_room.dart' show CategoryRoom;

abstract class CategoryRoomRepository {
  Future<List<CategoryRoom>> getCategoryRooms();
  Future<bool> saveCategoryRoom(CategoryRoom room);
  Future<bool> deleteCategoryRoom(int id);
}
