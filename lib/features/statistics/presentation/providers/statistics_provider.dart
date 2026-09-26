import 'package:flutter/material.dart';
import '../../domain/entities/room_statistics.dart';
import '../../domain/usecases/get_room_statistics.dart';
import '../../../../core/network/api_client.dart';

class StatisticsProvider with ChangeNotifier {
  final GetRoomStatistics getRoomStatisticsUseCase;

  StatisticsProvider({required this.getRoomStatisticsUseCase});

  RoomStatistics? _statistics;
  bool _isLoading = false;
  String? _error;

  /// Message de la dernière erreur de chargement, null si tout va bien.
  String? get error => _error;

  RoomStatistics? get statistics => _statistics;
  bool get isLoading => _isLoading;

  Future<void> fetchStatistics() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _statistics = await getRoomStatisticsUseCase();
    } catch (e) {
      _error = errorMessageOf(e);
    }
    _isLoading = false;
    notifyListeners();
  }
}
