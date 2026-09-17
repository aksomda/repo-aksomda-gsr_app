import 'package:flutter_test/flutter_test.dart';
import 'package:gsr_app/features/reservations_rooms/data/models/reservation_room_model.dart';
import 'package:gsr_app/features/reservations_rooms/domain/entities/reservation_room.dart';

void main() {
  group('ReservationRoomModel', () {
    test('fromJson construit correctement un modèle', () {
      final json = {
        'id': 4,
        'meeting_subject': 'Atelier budget',
        'organizing_structure': 'DGTCP',
        'date': '2026-09-12',
        'start_time': '08:00',
        'end_time': '10:00',
        'state': 'traitée',
        'status': 'reservé',
      };

      final reservation = ReservationRoomModel.fromJson(json);

      expect(reservation.id, 4);
      expect(reservation.meetingSubject, 'Atelier budget');
      expect(reservation.state, 'traitée');
    });

    test('fromJson applique des valeurs par défaut sur champs manquants', () {
      final reservation = ReservationRoomModel.fromJson({'id': 1});

      expect(reservation.meetingSubject, '');
      expect(reservation.state, 'en cours');
    });

    test('toJson puis fromJson conservent les données (round-trip)', () {
      final original = ReservationRoomModel.fromEntity(
        ReservationRoom(
          id: 8,
          meetingSubject: 'Point hebdo',
          organizingStructure: 'DSI',
          date: '2026-09-13',
          startTime: '09:00',
          endTime: '10:00',
          state: 'rejetée',
          status: 'disponible',
        ),
      );

      final roundTripped = ReservationRoomModel.fromJson(original.toJson());

      expect(roundTripped.meetingSubject, original.meetingSubject);
      expect(roundTripped.state, original.state);
      expect(roundTripped.date, original.date);
    });
  });
}
