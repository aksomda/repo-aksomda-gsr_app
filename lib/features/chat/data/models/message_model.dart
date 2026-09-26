import '../../domain/entities/message.dart';

class MessageModel extends Message {
  MessageModel({
    required super.id,
    required super.senderLogin,
    super.recipientLogin,
    required super.content,
    required super.isRead,
    required super.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      senderLogin: json['sender_login']?.toString() ?? '',
      recipientLogin: json['recipient_login']?.toString(),
      content: json['content'] ?? '',
      isRead: json['is_read'] == 1 || json['is_read'] == true,
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
