import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:gsr_app/features/categories_rooms/domain/usecases/get_category_rooms.dart';
import 'package:gsr_app/features/categories_rooms/domain/usecases/save_category_room.dart';
import 'package:gsr_app/features/categories_rooms/presentation/bloc/providers/category_room_provider.dart';
import 'package:gsr_app/features/categories_rooms/presentation/screens/category_rooms_screen.dart';

import '../helpers/fakes.dart';

void main() {
  testWidgets('CategoryRoomsScreen affiche le titre et les catégories', (tester) async {
    final repository = FakeCategoryRoomRepository();
    final provider = CategoryRoomProvider(
      getCategoryRoomsUseCase: GetCategoryRooms(repository),
      saveCategoryRoomUseCase: SaveCategoryRoom(repository),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: CategoryRoomsScreen()),
      ),
    );
    await provider.fetchRooms();
    await tester.pump();

    expect(find.text('Gestion des catégories de salles de réunion'), findsOneWidget);
    expect(find.text('GRATUIT'), findsWidgets);
  });
}
