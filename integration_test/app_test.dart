import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

import 'package:gsr_app/features/rooms/data/datasources/room_remote_data_source.dart';
import 'package:gsr_app/features/rooms/data/repositories/room_repository_impl.dart';
import 'package:gsr_app/features/rooms/domain/usecases/get_rooms.dart';
import 'package:gsr_app/features/rooms/domain/usecases/save_room.dart';
import 'package:gsr_app/features/rooms/presentation/bloc/providers/room_provider.dart';

import 'package:gsr_app/features/categories_rooms/data/datasources/category_room_remote_data_source.dart';
import 'package:gsr_app/features/categories_rooms/data/repositories/category_room_repository_impl.dart';
import 'package:gsr_app/features/categories_rooms/domain/usecases/get_category_rooms.dart';
import 'package:gsr_app/features/categories_rooms/domain/usecases/save_category_room.dart';
import 'package:gsr_app/features/categories_rooms/presentation/bloc/providers/category_room_provider.dart';

import 'package:gsr_app/features/reservations_rooms/data/datasources/reservation_room_remote_data_source.dart';
import 'package:gsr_app/features/reservations_rooms/data/repositories/reservation_room_repository_impl.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/get_reservation_rooms.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/save_reservation_room.dart';
import 'package:gsr_app/features/reservations_rooms/presentation/providers/reservation_room_provider.dart';

import 'package:gsr_app/l10n/app_localizations.dart';
import 'package:gsr_app/screens/main_navigation_screen.dart';

/// Reproduit la composition réelle de l'application (voir lib/main.dart),
/// avec les mêmes sources de données réseau. En environnement de test, les
/// appels au backend échouent silencieusement (listes vides), ce qui permet
/// de valider la navigation et le rendu sans dépendre d'un serveur actif.
Widget _buildRealApp() {
  final roomRepo = RoomRepositoryImpl(RoomRemoteDataSource());
  final categoryRepo = CategoryRoomRepositoryImpl(CategoryRoomRemoteDataSource());
  final reservationRepo = ReservationRoomRepositoryImpl(ReservationRoomRemoteDataSource());

  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => RoomProvider(
          getRoomsUseCase: GetRooms(roomRepo),
          saveRoomUseCase: SaveRoom(roomRepo),
        )..fetchRooms(),
      ),
      ChangeNotifierProvider(
        create: (_) => CategoryRoomProvider(
          getCategoryRoomsUseCase: GetCategoryRooms(categoryRepo),
          saveCategoryRoomUseCase: SaveCategoryRoom(categoryRepo),
        )..fetchRooms(),
      ),
      ChangeNotifierProvider(
        create: (_) => ReservationRoomProvider(
          getReservationRoomsUseCase: GetReservationRooms(reservationRepo),
          saveReservationRoomUseCase: SaveReservationRoom(reservationRepo),
        )..fetchReservations(),
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
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Parcours utilisateur complet', () {
    testWidgets('l\'application démarre sur l\'écran des salles avec 5 onglets', (tester) async {
      await tester.pumpWidget(_buildRealApp());
      await tester.pumpAndSettle();

      expect(find.text('Gestion des Salles de Réunion'), findsOneWidget);

      final navBar = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(navBar.items, hasLength(5));
    });

    testWidgets('l\'utilisateur peut naviguer vers chaque onglet sans erreur', (tester) async {
      await tester.pumpWidget(_buildRealApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Catégories'));
      await tester.pumpAndSettle();
      expect(find.text('Gestion des catégories de salles de réunion'), findsOneWidget);

      await tester.tap(find.text('Réservations'));
      await tester.pumpAndSettle();
      expect(find.text('Demandes de Réservation'), findsOneWidget);

      await tester.tap(find.text('Statistiques'));
      await tester.pumpAndSettle();
      expect(find.text('Statistiques & Analytique GsrApp'), findsOneWidget);

      await tester.tap(find.text('Paramètres'));
      await tester.pumpAndSettle();
      expect(find.text('Version de l\'application'), findsOneWidget);

      await tester.tap(find.text('Liste des Salles'));
      await tester.pumpAndSettle();
      expect(find.text('Gestion des Salles de Réunion'), findsOneWidget);
    });
  });
}
