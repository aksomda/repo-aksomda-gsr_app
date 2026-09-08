import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:gsr_app/providers/room_provider.dart';
import 'package:gsr_app/providers/connectivity_provider.dart';
import 'package:gsr_app/screens/home_screen.dart';

void main() {
  testWidgets('GsrApp smoke test and navigation rendering', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => RoomProvider()),
          ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    expect(find.text('Salles'), findsOneWidget);
    expect(find.text('Réservations'), findsOneWidget);
    expect(find.text('Stats'), findsOneWidget);
    expect(find.text('Paramètres'), findsOneWidget);
  });
}
