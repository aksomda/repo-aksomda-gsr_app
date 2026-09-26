import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:gsr_app/features/rooms/domain/usecases/get_rooms.dart';
import 'package:gsr_app/features/rooms/domain/usecases/save_room.dart';
import 'package:gsr_app/features/rooms/presentation/bloc/providers/room_provider.dart';
import 'package:gsr_app/features/rooms/presentation/screens/rooms_screen.dart';
import 'package:gsr_app/features/categories_rooms/domain/usecases/get_category_rooms.dart';
import 'package:gsr_app/features/categories_rooms/domain/usecases/save_category_room.dart';
import 'package:gsr_app/features/categories_rooms/presentation/bloc/providers/category_room_provider.dart';
import 'package:gsr_app/features/directions_regionales/domain/usecases/get_directions_regionales.dart';
import 'package:gsr_app/features/directions_regionales/presentation/providers/direction_regionale_provider.dart';
import 'package:gsr_app/features/auth/domain/usecases/login_user.dart';
import 'package:gsr_app/features/auth/domain/usecases/register_user.dart';
import 'package:gsr_app/features/auth/presentation/providers/auth_provider.dart';

import '../helpers/fakes.dart';

Widget _buildTestable(RoomProvider provider) {
  final categoryRepo = FakeCategoryRoomRepository();
  final directionRepo = FakeDirectionRegionaleRepository();

  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: provider),
      ChangeNotifierProvider(
        create: (_) => CategoryRoomProvider(
          getCategoryRoomsUseCase: GetCategoryRooms(categoryRepo),
          saveCategoryRoomUseCase: SaveCategoryRoom(categoryRepo),
        )..fetchRooms(),
      ),
      ChangeNotifierProvider(
        create: (_) => DirectionRegionaleProvider(
          getDirectionsRegionalesUseCase: GetDirectionsRegionales(
            directionRepo,
          ),
        )..fetchDirections(),
      ),
      ChangeNotifierProvider(
        create: (_) => AuthProvider(
          loginUseCase: LoginUser(FakeAuthRepository()),
          registerUseCase: RegisterUser(FakeAuthRepository()),
        ),
      ),
    ],
    child: frApp(const RoomsScreen()),
  );
}

void main() {
  testWidgets('affiche le titre et les onglets de la liste des salles', (
    tester,
  ) async {
    final repository = FakeRoomRepository();
    final provider = RoomProvider(
      getRoomsUseCase: GetRooms(repository),
      saveRoomUseCase: SaveRoom(repository),
    );

    await tester.pumpWidget(_buildTestable(provider));
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

    await tester.pumpWidget(_buildTestable(provider));
    await provider.fetchRooms();
    await tester.pump();

    expect(find.text('Salle Panafricaine'), findsOneWidget);
    expect(find.text('Salle Nazi Boni'), findsOneWidget);
  });
}
