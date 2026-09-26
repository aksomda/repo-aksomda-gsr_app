import 'package:flutter_test/flutter_test.dart';
import 'package:gsr_app/features/categories_rooms/data/models/category_room_model.dart';
import 'package:gsr_app/features/categories_rooms/domain/entities/category_room.dart';

void main() {
  group('CategoryRoomModel', () {
    test('fromJson construit correctement un modèle', () {
      final json = {
        'id': 3,
        'libelle': 'LOCATION',
        'type': 'location',
        'montant_location': '20000.00',
        'actif': 1,
      };

      final category = CategoryRoomModel.fromJson(json);

      expect(category.id, 3);
      expect(category.libelleCat, 'LOCATION');
      expect(category.type, 'location');
      expect(category.montantLocation, 20000);
      expect(category.actif, 1);
    });

    test('fromJson applique des valeurs par défaut sur champs manquants', () {
      final category = CategoryRoomModel.fromJson({'id': 1});

      expect(category.libelleCat, '');
      expect(category.type, 'gratuite');
      expect(category.montantLocation, 0);
      expect(category.actif, 0);
    });

    test('toJson puis fromJson conservent les données (round-trip)', () {
      final original = CategoryRoomModel.fromEntity(
        CategoryRoom(
          id: 7,
          libelleCat: 'GRATUIT',
          type: 'gratuite',
          montantLocation: 0,
          actif: 1,
        ),
      );

      final roundTripped = CategoryRoomModel.fromJson(original.toJson());

      expect(roundTripped.id, original.id);
      expect(roundTripped.libelleCat, original.libelleCat);
      expect(roundTripped.type, original.type);
      expect(roundTripped.actif, original.actif);
    });
  });
}
