import 'package:flutter/material.dart';
import '../../../domain/entities/room.dart';
import '../../../domain/usecases/get_rooms.dart';
import '../../../domain/usecases/save_room.dart';

class RoomProvider with ChangeNotifier {
  final GetRooms getRoomsUseCase;
  final SaveRoom saveRoomUseCase;

  List<Room> _rooms = [];
  bool _isLoading = false;

  List<Room> get rooms => _rooms;
  bool get isLoading => _isLoading;

  RoomProvider({required this.getRoomsUseCase, required this.saveRoomUseCase});

  Future<void> fetchRooms() async {
    _isLoading = true;
    notifyListeners();
    _rooms = await getRoomsUseCase();
    _isLoading = false;
    notifyListeners();
  }

  List<Room> getRoomsByStatus(String status) {
    return _rooms
        .where((r) => r.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  Future<bool> addOrUpdateRoom(Room room) async {
    bool success = await saveRoomUseCase(room);
    if (success) {
      await fetchRooms();
    }
    return success;
  }
}
