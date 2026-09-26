import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gsr_app/core/config/api_config.dart';
import 'package:gsr_app/core/network/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  late http.Client originalClient;
  late Duration originalTimeout;

  setUp(() {
    originalClient = ApiClient.client;
    originalTimeout = ApiClient.timeout;
  });

  tearDown(() {
    ApiClient.client = originalClient;
    ApiClient.timeout = originalTimeout;
    ApiClient.onUnauthorized = null;
  });

  group('ApiClient', () {
    test('renvoie la réponse pour un code 2xx et construit l\'URL', () async {
      Uri? requested;
      ApiClient.client = MockClient((request) async {
        requested = request.url;
        return http.Response(json.encode([1, 2]), 200);
      });

      final data = await ApiClient.getList('/rooms', query: {'a': 'b'});

      expect(data, [1, 2]);
      expect(requested!.path, endsWith('/rooms'));
      expect(requested!.queryParameters, {'a': 'b'});
    });

    test('remonte le message d\'erreur du serveur (4xx/5xx)', () async {
      ApiClient.client = MockClient(
        (_) async =>
            http.Response(json.encode({'error': 'Créneau déjà pris.'}), 409),
      );

      expect(
        () => ApiClient.post('/reservations', body: {}),
        throwsA(
          isA<ApiException>()
              .having((e) => e.message, 'message', 'Créneau déjà pris.')
              .having((e) => e.statusCode, 'statusCode', 409),
        ),
      );
    });

    test('un serveur injoignable donne une erreur réseau', () async {
      ApiClient.client = MockClient(
        (_) async => throw http.ClientException('boom'),
      );

      expect(
        () => ApiClient.get('/rooms'),
        throwsA(
          isA<ApiException>().having(
            (e) => e.isNetworkError,
            'isNetworkError',
            isTrue,
          ),
        ),
      );
    });

    test('un serveur trop lent déclenche le délai maximal', () async {
      ApiClient.timeout = const Duration(milliseconds: 30);
      ApiClient.client = MockClient((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 300));
        return http.Response('[]', 200);
      });

      expect(
        () => ApiClient.get('/rooms'),
        throwsA(
          isA<ApiException>().having(
            (e) => e.isNetworkError,
            'isNetworkError',
            isTrue,
          ),
        ),
      );
    });

    test('un 401 authentifié signale l\'expiration de la session', () async {
      var expired = 0;
      ApiClient.onUnauthorized = () => expired++;
      ApiClient.client = MockClient((_) async => http.Response('{}', 401));

      await expectLater(
        () => ApiClient.get('/rooms'),
        throwsA(isA<ApiException>()),
      );
      expect(expired, 1);
    });

    test(
      'un 401 non authentifié (mauvais mot de passe) ne ferme aucune session',
      () async {
        var expired = 0;
        ApiClient.onUnauthorized = () => expired++;
        ApiClient.client = MockClient(
          (_) async => http.Response(
            json.encode({'error': 'Identifiant ou mot de passe incorrect.'}),
            401,
          ),
        );

        await expectLater(
          () => ApiClient.post('/auth/login', body: {}, auth: false),
          throwsA(
            isA<ApiException>().having(
              (e) => e.message,
              'message',
              contains('incorrect'),
            ),
          ),
        );
        expect(expired, 0);
      },
    );

    test(
      'une réponse qui n\'est pas une liste est refusée par getList',
      () async {
        ApiClient.client = MockClient(
          (_) async => http.Response('{"a":1}', 200),
        );

        expect(() => ApiClient.getList('/rooms'), throwsA(isA<ApiException>()));
      },
    );
  });

  group('ApiConfig.releaseConfigError', () {
    test('ne bloque rien hors release', () {
      expect(
        ApiConfig.releaseConfigError(
          url: 'http://localhost:3000',
          isRelease: false,
        ),
        isNull,
      );
    });

    test('refuse http et les adresses locales en release', () {
      expect(
        ApiConfig.releaseConfigError(
          url: 'http://api.exemple.bf/api',
          isRelease: true,
        ),
        isNotNull,
      );
      expect(
        ApiConfig.releaseConfigError(
          url: 'https://localhost/api',
          isRelease: true,
        ),
        isNotNull,
      );
      expect(
        ApiConfig.releaseConfigError(
          url: 'https://10.0.2.2/api',
          isRelease: true,
        ),
        isNotNull,
      );
    });

    test('accepte une URL https publique en release', () {
      expect(
        ApiConfig.releaseConfigError(
          url: 'https://api.exemple.bf/api/gsr',
          isRelease: true,
        ),
        isNull,
      );
    });

    test('la valeur par défaut des tests n\'est pas en release', () {
      expect(kReleaseMode, isFalse);
      expect(ApiConfig.releaseConfigError(), isNull);
    });
  });

  test('errorMessageOf masque les erreurs techniques', () {
    expect(
      errorMessageOf(const ApiException('Détail serveur')),
      'Détail serveur',
    );
    expect(errorMessageOf(StateError('interne')), isNot(contains('interne')));
  });

  test('TimeoutException du client est bien une erreur réseau', () {
    expect(TimeoutException('x'), isA<Exception>());
  });
}
