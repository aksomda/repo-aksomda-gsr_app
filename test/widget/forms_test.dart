import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gsr_app/core/widgets/searchable_select_field.dart';
import 'package:gsr_app/features/categories_rooms/domain/entities/category_room.dart';
import 'package:gsr_app/features/categories_rooms/presentation/widgets/category_room_form_dialog.dart';
import 'package:gsr_app/features/directions_regionales/domain/entities/direction_regionale.dart';
import 'package:gsr_app/features/rooms/domain/entities/room.dart';
import 'package:gsr_app/features/rooms/presentation/widgets/room_form_dialog.dart';
import 'package:gsr_app/features/user_management/presentation/widgets/create_user_form_dialog.dart';

import '../helpers/fakes.dart';

/// Affiche un bouton qui ouvre [open] et mémorise ce qu'il renvoie.
class _Host<T> extends StatefulWidget {
  final Future<T?> Function(BuildContext) open;

  const _Host(this.open);

  @override
  State<_Host<T>> createState() => _HostState<T>();
}

class _HostState<T> extends State<_Host<T>> {
  T? result;
  bool closed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final value = await widget.open(context);
            setState(() {
              result = value;
              closed = true;
            });
          },
          child: const Text('ouvrir'),
        ),
      ),
    );
  }
}

