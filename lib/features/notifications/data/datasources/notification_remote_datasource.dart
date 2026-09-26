import '../../../../core/network/api_client.dart';
import '../models/notification_model.dart';

class NotificationRemoteDataSource {
  /// Lève une [ApiException] si le chargement échoue.
  Future<List<NotificationModel>> getNotifications() async {
    final data = await ApiClient.getList('/notifications');
    return data.map((json) => NotificationModel.fromJson(json)).toList();
  }

  Future<bool> markAsRead(int id) async {
    try {
      await ApiClient.post('/notifications/$id/read');
      return true;
    } on ApiException {
      return false;
    }
  }
}
