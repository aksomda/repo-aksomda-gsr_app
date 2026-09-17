import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:gsr_app/features/rooms/domain/usecases/get_rooms.dart';
import 'package:gsr_app/features/rooms/domain/usecases/save_room.dart';
import 'package:gsr_app/features/rooms/presentation/bloc/providers/room_provider.dart';
import 'package:gsr_app/features/rooms/presentation/screens/rooms_screen.dart';

import '../helpers/fakes.dart';

void main() {
  Widget buildTestable(RoomProvider provider) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: const MaterialApp(home: RoomsScreen()),
    );
  }

  testWidgets('affiche le titre et les onglets de la liste des salles', (tester) async {
    final repository = FakeRoomRepository();
    final provider = RoomProvider(
      getRoomsUseCase: GetRooms(repository),
      saveRoomUseCase: SaveRoom(repository),
    );

    await tester.pumpWidget(buildTestable(provider));
    await provider.fetchRooms();
    await tester.pump();

    expect(find.text('Gestion des Salles de Réunion'), findsOneWidget);
    expect(find.text('Toutes'), findsOneWidget);
    expect(find.text('Disponibles'), findsOneWidget);
  });

  testWidgets('affiche les salles chargées dans la liste', (tester) async {
    final repository = FakeRoomRepository();
    final provider = RoomProvider(
      getRoomsUseCase: GetRooms(repository),
      saveRoomUseCase: SaveRoom(repository),
    );

    await tester.pumpWidget(buildTestable(provider));
    await provider.fetchRooms();
    await tester.pump();

    expect(find.text('Salle Panafricaine'), findsOneWidget);
    expect(find.text('Salle Nazi Boni'), findsOneWidget);
  });
}
