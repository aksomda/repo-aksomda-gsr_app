import 'package:flutter_test/flutter_test.dart';
import 'package:gsr_app/features/rooms/data/models/room_model.dart';
import 'package:gsr_app/features/rooms/domain/entities/room.dart';

void main() {
  group('RoomModel', () {
    test('fromJson construit correctement un modèle complet', () {
      final json = {
        'id': 5,
        'name': 'Salle Kadiogo',
        'region': 'Centre',
        'province': 'Kadiogo',
        'city': 'Ouagadougou',
        'location': 'Bloc C',
        'has_computer': 1,
        'computer_count': 4,
        'category': 'location',
        'rental_amount': '10000',
        'status': 'disponible',
      };

      final room = RoomModel.fromJson(json);

      expect(room.id, 5);
      expect(room.name, 'Salle Kadiogo');
      expect(room.hasComputer, isTrue);
      expect(room.rentalAmount, 10000.0);
      expect(room.category, 'location');
    });

    test('fromJson applique des valeurs par défaut sur champs manquants', () {
      final json = {'id': 1, 'rental_amount': null};

      final room = RoomModel.fromJson(json);

      expect(room.name, '');
      expect(room.category, 'gratuit');
      expect(room.status, 'disponible');
      expect(room.hasComputer, isFalse);
      expect(room.rentalAmount, 0.0);
    });

    test('toJson puis fromJson conservent les données (round-trip)', () {
      final original = RoomModel.fromEntity(
        Room(
          id: 9,
          name: 'Salle Test',
          region: 'Centre',
          province: 'Kadiogo',
          city: 'Ouagadougou',
          location: 'Bloc D',
          hasComputer: true,
          computerCount: 2,
          category: 'gratuit',
          rentalAmount: 0,
          status: 'disponible',
        ),
      );

      final roundTripped = RoomModel.fromJson(original.toJson());

      expect(roundTripped.id, original.id);
      expect(roundTripped.name, original.name);
      expect(roundTripped.hasComputer, original.hasComputer);
      expect(roundTripped.status, original.status);
    });
  });
}
