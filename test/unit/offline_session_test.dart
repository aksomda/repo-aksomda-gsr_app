import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gsr_app/core/network/api_client.dart';
import 'package:gsr_app/core/storage/profile_cache.dart';
import 'package:gsr_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:gsr_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

class InMemoryStore implements SecureKeyValueStore {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;

  @override
  Future<void> delete(String key) async => values.remove(key);
}

const _profile = {
  'login': '217071K',
  'nom': 'OUEDRAOGO',
  'prenom': 'Awa',
  'email': 'awa@dgi.bf',
  'role': 'agent',
};

void main() {
  late http.Client originalClient;
  late InMemoryStore store;
  late AuthRepositoryImpl repository;

  setUp(() {
    originalClient = ApiClient.client;
    store = InMemoryStore();
    ProfileCache.store = store;
    repository = AuthRepositoryImpl(AuthRemoteDataSource());
  });

  tearDown(() {
    ApiClient.client = originalClient;
    ProfileCache.store = const PlatformSecureStore();
  });

  group('Restauration de la session au démarrage', () {
    test('serveur joignable : profil à jour, mis en cache', () async {
      ApiClient.client = MockClient(
        (_) async => http.Response(json.encode(_profile), 200),
      );

      final user = await repository.restoreSession('jeton');

      expect(user!.login, '217071K');
      expect(await ProfileCache.load(), containsPair('login', '217071K'));
    });

    test(
      'hors ligne : le dernier profil connu est utilisé (pas de déconnexion)',
      () async {
        await ProfileCache.save(_profile);
        ApiClient.client = MockClient(
          (_) async => throw http.ClientException('offline'),
        );

        final user = await repository.restoreSession('jeton');

        expect(user, isNotNull);
        expect(user!.nomComplet, 'Awa OUEDRAOGO');
      },
    );

    test(
      'serveur en panne (5xx) : le profil en cache est utilisé aussi',
      () async {
        await ProfileCache.save(_profile);
        ApiClient.client = MockClient((_) async => http.Response('{}', 503));

        expect(await repository.restoreSession('jeton'), isNotNull);
      },
    );

    test('hors ligne sans profil en cache : pas de session', () async {
      ApiClient.client = MockClient(
        (_) async => throw http.ClientException('offline'),
      );

      expect(await repository.restoreSession('jeton'), isNull);
    });

    test(
      'jeton refusé (401) : pas de session, même avec un profil en cache',
      () async {
        await ProfileCache.save(_profile);
        ApiClient.client = MockClient((_) async => http.Response('{}', 401));

        expect(await repository.restoreSession('jeton'), isNull);
      },
    );
  });

  test('la connexion enregistre le profil pour le mode hors ligne', () async {
    ApiClient.client = MockClient(
      (_) async => http.Response(
        json.encode({'success': true, 'token': 't', 'user': _profile}),
        200,
      ),
    );

    await repository.login(email: '217071K', password: 'secret1');

    expect((await ProfileCache.load())!['login'], '217071K');
  });

  test('le cache est corrompu : il est ignoré sans planter', () async {
    store.values['gsr_cached_profile'] = '{pas du json';

    expect(await ProfileCache.load(), isNull);
  });
}
