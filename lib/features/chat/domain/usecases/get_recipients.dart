import '../entities/message_recipient.dart';
import '../repositories/message_repository.dart';

class GetRecipients {
  final MessageRepository repository;

  GetRecipients(this.repository);

  Future<List<MessageRecipient>> call() => repository.getRecipients();
}
