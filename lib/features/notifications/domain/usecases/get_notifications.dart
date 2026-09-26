import '../entities/notification_item.dart';
import '../repositories/notification_repository.dart';

class GetNotifications {
  final NotificationRepository repository;

  GetNotifications(this.repository);

  Future<List<NotificationItem>> call() => repository.getNotifications();
}
