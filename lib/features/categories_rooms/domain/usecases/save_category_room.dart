import '../entities/category_room.dart';
import '../repositories/category_room_repository.dart';

class SaveCategoryRoom {
  final CategoryRoomRepository repository;

  SaveCategoryRoom(this.repository);

  Future<bool> call(CategoryRoom room) async {
    return await repository.saveCategoryRoom(room);
  }
}
