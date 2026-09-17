import 'package:flutter_test/flutter_test.dart';
import 'package:gsr_app/features/rooms/domain/usecases/get_rooms.dart';
import 'package:gsr_app/features/rooms/domain/usecases/save_room.dart';
import 'package:gsr_app/features/rooms/domain/entities/room.dart';
import 'package:gsr_app/features/rooms/presentation/bloc/providers/room_provider.dart';

import '../helpers/fakes.dart';

RoomProvider _buildProvider(FakeRoomRepository repository) {
  return RoomProvider(
    getRoomsUseCase: GetRooms(repository),
    saveRoomUseCase: SaveRoom(repository),
  );
}

void main() {
  group('RoomProvider', () {
    test('fetchRooms bascule isLoading puis peuple la liste', () async {
      final provider = _buildProvider(FakeRoomRepository());
      expect(provider.isLoading, isFalse);
      expect(provider.rooms, isEmpty);

      final future = provider.fetchRooms();
      expect(provider.isLoading, isTrue);
      await future;

      expect(provider.isLoading, isFalse);
      expect(provider.rooms, hasLength(2));
    });

    test('getRoomsByStatus filtre correctement (insensible à la casse)', () async {
      final provider = _buildProvider(FakeRoomRepository());
      await provider.fetchRooms();

      final disponibles = provider.getRoomsByStatus('Disponible');

      expect(disponibles, hasLength(1));
      expect(disponibles.first.name, 'Salle Panafricaine');
    });

    test('addOrUpdateRoom ajoute une salle et rafraîchit la liste', () async {
      final repository = FakeRoomRepository();
      final provider = _buildProvider(repository);
      await provider.fetchRooms();

      final success = await provider.addOrUpdateRoom(
        Room(
          name: 'Nouvelle Salle',
          region: 'Sahel',
          province: 'Séno',
          city: 'Dori',
          location: 'Bloc E',
          hasComputer: false,
          computerCount: 0,
          category: 'gratuit',
          rentalAmount: 0,
          status: 'disponible',
        ),
      );

      expect(success, isTrue);
      expect(provider.rooms, hasLength(3));
    });
  });
}
