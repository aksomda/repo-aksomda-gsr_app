import 'package:flutter_test/flutter_test.dart';
import 'package:gsr_app/features/chat/data/models/message_model.dart';
import 'package:gsr_app/features/chat/data/models/message_recipient_model.dart';
import 'package:gsr_app/features/chat/data/models/message_thread_model.dart';

void main() {
  test('MessageModel lit les colonnes de la table messages (logins)', () {
    final message = MessageModel.fromJson({
      'id': 4,
      'sender_login': '217071K',
      'recipient_login': null,
      'content': 'Bonjour',
      'is_read': 0,
      'created_at': '2026-05-01T10:00:00.000Z',
    });

    expect(message.senderLogin, '217071K');
    expect(message.recipientLogin, isNull);
    expect(message.isRead, isFalse);
  });

  test('MessageThreadModel et MessageRecipientModel identifient par login', () {
    final thread = MessageThreadModel.fromJson({
      'login': '217071K',
      'nom': 'OUEDRAOGO',
      'prenom': 'Awa',
      'last_message_at': null,
      'unread_count': '2',
    });
    final recipient = MessageRecipientModel.fromJson({
      'login': '217071K',
      'nom': 'OUEDRAOGO',
      'prenom': 'Awa',
    });

    expect(thread.login, '217071K');
    expect(thread.unreadCount, 2);
    expect(recipient.nomComplet, 'Awa OUEDRAOGO');
  });
}
