import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gsr_app/l10n/app_localizations.dart';
import 'package:gsr_app/screens/main_navigation_screen.dart';

import '../helpers/fakes.dart';

Widget _buildApp({bool isAdmin = false}) {
  return buildFakeApp(
    isAdmin: isAdmin,
    home: const MaterialApp(
      locale: Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MainNavigationScreen(),
    ),
  );
}

void main() {
  testWidgets(
    "un agent n'a pas accès aux écrans réservés aux admins dans le menu",
    (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.text('Liste des Salles'), findsWidgets);
      expect(find.text('Comptes utilisateurs'), findsNothing);
      expect(find.text('Directions régionales'), findsNothing);
    },
  );

  testWidgets(
    'un admin voit les écrans de gestion des comptes et des directions régionales',
    (tester) async {
      await tester.pumpWidget(_buildApp(isAdmin: true));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.text('Comptes utilisateurs'), findsOneWidget);
      expect(find.text('Directions régionales'), findsOneWidget);
    },
  );

  testWidgets('taper sur un élément du menu change l\'écran affiché', (
    tester,
  ) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    // Écran initial : Accueil (tableau de bord).
    expect(find.text('Accueil'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Liste des Salles').last);
    await tester.pumpAndSettle();
    expect(find.text('Gestion des Salles de Réunion'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Statistiques').last);
    await tester.pumpAndSettle();
    expect(find.text('Statistiques & Analytique GsrApp'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Paramètres').last);
    await tester.pumpAndSettle();
    expect(find.text('Version de l\'application'), findsOneWidget);
  });

  testWidgets("l'accueil affiche le tableau de bord avec ses graphiques", (
    tester,
  ) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Salles par statut'), findsOneWidget);
    expect(find.text('Réservations par statut'), findsOneWidget);
  });

  testWidgets('le menu propose la déconnexion avec confirmation', (
    tester,
  ) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Se déconnecter'));
    await tester.pumpAndSettle();

    expect(
      find.text('Voulez-vous vraiment vous déconnecter ?'),
      findsOneWidget,
    );

    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();
    expect(find.text('Voulez-vous vraiment vous déconnecter ?'), findsNothing);
  });
}
