import '../../../../core/network/api_client.dart';
import '../models/message_model.dart';
import '../models/message_recipient_model.dart';
import '../models/message_thread_model.dart';

class MessageRemoteDataSource {
  /// Lève une [ApiException] si le chargement échoue.
  Future<List<MessageModel>> getConversation({String? withLogin}) async {
    final data = await ApiClient.getList(
      '/messages',
      query: withLogin == null ? null : {'with': withLogin},
    );
    return data.map((json) => MessageModel.fromJson(json)).toList();
  }

  Future<bool> sendMessage({
    required String content,
    String? recipientLogin,
  }) async {
    try {
      await ApiClient.post(
        '/messages',
        body: {'content': content, 'recipient_login': ?recipientLogin},
      );
      return true;
    } on ApiException {
      return false;
    }
  }

  /// Lève une [ApiException] si le chargement échoue.
  Future<List<MessageThreadModel>> getThreads() async {
    final data = await ApiClient.getList('/messages/threads');
    return data.map((json) => MessageThreadModel.fromJson(json)).toList();
  }

  /// Lève une [ApiException] si le chargement échoue.
  Future<List<MessageRecipientModel>> getRecipients() async {
    final data = await ApiClient.getList('/messages/recipients');
    return data.map((json) => MessageRecipientModel.fromJson(json)).toList();
  }
}
