import 'package:flutter_test/flutter_test.dart';
import 'package:gsr_app/core/network/api_client.dart';
import 'package:gsr_app/features/auth/domain/entities/user.dart';
import 'package:gsr_app/features/auth/domain/usecases/login_user.dart';
import 'package:gsr_app/features/auth/domain/usecases/register_user.dart';
import 'package:gsr_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:gsr_app/features/rooms/domain/usecases/get_rooms.dart';
import 'package:gsr_app/features/rooms/domain/usecases/save_room.dart';
import 'package:gsr_app/features/rooms/presentation/bloc/providers/room_provider.dart';
import 'package:gsr_app/features/user_management/domain/usecases/approve_user.dart';
import 'package:gsr_app/features/user_management/domain/usecases/create_user.dart';
import 'package:gsr_app/features/user_management/domain/usecases/get_pending_users.dart';
import 'package:gsr_app/features/user_management/domain/usecases/reject_user.dart';
import 'package:gsr_app/features/user_management/presentation/providers/user_management_provider.dart';

import '../helpers/fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RoomProvider : état d\'erreur', () {
    test(
      'une erreur de chargement est exposée sans être confondue avec une liste vide',
      () async {
        final repo = FlakyRoomRepository();
        final provider = RoomProvider(
          getRoomsUseCase: GetRooms(repo),
          saveRoomUseCase: SaveRoom(repo),
        );

        await provider.fetchRooms();

        expect(provider.error, 'Serveur injoignable');
        expect(provider.rooms, isEmpty);
        expect(provider.isLoading, isFalse);
      },
    );

    test('un nouvel essai réussi efface l\'erreur', () async {
      final repo = FlakyRoomRepository();
      final provider = RoomProvider(
        getRoomsUseCase: GetRooms(repo),
        saveRoomUseCase: SaveRoom(repo),
      );
      await provider.fetchRooms();

      repo.failing = false;
      await provider.fetchRooms();

      expect(provider.error, isNull);
      expect(provider.rooms, isNotEmpty);
    });

    test('un échec ultérieur conserve les salles déjà chargées', () async {
      final repo = FlakyRoomRepository()..failing = false;
      final provider = RoomProvider(
        getRoomsUseCase: GetRooms(repo),
        saveRoomUseCase: SaveRoom(repo),
      );
      await provider.fetchRooms();

      repo.failing = true;
      await provider.fetchRooms();

      expect(provider.rooms, isNotEmpty);
      expect(provider.error, isNotNull);
    });
  });

  group('Comptes utilisateurs', () {
    UserManagementProvider build(RecordingUserRepository repo) =>
        UserManagementProvider(
          getPendingUsersUseCase: GetPendingUsers(repo),
          createUserUseCase: CreateUser(repo),
          approveUserUseCase: ApproveUser(repo),
          rejectUserUseCase: RejectUser(repo),
        );

    test(
      'valider un compte transmet le login puis rafraîchit la liste',
      () async {
        final repo = RecordingUserRepository();
        final provider = build(repo);
        await provider.fetchPendingUsers();
        expect(provider.pendingUsers, hasLength(1));

        final ok = await provider.approve('217071K');

        expect(ok, isTrue);
        expect(repo.approved, ['217071K']);
        expect(provider.pendingUsers, isEmpty);
      },
    );

    test('rejeter un compte transmet le login', () async {
      final repo = RecordingUserRepository();
      final provider = build(repo);

      await provider.reject('217071K');

      expect(repo.rejected, ['217071K']);
    });
  });

  group('Expiration de session', () {
    test('un 401 sur un appel authentifié déconnecte l\'utilisateur', () async {
      final repo = FakeAuthRepository();
      final auth = AuthProvider(
        loginUseCase: LoginUser(repo),
        registerUseCase: RegisterUser(repo),
      );
      auth.debugSetUser(
        User(
          nom: 'A',
          prenom: 'B',
          matricule: 'M',
          telephone: '0',
          email: 'a@b.bf',
        ),
      );
      expect(auth.isAuthenticated, isTrue);

      ApiClient.onUnauthorized!();
      await Future<void>.delayed(Duration.zero);

      expect(auth.isAuthenticated, isFalse);
      expect(auth.errorMessage, isNotNull);
    });

    test('sans utilisateur connecté, l\'événement est ignoré', () async {
      final repo = FakeAuthRepository();
      final auth = AuthProvider(
        loginUseCase: LoginUser(repo),
        registerUseCase: RegisterUser(repo),
      );

      ApiClient.onUnauthorized!();
      await Future<void>.delayed(Duration.zero);

      expect(auth.errorMessage, isNull);
    });
  });
}
