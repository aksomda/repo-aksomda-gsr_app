import 'package:flutter_test/flutter_test.dart';
import 'package:gsr_app/features/categories_rooms/domain/usecases/get_category_rooms.dart';
import 'package:gsr_app/features/categories_rooms/domain/usecases/save_category_room.dart';
import 'package:gsr_app/features/categories_rooms/presentation/bloc/providers/category_room_provider.dart';

import '../helpers/fakes.dart';

void main() {
  group('CategoryRoomProvider', () {
    late CategoryRoomProvider provider;

    setUp(() {
      final repository = FakeCategoryRoomRepository();
      provider = CategoryRoomProvider(
        getCategoryRoomsUseCase: GetCategoryRooms(repository),
        saveCategoryRoomUseCase: SaveCategoryRoom(repository),
      );
    });

    test('fetchRooms peuple la liste des catégories', () async {
      await provider.fetchRooms();
      expect(provider.categoryRoom, hasLength(2));
    });

    test('getCategoryRoomsByType filtre par type', () async {
      await provider.fetchRooms();

      final gratuites = provider.getCategoryRoomsByType('gratuite');

      expect(gratuites, hasLength(1));
      expect(gratuites.first.libelleCat, 'GRATUIT');
    });
  });
}
