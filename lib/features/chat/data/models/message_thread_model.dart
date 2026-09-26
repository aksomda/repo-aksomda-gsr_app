import '../../domain/entities/message_thread.dart';

class MessageThreadModel extends MessageThread {
  MessageThreadModel({
    required super.login,
    required super.nom,
    required super.prenom,
    super.lastMessageAt,
    required super.unreadCount,
  });

  factory MessageThreadModel.fromJson(Map<String, dynamic> json) {
    return MessageThreadModel(
      login: json['login']?.toString() ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      lastMessageAt: json['last_message_at'] == null
          ? null
          : DateTime.tryParse(json['last_message_at'].toString()),
      unreadCount: int.tryParse(json['unread_count'].toString()) ?? 0,
    );
  }
}
