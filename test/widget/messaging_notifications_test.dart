import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gsr_app/features/chat/domain/entities/message.dart';
import 'package:gsr_app/features/chat/domain/entities/message_recipient.dart';
import 'package:gsr_app/features/chat/domain/entities/message_thread.dart';
import 'package:gsr_app/features/chat/presentation/screens/admin_message_threads_screen.dart';
import 'package:gsr_app/features/chat/presentation/widgets/conversation_view.dart';
import 'package:gsr_app/features/notifications/domain/entities/notification_item.dart';
import 'package:gsr_app/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:gsr_app/features/ref_structure/presentation/widgets/structure_picker_field.dart';

import '../helpers/fakes.dart';

class _Messages extends FakeMessageRepository {
  final sent = <({String content, String? to})>[];

  @override
  Future<List<MessageThread>> getThreads() async => [
    MessageThread(
      login: '217071K',
      nom: 'OUEDRAOGO',
      prenom: 'Awa',
      unreadCount: 2,
    ),
  ];

  @override
  Future<List<MessageRecipient>> getRecipients() async => [
    MessageRecipient(login: '217071K', nom: 'OUEDRAOGO', prenom: 'Awa'),
    MessageRecipient(login: '300000Z', nom: 'KABORE', prenom: 'Issa'),
  ];

  @override
  Future<List<Message>> getConversation({String? withLogin}) async => [
    Message(
      id: 1,
      senderLogin: withLogin ?? '',
      content: 'Bonjour, la salle A est libre ?',
      isRead: false,
      createdAt: DateTime(2026, 9, 10),
    ),
  ];

  @override
  Future<bool> sendMessage({
    required String content,
    String? recipientLogin,
  }) async {
    sent.add((content: content, to: recipientLogin));
    return true;
  }
}

class _Notifications extends FakeNotificationRepository {
  final read = <int>[];

  @override
  Future<List<NotificationItem>> getNotifications() async => [
    NotificationItem(
      id: 7,
      title: 'Réservation validée',
      body: 'Votre demande du 10/09 est validée.',
      type: 'reservation_validee',
      isRead: false,
      createdAt: DateTime(2026, 9, 10),
    ),
  ];

  @override
  Future<bool> markAsRead(int id) async {
    read.add(id);
    return true;
  }
}

void main() {
  group('Messagerie administrateur', () {
    testWidgets(
      'liste les agents ayant écrit avec leur nombre de messages non lus',
      (tester) async {
        await tester.pumpWidget(
          buildFakeApp(
            isAdmin: true,
            messageRepository: _Messages(),
            home: frApp(const AdminMessageThreadsScreen()),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Awa OUEDRAOGO'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
      },
    );

    testWidgets('« Nouveau message » : choix d\'un agent puis conversation', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildFakeApp(
          isAdmin: true,
          messageRepository: _Messages(),
          home: frApp(const AdminMessageThreadsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Nouveau message'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'kabo');
      await tester.pumpAndSettle();
      expect(find.text('Awa OUEDRAOGO (217071K)'), findsNothing);

      await tester.tap(find.text('Issa KABORE (300000Z)'));
      await tester.pumpAndSettle();

      expect(find.text('Issa KABORE'), findsOneWidget);
      expect(find.text('Écrire un message...'), findsOneWidget);
    });

    testWidgets('la conversation affiche les messages et envoie une réponse', (
      tester,
    ) async {
      final repo = _Messages();
      await tester.pumpWidget(
        buildFakeApp(
          isAdmin: true,
          messageRepository: repo,
          home: frApp(
            const Scaffold(body: ConversationView(peerLogin: '217071K')),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Bonjour, la salle A est libre ?'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Oui, elle est libre.');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      expect(repo.sent.single, (
        content: 'Oui, elle est libre.',
        to: '217071K',
      ));
    });

    testWidgets('un message vide n\'est pas envoyé', (tester) async {
      final repo = _Messages();
      await tester.pumpWidget(
        buildFakeApp(
          messageRepository: repo,
          home: frApp(const Scaffold(body: ConversationView())),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '   ');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      expect(repo.sent, isEmpty);
    });
  });

  group('Notifications', () {
    testWidgets('affiche les notifications reçues', (tester) async {
      await tester.pumpWidget(
        buildFakeApp(
          notificationRepository: _Notifications(),
          home: frApp(const NotificationsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Réservation validée'), findsOneWidget);
      expect(
        find.textContaining('Votre demande du 10/09 est validée.'),
        findsOneWidget,
      );
    });

    testWidgets('toucher une notification non lue la marque comme lue', (
      tester,
    ) async {
      final repo = _Notifications();
      await tester.pumpWidget(
        buildFakeApp(
          notificationRepository: repo,
          home: frApp(const NotificationsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Réservation validée'));
      await tester.pumpAndSettle();

      expect(repo.read, [7]);
    });
  });

  group('Sélecteur de structure', () {
    testWidgets('recherche une structure et la sélectionne', (tester) async {
      String? chosen;
      await tester.pumpWidget(
        buildFakeApp(
          home: frApp(
            Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) => StructurePickerField(
                  value: chosen,
                  onChanged: (code) => setState(() => chosen = code),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Structure'));
      await tester.pumpAndSettle();
      expect(find.text('Choisir une structure'), findsOneWidget);

      await tester.enterText(find.byType(TextField).last, 'budget');
      await tester.pumpAndSettle();
      expect(find.textContaining('Systèmes'), findsNothing);

      await tester.tap(find.textContaining('Budget'));
      await tester.pumpAndSettle();

      expect(chosen, 'DGB');
    });

    testWidgets('signale qu\'aucune structure ne correspond', (tester) async {
      await tester.pumpWidget(
        buildFakeApp(
          home: frApp(
            Scaffold(
              body: StructurePickerField(value: null, onChanged: (_) {}),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Structure'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'zzzzzz');
      await tester.pumpAndSettle();

      expect(find.text('Aucune structure trouvée.'), findsOneWidget);
    });
  });
}
