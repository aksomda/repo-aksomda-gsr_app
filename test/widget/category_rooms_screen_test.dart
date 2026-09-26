import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:gsr_app/features/categories_rooms/domain/usecases/get_category_rooms.dart';
import 'package:gsr_app/features/categories_rooms/domain/usecases/save_category_room.dart';
import 'package:gsr_app/features/categories_rooms/presentation/bloc/providers/category_room_provider.dart';
import 'package:gsr_app/features/categories_rooms/presentation/screens/category_rooms_screen.dart';
import 'package:gsr_app/features/auth/domain/entities/user.dart';
import 'package:gsr_app/features/auth/domain/usecases/login_user.dart';
import 'package:gsr_app/features/auth/domain/usecases/register_user.dart';
import 'package:gsr_app/features/auth/presentation/providers/auth_provider.dart';

import '../helpers/fakes.dart';

Widget _buildTestable(CategoryRoomProvider provider, {bool isAdmin = false}) {
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

  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: provider),
      ChangeNotifierProvider.value(value: authProvider),
    ],
    child: frApp(const CategoryRoomsScreen()),
  );
}

void main() {
  testWidgets('CategoryRoomsScreen affiche le titre et les catégories', (
    tester,
  ) async {
    final repository = FakeCategoryRoomRepository();
    final provider = CategoryRoomProvider(
      getCategoryRoomsUseCase: GetCategoryRooms(repository),
      saveCategoryRoomUseCase: SaveCategoryRoom(repository),
    );

    await tester.pumpWidget(_buildTestable(provider));
    await provider.fetchRooms();
    await tester.pump();

    expect(
      find.text('Gestion des catégories de salles de réunion'),
      findsOneWidget,
    );
    expect(find.text('GRATUIT'), findsWidgets);
  });

  testWidgets("un agent ne voit ni bouton d'ajout ni actions d'édition", (
    tester,
  ) async {
    final repository = FakeCategoryRoomRepository();
    final provider = CategoryRoomProvider(
      getCategoryRoomsUseCase: GetCategoryRooms(repository),
      saveCategoryRoomUseCase: SaveCategoryRoom(repository),
    );

    await tester.pumpWidget(_buildTestable(provider, isAdmin: false));
    await provider.fetchRooms();
    await tester.pump();

    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.byIcon(Icons.edit_outlined), findsNothing);
  });

  testWidgets("un admin voit le bouton d'ajout et les actions d'édition", (
    tester,
  ) async {
    final repository = FakeCategoryRoomRepository();
    final provider = CategoryRoomProvider(
      getCategoryRoomsUseCase: GetCategoryRooms(repository),
      saveCategoryRoomUseCase: SaveCategoryRoom(repository),
    );

    await tester.pumpWidget(_buildTestable(provider, isAdmin: true));
    await provider.fetchRooms();
    await tester.pump();

    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.edit_outlined), findsWidgets);
  });
}
