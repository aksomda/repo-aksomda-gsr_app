import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:gsr_app/features/auth/domain/usecases/login_user.dart';
import 'package:gsr_app/features/auth/domain/usecases/register_user.dart';
import 'package:gsr_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:gsr_app/features/auth/presentation/screens/register_screen.dart';
import 'package:gsr_app/features/ref_structure/domain/usecases/get_structures.dart';
import 'package:gsr_app/features/ref_structure/domain/usecases/save_structure.dart';
import 'package:gsr_app/features/ref_structure/presentation/providers/structure_provider.dart';

import '../helpers/fakes.dart';

void main() {
  Widget buildTestable(AuthProvider provider) {
    final structureRepo = FakeStructureRepository();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: provider),
        ChangeNotifierProvider(
          create: (_) => StructureProvider(
            getStructuresUseCase: GetStructures(structureRepo),
            saveStructureUseCase: SaveStructure(structureRepo),
          )..fetchStructures(),
        ),
      ],
      child: frApp(const RegisterScreen()),
    );
  }

  testWidgets('affiche tous les champs requis pour créer un compte', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    final provider = AuthProvider(
      loginUseCase: LoginUser(repository),
      registerUseCase: RegisterUser(repository),
    );

    await tester.pumpWidget(buildTestable(provider));
    await tester.pumpAndSettle();

    for (final label in [
      'Nom',
      'Prénom',
      'Matricule',
      'Téléphone (WhatsApp)',
      'Numéro flotte',
      'Adresse e-mail',
      'Mot de passe',
      'Structure',
    ]) {
      expect(
        find.text(label),
        findsOneWidget,
        reason: 'champ "$label" manquant',
      );
    }
  });

  testWidgets('affiche une erreur de validation si les champs sont vides', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    final provider = AuthProvider(
      loginUseCase: LoginUser(repository),
      registerUseCase: RegisterUser(repository),
    );

    await tester.pumpWidget(buildTestable(provider));
    await tester.pumpAndSettle();

    final submitButton = find.widgetWithText(ElevatedButton, 'Créer le compte');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pump();

    expect(find.text('Nom est requis.'), findsOneWidget);
    expect(provider.isAuthenticated, isFalse);
  });
}
