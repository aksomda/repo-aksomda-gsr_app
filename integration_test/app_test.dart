import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:gsr_app/l10n/app_localizations.dart';
import 'package:gsr_app/main.dart' show AuthGate;
import 'package:gsr_app/screens/main_navigation_screen.dart';

import '../test/helpers/fakes.dart';

/// Compose l'application avec des dépôts factices (aucun appel réseau), pour
/// valider bout en bout la navigation et le parcours d'authentification.
Widget _buildAppWithFakeAuth({required Widget home}) {
  return buildFakeApp(
    home: MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Parcours utilisateur complet', () {
    testWidgets('l\'application démarre sur l\'accueil (tableau de bord)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildAppWithFakeAuth(home: const MainNavigationScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Accueil'), findsOneWidget);
      expect(find.text('Salles par statut'), findsOneWidget);
    });

    testWidgets(
      'l\'utilisateur peut naviguer vers chaque écran depuis le menu sans erreur',
      (tester) async {
        await tester.pumpWidget(
          _buildAppWithFakeAuth(home: const MainNavigationScreen()),
        );
        await tester.pumpAndSettle();

        Future<void> openMenuAndTap(String label) async {
          await tester.tap(find.byIcon(Icons.menu));
          await tester.pumpAndSettle();
          await tester.tap(find.text(label).last);
          await tester.pumpAndSettle();
        }

        await openMenuAndTap('Liste des Salles');
        expect(find.text('Gestion des Salles de Réunion'), findsOneWidget);

        await openMenuAndTap('Catégories');
        expect(
          find.text('Gestion des catégories de salles de réunion'),
          findsOneWidget,
        );

        await openMenuAndTap('Réservations');
        expect(find.text('Demandes de Réservation'), findsOneWidget);

        await openMenuAndTap('Statistiques');
        expect(find.text('Statistiques & Analytique GsrApp'), findsOneWidget);

        await openMenuAndTap('Paramètres');
        expect(find.text('Version de l\'application'), findsOneWidget);

        await openMenuAndTap('Liste des Salles');
        expect(find.text('Gestion des Salles de Réunion'), findsOneWidget);
      },
    );
  });

  group('Authentification', () {
    testWidgets(
      'affiche l\'écran de connexion puis la navigation principale après connexion réussie',
      (tester) async {
        // Taille mobile explicite : l'écran de connexion démarre sur l'accueil
        // "Se connecter" / "Créer un compte" (voir LoginScreen).
        await tester.binding.setSurfaceSize(const Size(400, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(_buildAppWithFakeAuth(home: const AuthGate()));
        await tester.pumpAndSettle();

        // Non connecté : écran d'accueil affiché, pas de menu de navigation.
        expect(
          find.widgetWithText(ElevatedButton, 'Se connecter'),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.menu), findsNothing);

        await tester.tap(find.widgetWithText(ElevatedButton, 'Se connecter'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(TextFormField).first,
          'awa.ouedraogo@gsr.bf',
        );
        await tester.enterText(
          find.byType(TextFormField).last,
          'motdepasse123',
        );
        await tester.tap(find.widgetWithText(ElevatedButton, 'Se connecter'));
        await tester.pumpAndSettle();

        // Connecté : navigation principale affichée, sur l'accueil.
        expect(find.text('Accueil'), findsOneWidget);
        expect(find.byIcon(Icons.menu), findsOneWidget);
      },
    );
  });
}
