import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gsr_app/features/auth/domain/usecases/login_user.dart';
import 'package:gsr_app/features/auth/domain/usecases/register_user.dart';
import 'package:gsr_app/features/auth/presentation/providers/auth_provider.dart';

import '../helpers/fakes.dart';

AuthProvider _buildProvider(FakeAuthRepository repository) {
  return AuthProvider(
    loginUseCase: LoginUser(repository),
    registerUseCase: RegisterUser(repository),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('AuthProvider', () {
    test('login réussit avec des identifiants valides', () async {
      final provider = _buildProvider(FakeAuthRepository());

      final success = await provider.login(
        email: 'awa.ouedraogo@gsr.bf',
        password: 'motdepasse123',
      );

      expect(success, isTrue);
      expect(provider.isAuthenticated, isTrue);
      expect(provider.currentUser?.email, 'awa.ouedraogo@gsr.bf');
      expect(provider.errorMessage, isNull);
    });

    test('login échoue avec un mauvais mot de passe', () async {
      final provider = _buildProvider(FakeAuthRepository());

      final success = await provider.login(
        email: 'awa.ouedraogo@gsr.bf',
        password: 'mauvais_mdp',
      );

      expect(success, isFalse);
      expect(provider.isAuthenticated, isFalse);
      expect(provider.errorMessage, 'Email ou mot de passe incorrect.');
    });

    test(
      "register crée un compte en attente d'activation, sans connexion automatique",
      () async {
        final provider = _buildProvider(FakeAuthRepository());

        final success = await provider.register(
          nom: 'Kaboré',
          prenom: 'Issa',
          matricule: 'MAT099',
          telephone: '+22670111111',
          numeroFlotte: '+22670111112',
          email: 'issa.kabore@gsr.bf',
          password: 'nouveauMdp1',
          structureCode: 'DGB',
        );

        expect(success, isTrue);
        expect(provider.isAuthenticated, isFalse);
        expect(provider.infoMessage, isNotNull);
      },
    );

    test('register échoue si l\'email est déjà utilisé', () async {
      final provider = _buildProvider(FakeAuthRepository());

      final success = await provider.register(
        nom: 'Traoré',
        prenom: 'Fatou',
        matricule: 'MAT100',
        telephone: '+22670222222',
        numeroFlotte: '+22670222223',
        email: 'awa.ouedraogo@gsr.bf', // déjà pris
        password: 'motdepasse123',
        structureCode: 'DSI',
      );

      expect(success, isFalse);
      expect(provider.isAuthenticated, isFalse);
      expect(provider.errorMessage, isNotNull);
    });

    test('logout efface la session en cours', () async {
      final provider = _buildProvider(FakeAuthRepository());
      await provider.login(
        email: 'awa.ouedraogo@gsr.bf',
        password: 'motdepasse123',
      );
      expect(provider.isAuthenticated, isTrue);

      await provider.logout();

      expect(provider.isAuthenticated, isFalse);
      expect(provider.currentUser, isNull);
    });
  });
}
