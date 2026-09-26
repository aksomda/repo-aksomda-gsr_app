import 'package:flutter_test/flutter_test.dart';
import 'package:gsr_app/features/reservations_rooms/data/models/reservation_room_model.dart';

void main() {
  group('ReservationRoomModel', () {
    test(
      'fromJson construit correctement un modèle (vue admin, avec jointures)',
      () {
        final json = {
          'id': 4,
          'room_id': 2,
          'room_name': 'Salle Nazi Boni',
          'nom': 'Ouédraogo',
          'prenom': 'Awa',
          'meeting_subject': 'Atelier budget',
          'organizing_structure': 'DGTCP',
          'date': '2026-09-12',
          'start_time': '08:00:00',
          'end_time': '10:00:00',
          'status': 'validee',
        };

        final reservation = ReservationRoomModel.fromJson(json);

        expect(reservation.id, 4);
        expect(reservation.roomId, 2);
        expect(reservation.roomName, 'Salle Nazi Boni');
        expect(reservation.requesterName, 'Awa Ouédraogo');
        expect(reservation.meetingSubject, 'Atelier budget');
        expect(reservation.status, 'validee');
        expect(reservation.startTimeShort, '08:00');
      },
    );

    test('fromJson applique des valeurs par défaut sur champs manquants', () {
      final reservation = ReservationRoomModel.fromJson({'id': 1});

      expect(reservation.meetingSubject, '');
      expect(reservation.status, 'en_attente');
      expect(reservation.requesterName, isNull);
    });

    test('fromJson expose le motif de rejet quand présent', () {
      final reservation = ReservationRoomModel.fromJson({
        'id': 5,
        'status': 'rejetee',
        'rejection_reason': 'Salle en maintenance',
      });

      expect(reservation.status, 'rejetee');
      expect(reservation.rejectionReason, 'Salle en maintenance');
    });
  });
}
