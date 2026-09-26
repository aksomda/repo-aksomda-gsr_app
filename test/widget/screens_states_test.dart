import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gsr_app/features/chat/presentation/widgets/conversation_view.dart';
import 'package:gsr_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:gsr_app/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:gsr_app/features/ref_structure/presentation/screens/structure_screen.dart';
import 'package:gsr_app/features/reservations_rooms/presentation/widgets/reservation_request_form.dart';
import 'package:gsr_app/features/rooms/presentation/screens/rooms_screen.dart';
import 'package:gsr_app/features/user_management/presentation/screens/user_management_screen.dart';

import '../helpers/fakes.dart';

Future<void> _bigScreen(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1000, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  group('État d\'erreur avec relance', () {
    testWidgets(
      'les salles : message d\'erreur, puis liste après « Réessayer »',
      (tester) async {
        final repo = FlakyRoomRepository();
        await tester.pumpWidget(
          buildFakeApp(
            isAdmin: true,
            roomRepository: repo,
            home: frApp(const RoomsScreen()),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Serveur injoignable'), findsOneWidget);
        expect(find.text('Aucune salle enregistrée.'), findsNothing);

        repo.failing = false;
        await tester.tap(find.text('Réessayer'));
        await tester.pumpAndSettle();

        expect(find.text('Serveur injoignable'), findsNothing);
        expect(find.text('Salle Panafricaine'), findsOneWidget);
      },
    );

    testWidgets(
      'le tableau de bord reste utilisable quand les salles ne se chargent pas',
      (tester) async {
        await _bigScreen(tester);
        await tester.pumpWidget(
          buildFakeApp(
            roomRepository: FlakyRoomRepository(),
            home: frApp(const Scaffold(body: DashboardScreen())),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Salles par statut'), findsOneWidget);
        expect(find.text('Aucune donnée disponible.'), findsWidgets);
      },
    );
  });

  group('Gestion des comptes utilisateurs', () {
    testWidgets(
      'l\'admin valide un compte : le login est transmis et la ligne disparaît',
      (tester) async {
        final repo = RecordingUserRepository();
        await tester.pumpWidget(
          buildFakeApp(
            isAdmin: true,
            userManagementRepository: repo,
            home: frApp(const UserManagementScreen()),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Awa OUEDRAOGO'), findsOneWidget);

        await tester.tap(find.byTooltip('Valider le compte'));
        await tester.pumpAndSettle();

        expect(repo.approved, ['217071K']);
        expect(find.text('Awa OUEDRAOGO'), findsNothing);
        expect(
          find.text('Aucun compte en attente de validation.'),
          findsOneWidget,
        );
      },
    );

    testWidgets('l\'admin rejette un compte', (tester) async {
      final repo = RecordingUserRepository();
      await tester.pumpWidget(
        buildFakeApp(
          isAdmin: true,
          userManagementRepository: repo,
          home: frApp(const UserManagementScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Rejeter le compte'));
      await tester.pumpAndSettle();

      expect(repo.rejected, ['217071K']);
    });
  });

  group('Autres écrans', () {
    testWidgets('notifications : état vide', (tester) async {
      await tester.pumpWidget(
        buildFakeApp(home: frApp(const NotificationsScreen())),
      );
      await tester.pumpAndSettle();

      expect(find.text('Aucune notification.'), findsOneWidget);
    });

    testWidgets('structures : liste des structures et formulaire d\'ajout', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildFakeApp(isAdmin: true, home: frApp(const StructureScreen())),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Direction'), findsWidgets);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.text('Nouvelle structure'), findsOneWidget);

      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();
      expect(find.text('Le code est requis.'), findsOneWidget);
    });

    testWidgets('messagerie : état vide de la conversation', (tester) async {
      await tester.pumpWidget(
        buildFakeApp(home: frApp(const Scaffold(body: ConversationView()))),
      );
      await tester.pumpAndSettle();

      expect(find.text('Aucun message pour le moment.'), findsOneWidget);
      expect(find.text('Écrire un message...'), findsOneWidget);
    });

    testWidgets('demande de réservation : contrôle des champs obligatoires', (
      tester,
    ) async {
      await _bigScreen(tester);
      await tester.pumpWidget(
        buildFakeApp(
          home: frApp(
            Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () => showReservationRequestForm(context),
                  child: const Text('ouvrir'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('ouvrir'));
      await tester.pumpAndSettle();
      expect(find.text('Nouvelle demande de réservation'), findsOneWidget);

      await tester.tap(find.text('Envoyer la demande'));
      await tester.pumpAndSettle();

      expect(find.text("L'objet est requis."), findsOneWidget);
      expect(find.text('Nouvelle demande de réservation'), findsOneWidget);
    });
  });
}
