import 'package:flutter/material.dart';
import '../../../domain/entities/room.dart';
import '../../../domain/usecases/delete_room.dart';
import '../../../domain/usecases/get_available_rooms.dart';
import '../../../domain/usecases/get_rooms.dart';
import '../../../domain/usecases/save_room.dart';
import '../../../../../core/network/api_client.dart';

class RoomProvider with ChangeNotifier {
  final GetRooms getRoomsUseCase;
  final SaveRoom saveRoomUseCase;
  final DeleteRoom? deleteRoomUseCase;
  final GetAvailableRooms? getAvailableRoomsUseCase;

  List<Room> _rooms = [];
  bool _isLoading = false;
  String? _error;

  /// Message de la dernière erreur de chargement, null si tout va bien.
  String? get error => _error;

  List<Room> get rooms => _rooms;
  bool get isLoading => _isLoading;

  RoomProvider({
    required this.getRoomsUseCase,
    required this.saveRoomUseCase,
    this.deleteRoomUseCase,
    this.getAvailableRoomsUseCase,
  });

  Future<List<Room>> fetchAvailableRooms({
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    if (getAvailableRoomsUseCase == null) return [];
    return getAvailableRoomsUseCase!(
      date: date,
      startTime: startTime,
      endTime: endTime,
    );
  }

  Future<void> fetchRooms() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _rooms = await getRoomsUseCase();
    } catch (e) {
      _error = errorMessageOf(e);
    }
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

  Future<bool> deleteRoom(int id) async {
    if (deleteRoomUseCase == null) return false;
    final success = await deleteRoomUseCase!(id);
    if (success) await fetchRooms();
    return success;
  }
}
