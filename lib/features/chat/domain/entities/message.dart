class Message {
  final int id;
  final String senderLogin;
  final String? recipientLogin;
  final String content;
  final bool isRead;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.senderLogin,
    this.recipientLogin,
    required this.content,
    required this.isRead,
    required this.createdAt,
  });
}
