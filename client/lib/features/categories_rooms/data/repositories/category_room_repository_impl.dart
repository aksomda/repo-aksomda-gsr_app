import '../../domain/entities/category_room.dart';
import '../../domain/repositories/category_room_repository.dart';
import '../datasources/category_room_remote_data_source.dart';
import '../models/category_room_model.dart';

class CategoryRoomRepositoryImpl implements CategoryRoomRepository {
  final CategoryRoomRemoteDataSource remoteDataSource;

  CategoryRoomRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CategoryRoom>> getCategoryRooms() async {
    return await remoteDataSource.getCategoryRooms();
  }

  @override
  Future<bool> saveCategoryRoom(CategoryRoom room) async {
    return await remoteDataSource.saveCategoryRoom(
      CategoryRoomModel.fromEntity(room),
    );
  }

  @override
  Future<bool> deleteCategoryRoom(int id) async {
    return await remoteDataSource.deleteCategoryRoom(id);
  }
}
