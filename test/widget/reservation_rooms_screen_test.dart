import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/get_reservation_rooms.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/save_reservation_room.dart';
import 'package:gsr_app/features/reservations_rooms/presentation/providers/reservation_room_provider.dart';
import 'package:gsr_app/features/reservations_rooms/presentation/screens/reservation_rooms_screen.dart';

import '../helpers/fakes.dart';

void main() {
  testWidgets('ReservationRoomsScreen affiche le titre et les réservations', (tester) async {
    final repository = FakeReservationRoomRepository();
    final provider = ReservationRoomProvider(
      getReservationRoomsUseCase: GetReservationRooms(repository),
      saveReservationRoomUseCase: SaveReservationRoom(repository),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: ReservationRoomsScreen()),
      ),
    );
    await provider.fetchReservations();
    await tester.pump();

    expect(find.text('Demandes de Réservation'), findsOneWidget);
    expect(find.text('Revue budgétaire'), findsOneWidget);
  });
}
