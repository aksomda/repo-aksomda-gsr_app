import '../entities/message.dart';
import '../repositories/message_repository.dart';

class GetConversation {
  final MessageRepository repository;

  GetConversation(this.repository);

  Future<List<Message>> call({String? withLogin}) =>
      repository.getConversation(withLogin: withLogin);
}
