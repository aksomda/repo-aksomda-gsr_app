import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gsr_app/core/network/api_client.dart';
import 'package:gsr_app/features/reservations_rooms/domain/entities/reservation_room.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/create_reservation.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/get_all_reservations.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/get_my_reservations.dart';
import 'package:gsr_app/features/reservations_rooms/presentation/providers/reservation_room_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../helpers/fakes.dart';

List<ReservationRoom> _reservations(int n) => List.generate(
  n,
  (i) => ReservationRoom(
    id: i + 1,
    roomId: 1,
    meetingSubject: 'Réunion ${i + 1}',
    organizingStructure: 'DGI',
    date: '2026-09-10',
    startTime: '09:00:00',
    endTime: '10:00:00',
    status: 'en_attente',
  ),
);

ReservationRoomProvider _provider(FakeReservationRoomRepository repo) =>
    ReservationRoomProvider(
      getMyReservationsUseCase: GetMyReservations(repo),
      getAllReservationsUseCase: GetAllReservations(repo),
      createReservationUseCase: CreateReservation(repo),
    );

void main() {
  group('ApiClient.getPage', () {
    late http.Client original;
    setUp(() => original = ApiClient.client);
    tearDown(() => ApiClient.client = original);

    test('envoie limit/offset et lit l\'en-tête X-Has-More', () async {
      Uri? url;
      ApiClient.client = MockClient((request) async {
        url = request.url;
        return http.Response(
          json.encode([1, 2]),
          200,
          headers: {'x-has-more': 'true'},
        );
      });

      final page = await ApiClient.getPage(
        '/reservations',
        offset: 50,
        query: {'status': 'validee'},
      );

      expect(page.items, [1, 2]);
      expect(page.hasMore, isTrue);
      expect(url!.queryParameters, {
        'status': 'validee',
        'limit': '50',
        'offset': '50',
      });
    });

    test('sans l\'en-tête, il n\'y a pas de page suivante', () async {
      ApiClient.client = MockClient((_) async => http.Response('[]', 200));

      expect((await ApiClient.getPage('/reservations')).hasMore, isFalse);
    });
  });

  group('ReservationRoomProvider : pagination', () {
    test('la première page ne charge que pageSize éléments', () async {
      final provider = _provider(
        FakeReservationRoomRepository(initial: _reservations(5), pageSize: 2),
      );

      await provider.fetchMine();

      expect(provider.reservations, hasLength(2));
      expect(provider.hasMore, isTrue);
    });

    test('loadMore ajoute les pages suivantes jusqu\'à la fin', () async {
      final provider = _provider(
        FakeReservationRoomRepository(initial: _reservations(5), pageSize: 2),
      );
      await provider.fetchMine();

      await provider.loadMore();
      expect(provider.reservations.map((r) => r.id), [1, 2, 3, 4]);
      expect(provider.hasMore, isTrue);

      await provider.loadMore();
      expect(provider.reservations, hasLength(5));
      expect(provider.hasMore, isFalse);
    });

    test('loadMore ne fait rien quand il n\'y a plus de résultats', () async {
      final provider = _provider(
        FakeReservationRoomRepository(initial: _reservations(1), pageSize: 2),
      );
      await provider.fetchMine();

      await provider.loadMore();

      expect(provider.reservations, hasLength(1));
    });

    test('un rechargement repart de la première page', () async {
      final provider = _provider(
        FakeReservationRoomRepository(initial: _reservations(5), pageSize: 2),
      );
      await provider.fetchAll();
      await provider.loadMore();

      await provider.fetchAll();

      expect(provider.reservations, hasLength(2));
    });
  });
}
