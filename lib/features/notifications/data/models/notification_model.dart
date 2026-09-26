import '../../domain/entities/notification_item.dart';

class NotificationModel extends NotificationItem {
  NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.type,
    super.referenceId,
    required super.isRead,
    required super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? '',
      referenceId: json['reference_id'] == null
          ? null
          : int.tryParse(json['reference_id'].toString()),
      isRead: json['is_read'] == 1 || json['is_read'] == true,
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
