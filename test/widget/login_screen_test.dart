import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:gsr_app/features/auth/domain/usecases/login_user.dart';
import 'package:gsr_app/features/auth/domain/usecases/register_user.dart';
import 'package:gsr_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:gsr_app/features/auth/presentation/screens/login_screen.dart';
import 'package:gsr_app/features/auth/presentation/screens/register_screen.dart';
import 'package:gsr_app/features/ref_structure/domain/usecases/get_structures.dart';
import 'package:gsr_app/features/ref_structure/domain/usecases/save_structure.dart';
import 'package:gsr_app/features/ref_structure/presentation/providers/structure_provider.dart';

import '../helpers/fakes.dart';

Widget _buildTestable(AuthProvider provider) {
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
    child: frApp(const LoginScreen()),
  );
}

AuthProvider _buildProvider() {
  final repository = FakeAuthRepository();
  return AuthProvider(
    loginUseCase: LoginUser(repository),
    registerUseCase: RegisterUser(repository),
  );
}

void main() {
  group('LoginScreen (mobile, < 900px)', () {
    testWidgets(
      "affiche l'écran d'accueil avec Se connecter / Créer un compte",
      (tester) async {
        await tester.pumpWidget(_buildTestable(_buildProvider()));

        expect(
          find.widgetWithText(ElevatedButton, 'Se connecter'),
          findsOneWidget,
        );
        expect(
          find.widgetWithText(OutlinedButton, 'Créer un compte'),
          findsOneWidget,
        );
        expect(find.byType(TextFormField), findsNothing);
      },
    );

    testWidgets('un tap sur "Se connecter" affiche le formulaire', (
      tester,
    ) async {
      await tester.pumpWidget(_buildTestable(_buildProvider()));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Se connecter'));
      await tester.pumpAndSettle();

      expect(find.text('Email ou identifiant'), findsOneWidget);
      expect(find.text('Mot de passe'), findsOneWidget);
    });

    testWidgets('une connexion réussie authentifie l\'utilisateur', (
      tester,
    ) async {
      final provider = _buildProvider();
      await tester.pumpWidget(_buildTestable(provider));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Se connecter'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).first,
        'awa.ouedraogo@gsr.bf',
      );
      await tester.enterText(find.byType(TextFormField).last, 'motdepasse123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Se connecter'));
      await tester.pumpAndSettle();

      expect(provider.isAuthenticated, isTrue);
    });

    testWidgets('un tap sur "Créer un compte" ouvre RegisterScreen', (
      tester,
    ) async {
      await tester.pumpWidget(_buildTestable(_buildProvider()));

      await tester.tap(find.widgetWithText(OutlinedButton, 'Créer un compte'));
      await tester.pumpAndSettle();

      expect(find.byType(RegisterScreen), findsOneWidget);
    });
  });

  group('LoginScreen (web/desktop, >= 900px)', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    testWidgets('affiche le formulaire directement, sans écran d\'accueil', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildTestable(_buildProvider()));

      expect(find.text('Email ou identifiant'), findsOneWidget);
      expect(find.text('Mot de passe'), findsOneWidget);
      expect(
        find.widgetWithText(ElevatedButton, 'Se connecter'),
        findsOneWidget,
      );
    });
  });
}
