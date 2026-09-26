import 'package:flutter/material.dart';
import '../../domain/entities/reservation_room.dart';
import '../../domain/usecases/create_reservation.dart';
import '../../domain/usecases/get_all_reservations.dart';
import '../../domain/usecases/get_my_reservations.dart';
import '../../domain/usecases/reject_reservation.dart';
import '../../domain/usecases/validate_reservation.dart';
import '../../../../core/network/api_client.dart';

class ReservationRoomProvider with ChangeNotifier {
  final GetMyReservations getMyReservationsUseCase;
  final GetAllReservations getAllReservationsUseCase;
  final CreateReservation createReservationUseCase;
  final ValidateReservation? validateReservationUseCase;
  final RejectReservation? rejectReservationUseCase;

  ReservationRoomProvider({
    required this.getMyReservationsUseCase,
    required this.getAllReservationsUseCase,
    required this.createReservationUseCase,
    this.validateReservationUseCase,
    this.rejectReservationUseCase,
  });

  List<ReservationRoom> _reservations = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _loadError;
  bool _hasMore = false;
  bool _isLoadingMore = false;
  bool _admin = false;

  List<ReservationRoom> get reservations => _reservations;

  /// Le serveur a d'autres réservations après celles déjà chargées.
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Message de la dernière erreur de chargement, null si tout va bien.
  String? get error => _loadError;

  /// Charge la première page des réservations de l'utilisateur (agent).
  Future<void> fetchMine() {
    _admin = false;
    return _load(reset: true);
  }

  /// Charge la première page de toutes les réservations (admin).
  Future<void> fetchAll() {
    _admin = true;
    return _load(reset: true);
  }

  /// Ajoute la page suivante à la liste (bouton « Charger plus »).
  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore || _isLoading) return;
    _isLoadingMore = true;
    notifyListeners();
    await _load(reset: false);
    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> _load({required bool reset}) async {
    if (reset) {
      _isLoading = true;
      _loadError = null;
      notifyListeners();
    }
    try {
      final offset = reset ? 0 : _reservations.length;
      final page = _admin
          ? await getAllReservationsUseCase(offset: offset)
          : await getMyReservationsUseCase(offset: offset);
      _reservations = reset ? page.items : [..._reservations, ...page.items];
      _hasMore = page.hasMore;
    } catch (e) {
      _loadError = errorMessageOf(e);
    }
    if (reset) _isLoading = false;
    notifyListeners();
  }

  List<ReservationRoom> getByStatus(String status) {
    return _reservations.where((r) => r.status == status).toList();
  }

  Future<bool> requestReservation({
    required int roomId,
    required String meetingSubject,
    required String organizingStructure,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    _errorMessage = null;
    final error = await createReservationUseCase(
      roomId: roomId,
      meetingSubject: meetingSubject,
      organizingStructure: organizingStructure,
      date: date,
      startTime: startTime,
      endTime: endTime,
    );
    if (error != null) {
      _errorMessage = error;
      notifyListeners();
      return false;
    }
    await fetchMine();
    return true;
  }

  Future<bool> validate(int id) async {
    if (validateReservationUseCase == null) return false;
    final success = await validateReservationUseCase!(id);
    if (success) await fetchAll();
    return success;
  }

  Future<bool> reject(int id, {String? reason}) async {
    if (rejectReservationUseCase == null) return false;
    final success = await rejectReservationUseCase!(id, reason: reason);
    if (success) await fetchAll();
    return success;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
