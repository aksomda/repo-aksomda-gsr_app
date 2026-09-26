import 'package:flutter_test/flutter_test.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/create_reservation.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/get_all_reservations.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/get_my_reservations.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/reject_reservation.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/validate_reservation.dart';
import 'package:gsr_app/features/reservations_rooms/presentation/providers/reservation_room_provider.dart';

import '../helpers/fakes.dart';

ReservationRoomProvider _buildProvider(
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
  group('ReservationRoomProvider', () {
    test('fetchMine peuple la liste', () async {
      final provider = _buildProvider(FakeReservationRoomRepository());
      await provider.fetchMine();
      expect(provider.reservations, hasLength(2));
    });

    test('getByStatus filtre correctement par statut', () async {
      final provider = _buildProvider(FakeReservationRoomRepository());
      await provider.fetchAll();

      final validees = provider.getByStatus('validee');
      final enAttente = provider.getByStatus('en_attente');

      expect(validees, hasLength(1));
      expect(enAttente, hasLength(1));
      expect(validees.first.meetingSubject, 'Comité de pilotage');
    });

    test('requestReservation ajoute une demande en attente', () async {
      final provider = _buildProvider(FakeReservationRoomRepository());
      await provider.fetchMine();

      final success = await provider.requestReservation(
        roomId: 1,
        meetingSubject: 'Nouvelle réunion',
        organizingStructure: 'DSI',
        date: '2026-09-20',
        startTime: '09:00',
        endTime: '10:00',
      );

      expect(success, isTrue);
      expect(provider.reservations, hasLength(3));
    });

    test('validate fait passer une réservation à "validee"', () async {
      final provider = _buildProvider(FakeReservationRoomRepository());
      await provider.fetchAll();

      final success = await provider.validate(1);

      expect(success, isTrue);
      expect(provider.getByStatus('validee'), hasLength(2));
    });

    test(
      'reject fait passer une réservation à "rejetee" avec un motif',
      () async {
        final provider = _buildProvider(FakeReservationRoomRepository());
        await provider.fetchAll();

        final success = await provider.reject(1, reason: 'Salle indisponible');

        expect(success, isTrue);
        final rejected = provider.getByStatus('rejetee');
        expect(rejected, hasLength(1));
        expect(rejected.first.rejectionReason, 'Salle indisponible');
      },
    );
  });
}
