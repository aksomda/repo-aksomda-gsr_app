import '../entities/message.dart';
import '../entities/message_recipient.dart';
import '../entities/message_thread.dart';

abstract class MessageRepository {
  /// Conversation avec l'administration (agent) ou avec l'agent [withLogin]
  /// (admin).
  Future<List<Message>> getConversation({String? withLogin});

  Future<bool> sendMessage({required String content, String? recipientLogin});

  /// Liste des agents ayant échangé des messages (admin uniquement).
  Future<List<MessageThread>> getThreads();

  /// Agents à qui un admin peut écrire (admin uniquement).
  Future<List<MessageRecipient>> getRecipients();
}
