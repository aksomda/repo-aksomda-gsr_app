import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gsr_app/features/statistics/presentation/screens/statistic_rooms_screen.dart';

void main() {
  testWidgets('StatisticRoomsScreen affiche les filtres et les cartes chiffrées', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: StatisticRoomsScreen()),
    );

    expect(find.text('Statistiques & Analytique GsrApp'), findsOneWidget);
    expect(find.text('Filtres Analytiques'), findsOneWidget);
    expect(find.text('Traitées'), findsOneWidget);
  });

  testWidgets('changer le mois sélectionné met à jour le menu déroulant', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: StatisticRoomsScreen()),
    );

    expect(find.text('Août 2026'), findsOneWidget);

    await tester.tap(find.text('Août 2026'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Juin 2026').last);
    await tester.pumpAndSettle();

    expect(find.text('Juin 2026'), findsOneWidget);
  });
}
