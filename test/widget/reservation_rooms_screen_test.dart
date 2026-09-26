import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:gsr_app/features/reservations_rooms/domain/entities/reservation_room.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/create_reservation.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/get_all_reservations.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/get_my_reservations.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/reject_reservation.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/validate_reservation.dart';
import 'package:gsr_app/features/reservations_rooms/presentation/providers/reservation_room_provider.dart';
import 'package:gsr_app/features/reservations_rooms/presentation/screens/reservation_rooms_screen.dart';
import 'package:gsr_app/features/rooms/domain/usecases/get_available_rooms.dart';
import 'package:gsr_app/features/rooms/domain/usecases/get_rooms.dart';
import 'package:gsr_app/features/rooms/domain/usecases/save_room.dart';
import 'package:gsr_app/features/rooms/presentation/bloc/providers/room_provider.dart';
import 'package:gsr_app/features/auth/domain/entities/user.dart';
import 'package:gsr_app/features/auth/domain/usecases/login_user.dart';
import 'package:gsr_app/features/auth/domain/usecases/register_user.dart';
import 'package:gsr_app/features/auth/presentation/providers/auth_provider.dart';

import '../helpers/fakes.dart';

Widget _buildTestable(
  ReservationRoomProvider provider, {
  bool isAdmin = false,
}) {
  final authProvider = AuthProvider(
    loginUseCase: LoginUser(FakeAuthRepository()),
    registerUseCase: RegisterUser(FakeAuthRepository()),
  );
  if (isAdmin) {
    authProvider.debugSetUser(
      User(
        nom: 'Admin',
        prenom: 'Test',
        matricule: 'A1',
        telephone: '0000',
        email: 'admin@gsr.bf',
        structureCode: 'DSI',
        structureLibelle: 'DSI',
        role: 'admin',
      ),
    );
  }

  final roomRepo = FakeRoomRepository();

  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: provider),
      ChangeNotifierProvider.value(value: authProvider),
      ChangeNotifierProvider(
        create: (_) => RoomProvider(
          getRoomsUseCase: GetRooms(roomRepo),
          saveRoomUseCase: SaveRoom(roomRepo),
          getAvailableRoomsUseCase: GetAvailableRooms(roomRepo),
        ),
      ),
    ],
    child: frApp(const ReservationRoomsScreen()),
  );
}

ReservationRoomProvider _buildReservationProvider(
  FakeReservationRoomRepository repository,
) {
  return ReservationRoomProvider(
    getMyReservationsUseCase: GetMyReservations(repository),
    getAllReservationsUseCase: GetAllReservations(repository),
    createReservationUseCase: CreateReservation(repository),
    validateReservationUseCase: ValidateReservation(repository),
    rejectReservationUseCase: RejectReservation(repository),
  );
}

void main() {
  _paginationTests();

  testWidgets('un agent voit ses réservations et le bouton "Demander"', (
    tester,
  ) async {
    final provider = _buildReservationProvider(FakeReservationRoomRepository());

    await tester.pumpWidget(_buildTestable(provider, isAdmin: false));
    await tester.pumpAndSettle();

    expect(find.text('Demandes de Réservation'), findsOneWidget);
    expect(
      find.text('Revue budgétaire'),
      findsOneWidget,
    ); // statut en_attente, onglet par défaut
    expect(
      find.widgetWithText(FloatingActionButton, 'Demander'),
      findsOneWidget,
    );
  });

  testWidgets(
    'un admin voit les actions valider/rejeter sur les demandes en attente',
    (tester) async {
      final provider = _buildReservationProvider(
        FakeReservationRoomRepository(),
      );

      await tester.pumpWidget(_buildTestable(provider, isAdmin: true));
      await tester.pumpAndSettle();

      expect(
        find.text('Revue budgétaire'),
        findsOneWidget,
      ); // en_attente, onglet par défaut
      expect(find.widgetWithText(ElevatedButton, 'Valider'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Rejeter'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsNothing);
    },
  );
}

void _paginationTests() {
  testWidgets('« Charger plus » ajoute la page suivante des réservations', (
    tester,
  ) async {
    final repository = FakeReservationRoomRepository(
      pageSize: 1,
      initial: [
        for (var i = 1; i <= 3; i++)
          ReservationRoom(
            id: i,
            roomId: 1,
            roomName: 'Salle A',
            meetingSubject: 'Réunion $i',
            organizingStructure: 'DGI',
            date: '2026-09-10',
            startTime: '09:00:00',
            endTime: '10:00:00',
            status: 'en_attente',
          ),
      ],
    );
    final provider = _buildReservationProvider(repository);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: provider),
          ChangeNotifierProvider(
            create: (_) => AuthProvider(
              loginUseCase: LoginUser(FakeAuthRepository()),
              registerUseCase: RegisterUser(FakeAuthRepository()),
            ),
          ),
        ],
        child: frApp(const ReservationRoomsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Réunion 1'), findsOneWidget);
    expect(find.text('Réunion 2'), findsNothing);

    await tester.tap(find.text('Charger plus'));
    await tester.pumpAndSettle();

    expect(find.text('Réunion 2'), findsOneWidget);
    expect(find.text('Charger plus'), findsOneWidget);

    await tester.tap(find.text('Charger plus'));
    await tester.pumpAndSettle();

    expect(find.text('Réunion 3'), findsOneWidget);
    expect(find.text('Charger plus'), findsNothing);
  });
}
