import '../repositories/category_room_repository.dart';

class DeleteCategoryRoom {
  final CategoryRoomRepository repository;

  DeleteCategoryRoom(this.repository);

  Future<bool> call(int id) async {
    return await repository.deleteCategoryRoom(id);
  }
}
