import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:gsr_app/features/rooms/domain/usecases/get_rooms.dart';
import 'package:gsr_app/features/rooms/domain/usecases/save_room.dart';
import 'package:gsr_app/features/rooms/presentation/bloc/providers/room_provider.dart';
import 'package:gsr_app/features/categories_rooms/domain/usecases/get_category_rooms.dart';
import 'package:gsr_app/features/categories_rooms/domain/usecases/save_category_room.dart';
import 'package:gsr_app/features/categories_rooms/presentation/bloc/providers/category_room_provider.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/get_reservation_rooms.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/save_reservation_room.dart';
import 'package:gsr_app/features/reservations_rooms/presentation/providers/reservation_room_provider.dart';
import 'package:gsr_app/l10n/app_localizations.dart';
import 'package:gsr_app/screens/main_navigation_screen.dart';

import '../helpers/fakes.dart';

Widget _buildApp() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) {
          final repo = FakeRoomRepository();
          return RoomProvider(
            getRoomsUseCase: GetRooms(repo),
            saveRoomUseCase: SaveRoom(repo),
          )..fetchRooms();
        },
      ),
      ChangeNotifierProvider(
        create: (_) {
          final repo = FakeCategoryRoomRepository();
          return CategoryRoomProvider(
            getCategoryRoomsUseCase: GetCategoryRooms(repo),
            saveCategoryRoomUseCase: SaveCategoryRoom(repo),
          )..fetchRooms();
        },
      ),
      ChangeNotifierProvider(
        create: (_) {
          final repo = FakeReservationRoomRepository();
          return ReservationRoomProvider(
            getReservationRoomsUseCase: GetReservationRooms(repo),
            saveReservationRoomUseCase: SaveReservationRoom(repo),
          )..fetchReservations();
        },
      ),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MainNavigationScreen(),
    ),
  );
}

void main() {
  testWidgets('affiche 5 onglets de navigation', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    final navBar = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
    expect(navBar.items, hasLength(5));
  });

  testWidgets('taper sur un onglet change l\'écran affiché', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    // Écran initial : Salles.
    expect(find.text('Gestion des Salles de Réunion'), findsOneWidget);

    // Onglet Statistiques (index 3).
    await tester.tap(find.text('Statistiques'));
    await tester.pumpAndSettle();
    expect(find.text('Statistiques & Analytique GsrApp'), findsOneWidget);

    // Onglet Paramètres (index 4).
    await tester.tap(find.text('Paramètres'));
    await tester.pumpAndSettle();
    expect(find.text('Version de l\'application'), findsOneWidget);
  });
}
