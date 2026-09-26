import '../entities/message_thread.dart';
import '../repositories/message_repository.dart';

class GetThreads {
  final MessageRepository repository;

  GetThreads(this.repository);

  Future<List<MessageThread>> call() => repository.getThreads();
}
