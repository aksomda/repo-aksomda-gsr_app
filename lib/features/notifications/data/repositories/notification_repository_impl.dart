import '../../domain/entities/notification_item.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<NotificationItem>> getNotifications() =>
      remoteDataSource.getNotifications();

  @override
  Future<bool> markAsRead(int id) => remoteDataSource.markAsRead(id);
}
