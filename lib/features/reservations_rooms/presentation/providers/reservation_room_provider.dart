import 'package:flutter/material.dart';
import '../../domain/entities/reservation_room.dart';
import '../../domain/usecases/get_reservation_rooms.dart';
import '../../domain/usecases/save_reservation_room.dart';

class ReservationRoomProvider with ChangeNotifier {
  final GetReservationRooms getReservationRoomsUseCase;
  final SaveReservationRoom saveReservationRoomUseCase;

  List<ReservationRoom> _reservations = [];
  bool _isLoading = false;

  List<ReservationRoom> get reservations => _reservations;
  bool get isLoading => _isLoading;

  ReservationRoomProvider({
    required this.getReservationRoomsUseCase,
    required this.saveReservationRoomUseCase,
  });

  Future<void> fetchReservations() async {
    _isLoading = true;
    notifyListeners();
    _reservations = await getReservationRoomsUseCase();
    _isLoading = false;
    notifyListeners();
  }

  List<ReservationRoom> getByState(String state) {
    return _reservations
        .where((r) => r.state.toLowerCase() == state.toLowerCase())
        .toList();
  }

  Future<bool> addOrUpdateReservation(ReservationRoom reservation) async {
    bool success = await saveReservationRoomUseCase(reservation);
    if (success) {
      await fetchReservations();
    }
    return success;
  }
}
