import 'package:flutter/material.dart';
import '../../domain/entities/direction_regionale.dart';
import '../../domain/usecases/get_directions_regionales.dart';
import '../../../../core/network/api_client.dart';

class DirectionRegionaleProvider with ChangeNotifier {
  final GetDirectionsRegionales getDirectionsRegionalesUseCase;

  List<DirectionRegionale> _directions = [];
  bool _isLoading = false;
  String? _error;

  /// Message de la dernière erreur de chargement, null si tout va bien.
  String? get error => _error;

  List<DirectionRegionale> get directions => _directions;
  bool get isLoading => _isLoading;

  DirectionRegionaleProvider({required this.getDirectionsRegionalesUseCase});

  Future<void> fetchDirections() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _directions = await getDirectionsRegionalesUseCase();
    } catch (e) {
      _error = errorMessageOf(e);
    }
    _isLoading = false;
    notifyListeners();
  }
}
