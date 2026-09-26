import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/entities/notification_item.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_notification_as_read.dart';
import '../../../../core/network/api_client.dart';

class NotificationProvider with ChangeNotifier {
  final GetNotifications getNotificationsUseCase;
  final MarkNotificationAsRead markAsReadUseCase;

  NotificationProvider({
    required this.getNotificationsUseCase,
    required this.markAsReadUseCase,
  });

  List<NotificationItem> _notifications = [];
  bool _isLoading = false;
  String? _error;

  /// Message de la dernière erreur de chargement, null si tout va bien.
  String? get error => _error;
  Timer? _pollingTimer;

  List<NotificationItem> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _notifications = await getNotificationsUseCase();
    } catch (e) {
      _error = errorMessageOf(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Rafraîchit périodiquement la liste (agent et admin restent informés
  /// sans action manuelle). À appeler une fois la session ouverte, et
  /// arrêter via stopPolling() à la déconnexion.
  void startPolling({Duration interval = const Duration(seconds: 20)}) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(interval, (_) => fetchNotifications());
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> markAsRead(int id) async {
    final success = await markAsReadUseCase(id);
    if (success) await fetchNotifications();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}
