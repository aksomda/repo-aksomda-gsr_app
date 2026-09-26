import '../repositories/message_repository.dart';

class SendMessage {
  final MessageRepository repository;

  SendMessage(this.repository);

  Future<bool> call({required String content, String? recipientLogin}) {
    return repository.sendMessage(
      content: content,
      recipientLogin: recipientLogin,
    );
  }
}
