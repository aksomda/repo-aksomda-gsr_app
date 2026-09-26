class NotificationItem {
  final int id;
  final String title;
  final String body;
  final String type;
  final int? referenceId;
  final bool isRead;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.referenceId,
    required this.isRead,
    required this.createdAt,
  });
}
