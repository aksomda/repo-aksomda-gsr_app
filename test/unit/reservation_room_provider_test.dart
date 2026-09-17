import 'package:flutter_test/flutter_test.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/get_reservation_rooms.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/save_reservation_room.dart';
import 'package:gsr_app/features/reservations_rooms/presentation/providers/reservation_room_provider.dart';

import '../helpers/fakes.dart';

void main() {
  group('ReservationRoomProvider', () {
    late ReservationRoomProvider provider;

    setUp(() {
      final repository = FakeReservationRoomRepository();
      provider = ReservationRoomProvider(
        getReservationRoomsUseCase: GetReservationRooms(repository),
        saveReservationRoomUseCase: SaveReservationRoom(repository),
      );
    });

    test('fetchReservations peuple la liste', () async {
      await provider.fetchReservations();
      expect(provider.reservations, hasLength(2));
    });

    test('getByState filtre correctement par état', () async {
      await provider.fetchReservations();

      final traitees = provider.getByState('traitée');
      final enCours = provider.getByState('en cours');

      expect(traitees, hasLength(1));
      expect(enCours, hasLength(1));
      expect(traitees.first.meetingSubject, 'Comité de pilotage');
    });
  });
}
