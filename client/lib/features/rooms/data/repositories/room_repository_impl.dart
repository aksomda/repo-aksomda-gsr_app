import '../../domain/entities/room.dart';
import '../../domain/repositories/room_repository.dart';
import '../datasources/room_remote_data_source.dart';
import '../models/room_model.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomRemoteDataSource remoteDataSource;

  RoomRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Room>> getRooms() async {
    return await remoteDataSource.getRooms();
  }

  @override
  Future<bool> saveRoom(Room room) async {
    return await remoteDataSource.saveRoom(RoomModel.fromEntity(room));
  }

  @override
  Future<bool> deleteRoom(int id) async {
    return await remoteDataSource.deleteRoom(id);
  }
}
