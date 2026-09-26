import '../../domain/entities/message.dart';
import '../../domain/entities/message_recipient.dart';
import '../../domain/entities/message_thread.dart';
import '../../domain/repositories/message_repository.dart';
import '../datasources/message_remote_datasource.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource remoteDataSource;

  MessageRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Message>> getConversation({String? withLogin}) =>
      remoteDataSource.getConversation(withLogin: withLogin);

  @override
  Future<bool> sendMessage({required String content, String? recipientLogin}) {
    return remoteDataSource.sendMessage(
      content: content,
      recipientLogin: recipientLogin,
    );
  }

  @override
  Future<List<MessageThread>> getThreads() => remoteDataSource.getThreads();

  @override
  Future<List<MessageRecipient>> getRecipients() =>
      remoteDataSource.getRecipients();
}