Future<void> _bigScreen(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1000, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

final _categories = [
  CategoryRoom(
    id: 1,
    libelleCat: 'GRATUIT',
    type: 'gratuite',
    montantLocation: 0,
    actif: 1,
  ),
  CategoryRoom(
    id: 2,
    libelleCat: 'LOCATION',
    type: 'location',
    montantLocation: 15000,
    actif: 1,
  ),
];

final _directions = [
  DirectionRegionale(
    id: 'DGI-4',
    nom: 'DIRECTION RÉGIONALE DES IMPÔTS DU CENTRE',
  ),
  DirectionRegionale(
    id: 'DGI-16',
    nom: 'DIRECTION RÉGIONALE DES IMPÔTS DES HAUTS BASSINS',
  ),
];

Future<void> _fill(WidgetTester tester, String label, String value) async {
  await tester.enterText(find.widgetWithText(TextFormField, label), value);
}

void main() {
  group('Formulaire de salle', () {
    Future<_HostState<Room>> open(WidgetTester tester, {Room? initial}) async {
      await _bigScreen(tester);
      await tester.pumpWidget(
        frApp(
          _Host<Room>(
            (context) => showRoomFormDialog(
              context,
              initial: initial,
              categories: _categories,
              directions: _directions,
            ),
          ),
        ),
      );
      await tester.tap(find.text('ouvrir'));
      await tester.pumpAndSettle();
      return tester.state<_HostState<Room>>(find.byType(_Host<Room>));
    }

    testWidgets(
      'refuse l\'enregistrement tant que les champs requis sont vides',
      (tester) async {
        final host = await open(tester);

        await tester.tap(find.text('Enregistrer'));
        await tester.pumpAndSettle();

        expect(find.text('Champ requis.'), findsWidgets);
        expect(find.text('Nouvelle salle'), findsOneWidget);
        expect(host.closed, isFalse);
      },
    );

    testWidgets('la catégorie est obligatoire (colonne NOT NULL en base)', (
      tester,
    ) async {
      final host = await open(tester);
      await _fill(tester, 'Nom de la salle', 'Salle Test');
      await _fill(tester, 'Région', 'Centre');
      await _fill(tester, 'Province', 'Kadiogo');
      await _fill(tester, 'Ville', 'Ouagadougou');
      await _fill(tester, 'Emplacement (bloc, étage...)', 'Siège');

      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();

      expect(find.text('Champ requis.'), findsOneWidget);
      expect(host.closed, isFalse);
    });

    testWidgets(
      'choix d\'une catégorie et d\'une direction filtrée par la recherche',
      (tester) async {
        final host = await open(tester);
        await _fill(tester, 'Nom de la salle', 'Salle Test');
        await _fill(tester, 'Région', 'Centre');
        await _fill(tester, 'Province', 'Kadiogo');
        await _fill(tester, 'Ville', 'Ouagadougou');
        await _fill(tester, 'Emplacement (bloc, étage...)', 'Siège');

        await tester.tap(find.text('Catégorie'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('GRATUIT'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Direction régionale'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField).last, 'hauts');
        await tester.pumpAndSettle();
        expect(find.textContaining('DU CENTRE'), findsNothing);
        await tester.tap(find.textContaining('HAUTS BASSINS'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Enregistrer'));
        await tester.pumpAndSettle();

        expect(host.closed, isTrue);
        expect(host.result!.name, 'Salle Test');
        expect(host.result!.categoryId, 1);
        expect(host.result!.directionRegionaleId, 'DGI-16');
        expect(host.result!.location, 'Siège');
      },
    );

    testWidgets('en modification, les valeurs existantes sont préremplies', (
      tester,
    ) async {
      await open(
        tester,
        initial: Room(
          id: 5,
          name: 'Salle Existante',
          region: 'Centre',
          province: 'Kadiogo',
          city: 'Ouaga',
          location: 'Bloc A',
          hasComputer: false,
          computerCount: 0,
          categoryId: 2,
          directionRegionaleId: 'DGI-4',
          rentalAmount: 15000,
          status: 'disponible',
        ),
      );

      expect(find.text('Modifier la salle'), findsOneWidget);
      expect(find.text('Salle Existante'), findsOneWidget);
      expect(find.text('LOCATION'), findsOneWidget);
    });

    testWidgets('Annuler ferme le formulaire sans résultat', (tester) async {
      final host = await open(tester);

      await tester.tap(find.text('Annuler'));
      await tester.pumpAndSettle();

      expect(host.closed, isTrue);
      expect(host.result, isNull);
    });
  });

  group('Formulaire de catégorie', () {
    testWidgets('valide le libellé et le montant, puis renvoie la catégorie', (
      tester,
    ) async {
      await _bigScreen(tester);
      await tester.pumpWidget(
        frApp(_Host<CategoryRoom>((c) => showCategoryRoomFormDialog(c))),
      );
      await tester.tap(find.text('ouvrir'));
      await tester.pumpAndSettle();
      final host = tester.state<_HostState<CategoryRoom>>(
        find.byType(_Host<CategoryRoom>),
      );

      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();
      expect(find.text('Le libellé est requis.'), findsOneWidget);
      expect(host.closed, isFalse);

      await _fill(tester, 'Libellé', 'GRATUIT');
      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();

      expect(host.closed, isTrue);
      expect(host.result!.libelleCat, 'GRATUIT');
    });
  });

  group('Formulaire de création de compte', () {
    testWidgets('refuse une saisie incomplète', (tester) async {
      await _bigScreen(tester);
      await tester.pumpWidget(
        buildFakeApp(
          isAdmin: true,
          home: frApp(_Host<NewUserData>((c) => showCreateUserFormDialog(c))),
        ),
      );
      await tester.tap(find.text('ouvrir'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Créer'));
      await tester.pumpAndSettle();

      expect(find.text('Champ requis.'), findsWidgets);
      final host = tester.state<_HostState<NewUserData>>(
        find.byType(_Host<NewUserData>),
      );
      expect(host.closed, isFalse);
    });
  });

  group('Sélecteur avec recherche', () {
    testWidgets('filtre les options et affiche « Aucun résultat »', (
      tester,
    ) async {
      await tester.pumpWidget(
        frApp(
          Scaffold(
            body: SearchableSelectField<int>(
              label: 'Choix',
              value: null,
              options: const [
                SelectOption(1, 'Alpha'),
                SelectOption(2, 'Bravo'),
              ],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('Choix'));
      await tester.pumpAndSettle();
      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Bravo'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pumpAndSettle();
      expect(find.text('Aucun résultat.'), findsOneWidget);
    });

    testWidgets('le bouton d\'effacement vide la sélection', (tester) async {
      int? value = 1;
      await tester.pumpWidget(
        frApp(
          StatefulBuilder(
            builder: (context, setState) => Scaffold(
              body: SearchableSelectField<int>(
                label: 'Choix',
                value: value,
                options: const [SelectOption(1, 'Alpha')],
                onChanged: (v) => setState(() => value = v),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Alpha'), findsOneWidget);

      await tester.tap(find.byTooltip('Effacer'));
      await tester.pumpAndSettle();

      expect(value, isNull);
    });
  });
}
