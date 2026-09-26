import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gsr_app/core/network/api_client.dart';
import 'package:gsr_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:gsr_app/features/auth/domain/exceptions/auth_exception.dart';
import 'package:gsr_app/features/chat/data/datasources/message_remote_datasource.dart';
import 'package:gsr_app/features/reservations_rooms/data/datasources/reservation_room_remote_data_source.dart';
import 'package:gsr_app/features/rooms/data/datasources/room_remote_data_source.dart';
import 'package:gsr_app/features/statistics/data/datasources/statistics_remote_datasource.dart';
import 'package:gsr_app/features/user_management/data/datasources/user_management_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

http.Response _json(Object body, [int status = 200]) => http.Response(
  json.encode(body),
  status,
  headers: {'content-type': 'application/json'},
);

void main() {
  late http.Client originalClient;
  final calls = <http.Request>[];

  void serve(http.Response Function(http.Request request) handler) {
    calls.clear();
    ApiClient.client = MockClient((request) async {
      calls.add(request);
      return handler(request);
    });
  }

  setUp(() => originalClient = ApiClient.client);
  tearDown(() => ApiClient.client = originalClient);

  group('Comptes utilisateurs', () {
    test(
      'valider / rejeter appelle la route avec le LOGIN de l\'agent',
      () async {
        serve((_) => _json({'success': true}));
        final source = UserManagementRemoteDataSource();

        expect(await source.approveUser('217071K'), isTrue);
        expect(await source.rejectUser('217071K'), isTrue);

        expect(calls[0].method, 'POST');
        expect(calls[0].url.path, endsWith('/users/217071K/approve'));
        expect(calls[1].url.path, endsWith('/users/217071K/reject'));
      },
    );

    test('un login avec caractères spéciaux est encodé dans l\'URL', () async {
      serve((_) => _json({'success': true}));

      await UserManagementRemoteDataSource().approveUser('a/b c');

      expect(calls.single.url.path, endsWith('/users/a%2Fb%20c/approve'));
    });

    test(
      'la création active l\'agent existant (login + mot de passe)',
      () async {
        serve((_) => _json({'success': true}, 201));

        final ok = await UserManagementRemoteDataSource().activateAgent(
          login: '217071K',
          password: 'secret1',
        );

        expect(ok, isTrue);
        expect(calls.single.url.path, endsWith('/users/activate-direct'));
        expect(json.decode(calls.single.body), {
          'login': '217071K',
          'password': 'secret1',
        });
      },
    );

    test('une action refusée par le serveur renvoie false', () async {
      serve((_) => _json({'error': 'Aucun agent trouvé.'}, 404));

      expect(
        await UserManagementRemoteDataSource().activateAgent(
          login: 'X',
          password: 'secret1',
        ),
        isFalse,
      );
      expect(await UserManagementRemoteDataSource().approveUser('X'), isFalse);
    });

    test('les comptes en attente sont désérialisés (login inclus)', () async {
      serve(
        (_) => _json([
          {
            'login': '217071K',
            'nom': 'OUEDRAOGO',
            'prenom': 'Awa',
            'email': 'a@b.bf',
            'role': 'agent',
          },
        ]),
      );

      final users = await UserManagementRemoteDataSource().getPendingUsers();

      expect(users.single.login, '217071K');
      expect(users.single.nomComplet, 'Awa OUEDRAOGO');
    });
  });

  group('Chargement des listes : les erreurs ne sont plus masquées', () {
    test(
      'salles : une erreur serveur lève une ApiException (et non une liste vide)',
      () async {
        serve((_) => _json({'error': 'boom'}, 500));

        expect(
          () => RoomRemoteDataSource().getRooms(),
          throwsA(isA<ApiException>()),
        );
      },
    );

    test('salles : lecture d\'une ligne de la table room', () async {
      serve(
        (_) => _json([
          {
            'id': 1,
            'name': 'Salle A',
            'status': 2,
            'category_room_id': 3,
            'structure_code': 'DGI-4',
            'rentalAmount': 0,
          },
        ]),
      );

      final rooms = await RoomRemoteDataSource().getRooms();

      expect(rooms.single.status, 'reservé');
      expect(rooms.single.directionRegionaleId, 'DGI-4');
    });

    test('salles disponibles : le créneau est passé en paramètres', () async {
      serve((_) => _json([]));

      await RoomRemoteDataSource().getAvailableRooms(
        date: '2026-05-01',
        startTime: '09:00',
        endTime: '10:00',
      );

      expect(calls.single.url.queryParameters, {
        'date': '2026-05-01',
        'start_time': '09:00',
        'end_time': '10:00',
      });
    });

    test('réservations : erreur réseau propagée', () async {
      ApiClient.client = MockClient(
        (_) async => throw http.ClientException('offline'),
      );

      expect(
        () => ReservationRoomRemoteDataSource().getAllReservations(),
        throwsA(isA<ApiException>()),
      );
    });

    test(
      'création d\'une réservation : renvoie le message du serveur en cas de conflit',
      () async {
        serve((_) => _json({'error': 'Ce créneau est déjà réservé.'}, 409));

        final error = await ReservationRoomRemoteDataSource().createReservation(
          roomId: 1,
          meetingSubject: 'Revue',
          organizingStructure: 'DSI',
          date: '2026-05-01',
          startTime: '09:00',
          endTime: '10:00',
        );

        expect(error, 'Ce créneau est déjà réservé.');
      },
    );

    test('création d\'une réservation : null en cas de succès', () async {
      serve((_) => _json({'success': true}, 201));

      final error = await ReservationRoomRemoteDataSource().createReservation(
        roomId: 1,
        meetingSubject: 'Revue',
        organizingStructure: 'DSI',
        date: '2026-05-01',
        startTime: '09:00',
        endTime: '10:00',
      );

      expect(error, isNull);
    });
  });

  group('Statistiques et messagerie', () {
    test(
      'les statistiques lisent byStatus, mostRequested et byStructure',
      () async {
        serve(
          (_) => _json({
            'byStatus': [
              {'status': 'validee', 'total': 3},
              {'status': 'en_attente', 'total': '1'},
            ],
            'mostRequested': [
              {'room_id': 2, 'name': 'Salle B', 'total': 4},
            ],
            'byStructure': [
              {
                'structure': 'DIRECTION RÉGIONALE DES IMPÔTS DU CENTRE',
                'total': 5,
              },
            ],
          }),
        );

        final stats = await StatisticsRemoteDataSource().getRoomStatistics();

        expect(stats.countFor('validee'), 3);
        expect(stats.countFor('en_attente'), 1);
        expect(stats.mostRequested.single.name, 'Salle B');
        expect(stats.byDirectionRegionale.values.single, 5);
      },
    );

    test('un admin écrit à un agent : recipient_login est envoyé', () async {
      serve((_) => _json({'success': true}, 201));

      final ok = await MessageRemoteDataSource().sendMessage(
        content: 'Bonjour',
        recipientLogin: '217071K',
      );

      expect(ok, isTrue);
      expect(json.decode(calls.single.body), {
        'content': 'Bonjour',
        'recipient_login': '217071K',
      });
    });

    test('un agent écrit à l\'administration : pas de destinataire', () async {
      serve((_) => _json({'success': true}, 201));

      await MessageRemoteDataSource().sendMessage(content: 'Bonjour');

      expect(json.decode(calls.single.body), {'content': 'Bonjour'});
    });

    test('la conversation admin passe le login en paramètre "with"', () async {
      serve((_) => _json([]));

      await MessageRemoteDataSource().getConversation(withLogin: '217071K');

      expect(calls.single.url.queryParameters, {'with': '217071K'});
    });
  });

  group('Authentification', () {
    test('la connexion renvoie le jeton et le profil', () async {
      serve(
        (_) => _json({
          'success': true,
          'token': 'jwt-abc',
          'user': {
            'login': '217071K',
            'nom': 'X',
            'prenom': 'Y',
            'email': 'x@y.bf',
            'role': 'admin',
          },
        }),
      );

      final session = await AuthRemoteDataSource().login(
        email: '217071K',
        password: 'secret1',
      );

      expect(session.token, 'jwt-abc');
      expect(session.user.isAdmin, isTrue);
      expect(calls.single.headers.containsKey('Authorization'), isFalse);
    });

    test(
      'un mauvais mot de passe lève une AuthException avec le message du serveur',
      () async {
        serve(
          (_) =>
              _json({'error': 'Identifiant ou mot de passe incorrect.'}, 401),
        );

        expect(
          () => AuthRemoteDataSource().login(email: 'x', password: 'y'),
          throwsA(
            isA<AuthException>().having(
              (e) => e.message,
              'message',
              contains('incorrect'),
            ),
          ),
        );
      },
    );

    test('un serveur hors ligne lève une AuthException lisible', () async {
      ApiClient.client = MockClient(
        (_) async => throw http.ClientException('offline'),
      );

      expect(
        () => AuthRemoteDataSource().login(email: 'x', password: 'y'),
        throwsA(isA<AuthException>()),
      );
    });

    test('getMe lève une ApiException 401 si le jeton est refusé', () async {
      serve((_) => _json({}, 401));

      expect(
        () => AuthRemoteDataSource().getMe(),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 401),
        ),
      );
    });
  });
}
