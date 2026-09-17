import '../entities/category_room.dart';
import '../repositories/category_room_repository.dart';

class GetCategoryRooms {
  final CategoryRoomRepository repository;

  GetCategoryRooms(this.repository);

  Future<List<CategoryRoom>> call() async {
    return await repository.getCategoryRooms();
  }
}
