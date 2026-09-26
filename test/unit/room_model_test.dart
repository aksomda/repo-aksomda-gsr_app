import 'package:flutter_test/flutter_test.dart';
import 'package:gsr_app/features/rooms/data/models/room_model.dart';
import 'package:gsr_app/features/rooms/domain/entities/room.dart';

void main() {
  group('RoomModel', () {
    test('fromJson lit une ligne de la table room (colonnes réelles)', () {
      final json = {
        'id': 5,
        'name': 'Salle Kadiogo',
        'region': 0,
        'province': 0,
        'city': 0,
        'region_name': 'Centre',
        'province_name': 'Kadiogo',
        'city_name': 'Ouagadougou',
        'location': 'Bloc C',
        'hasComputer': 1,
        'computerCount': 4,
        'category_room_id': 2,
        'structure_code': 'DGI-4',
        'rentalAmount': 10000,
        'status': 3,
      };

      final room = RoomModel.fromJson(json);

      expect(room.id, 5);
      expect(room.name, 'Salle Kadiogo');
      expect(room.region, 'Centre');
      expect(room.province, 'Kadiogo');
      expect(room.city, 'Ouagadougou');
      expect(room.location, 'Bloc C');
      expect(room.hasComputer, isTrue);
      expect(room.computerCount, 4);
      expect(room.rentalAmount, 10000.0);
      expect(room.categoryId, 2);
      expect(room.directionRegionaleId, 'DGI-4');
      expect(room.status, 'en refection');
    });

    test('toJson envoie les colonnes de room (statut en entier)', () {
      final json = RoomModel.fromEntity(
        Room(
          name: 'Salle Test',
          region: 'Centre',
          province: 'Kadiogo',
          city: 'Ouagadougou',
          location: 'Siège',
          hasComputer: true,
          computerCount: 2,
          categoryId: 1,
          directionRegionaleId: 'DGI-16',
          rentalAmount: 500,
          status: 'dégradé',
        ),
      ).toJson();

      expect(json['region_name'], 'Centre');
      expect(json['location'], 'Siège');
      expect(json['category_room_id'], 1);
      expect(json['structure_code'], 'DGI-16');
      expect(json['hasComputer'], 1);
      expect(json['rentalAmount'], 500);
      expect(json['status'], 4);
    });

    test('fromJson applique des valeurs par défaut sur champs manquants', () {
      final json = {'id': 1, 'rental_amount': null};

      final room = RoomModel.fromJson(json);

      expect(room.name, '');
      expect(room.categoryId, isNull);
      expect(room.directionRegionaleId, isNull);
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
          categoryId: 1,
          directionRegionaleId: 'DGI-4',
          rentalAmount: 0,
          status: 'disponible',
        ),
      );

      final roundTripped = RoomModel.fromJson(original.toJson());

      expect(roundTripped.id, original.id);
      expect(roundTripped.name, original.name);
      expect(roundTripped.location, original.location);
      expect(roundTripped.hasComputer, original.hasComputer);
      expect(roundTripped.status, original.status);
      expect(roundTripped.categoryId, original.categoryId);
      expect(roundTripped.directionRegionaleId, 'DGI-4');
    });
  });
}
