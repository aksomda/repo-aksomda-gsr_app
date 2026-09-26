import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gsr_app/core/models/paged.dart';
import 'package:gsr_app/core/network/api_client.dart';
import 'package:gsr_app/core/settings/settings_provider.dart';
import 'package:gsr_app/l10n/app_localizations.dart';

import 'package:gsr_app/features/rooms/domain/entities/room.dart';
import 'package:gsr_app/features/rooms/domain/repositories/room_repository.dart';
import 'package:gsr_app/features/rooms/domain/usecases/delete_room.dart';
import 'package:gsr_app/features/rooms/domain/usecases/get_available_rooms.dart';
import 'package:gsr_app/features/rooms/domain/usecases/get_rooms.dart';
import 'package:gsr_app/features/rooms/domain/usecases/save_room.dart';
import 'package:gsr_app/features/rooms/presentation/bloc/providers/room_provider.dart';

import 'package:gsr_app/features/categories_rooms/domain/entities/category_room.dart';
import 'package:gsr_app/features/categories_rooms/domain/repositories/category_room_repository.dart';
import 'package:gsr_app/features/categories_rooms/domain/usecases/delete_category_room.dart';
import 'package:gsr_app/features/categories_rooms/domain/usecases/get_category_rooms.dart';
import 'package:gsr_app/features/categories_rooms/domain/usecases/save_category_room.dart';
import 'package:gsr_app/features/categories_rooms/presentation/bloc/providers/category_room_provider.dart';

import 'package:gsr_app/features/directions_regionales/domain/entities/direction_regionale.dart';
import 'package:gsr_app/features/directions_regionales/domain/repositories/direction_regionale_repository.dart';
import 'package:gsr_app/features/directions_regionales/domain/usecases/get_directions_regionales.dart';
import 'package:gsr_app/features/directions_regionales/presentation/providers/direction_regionale_provider.dart';

import 'package:gsr_app/features/ref_structure/domain/entities/structure.dart';
import 'package:gsr_app/features/ref_structure/domain/repositories/structure_repository.dart';
import 'package:gsr_app/features/ref_structure/domain/usecases/delete_structure.dart';
import 'package:gsr_app/features/ref_structure/domain/usecases/get_structures.dart';
import 'package:gsr_app/features/ref_structure/domain/usecases/save_structure.dart';
import 'package:gsr_app/features/ref_structure/presentation/providers/structure_provider.dart';

import 'package:gsr_app/features/reservations_rooms/domain/entities/reservation_room.dart';
import 'package:gsr_app/features/reservations_rooms/domain/repositories/reservation_room_repository.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/create_reservation.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/get_all_reservations.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/get_my_reservations.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/reject_reservation.dart';
import 'package:gsr_app/features/reservations_rooms/domain/usecases/validate_reservation.dart';
import 'package:gsr_app/features/reservations_rooms/presentation/providers/reservation_room_provider.dart';

import 'package:gsr_app/features/auth/domain/entities/auth_result.dart';
import 'package:gsr_app/features/auth/domain/entities/user.dart';
import 'package:gsr_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:gsr_app/features/auth/domain/usecases/login_user.dart';
import 'package:gsr_app/features/auth/domain/usecases/register_user.dart';
import 'package:gsr_app/features/auth/presentation/providers/auth_provider.dart';

import 'package:gsr_app/features/user_management/domain/repositories/user_management_repository.dart';
import 'package:gsr_app/features/user_management/domain/usecases/approve_user.dart';
import 'package:gsr_app/features/user_management/domain/usecases/create_user.dart';
import 'package:gsr_app/features/user_management/domain/usecases/get_pending_users.dart';
import 'package:gsr_app/features/user_management/domain/usecases/reject_user.dart';
import 'package:gsr_app/features/user_management/presentation/providers/user_management_provider.dart';

import 'package:gsr_app/features/notifications/domain/entities/notification_item.dart';
import 'package:gsr_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:gsr_app/features/notifications/domain/usecases/get_notifications.dart';
import 'package:gsr_app/features/notifications/domain/usecases/mark_notification_as_read.dart';
import 'package:gsr_app/features/notifications/presentation/providers/notification_provider.dart';

import 'package:gsr_app/features/chat/domain/entities/message.dart';
import 'package:gsr_app/features/chat/domain/entities/message_thread.dart';
import 'package:gsr_app/features/chat/domain/repositories/message_repository.dart';
import 'package:gsr_app/features/chat/domain/usecases/get_conversation.dart';
import 'package:gsr_app/features/chat/domain/entities/message_recipient.dart';
import 'package:gsr_app/features/chat/domain/usecases/get_recipients.dart';
import 'package:gsr_app/features/chat/domain/usecases/get_threads.dart';
import 'package:gsr_app/features/chat/domain/usecases/send_message.dart';
import 'package:gsr_app/features/chat/presentation/providers/message_provider.dart';

import 'package:gsr_app/features/statistics/domain/entities/room_statistics.dart';
import 'package:gsr_app/features/statistics/domain/repositories/statistics_repository.dart';
import 'package:gsr_app/features/statistics/domain/usecases/get_room_statistics.dart';
import 'package:gsr_app/features/statistics/presentation/providers/statistics_provider.dart';

/// Fausse implémentation en mémoire de [RoomRepository], utilisée pour isoler
/// les tests des appels réseau réels.
class FakeRoomRepository implements RoomRepository {
  List<Room> rooms;

  FakeRoomRepository({List<Room>? initialRooms})
    : rooms = initialRooms ?? _defaultRooms();

  static List<Room> _defaultRooms() => [
    Room(
      id: 1,
      name: 'Salle Panafricaine',
      region: 'Centre',
      province: 'Kadiogo',
      city: 'Ouagadougou',
      location: 'Bloc A',
      hasComputer: true,
      computerCount: 10,
      categoryId: 1,
      rentalAmount: 0,
      status: 'disponible',
    ),
    Room(
      id: 2,
      name: 'Salle Nazi Boni',
      region: 'Hauts-Bassins',
      province: 'Houet',
      city: 'Bobo-Dioulasso',
      location: 'Bloc B',
      hasComputer: false,
      computerCount: 0,
      categoryId: 2,
      rentalAmount: 25000,
      status: 'reservé',
    ),
  ];

  @override
  Future<List<Room>> getRooms() async => rooms;

  @override
  Future<List<Room>> getAvailableRooms({
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    return rooms.where((r) => r.status.toLowerCase() == 'disponible').toList();
  }

  @override
  Future<bool> saveRoom(Room room) async {
    rooms = [...rooms, room];
    return true;
  }

  @override
  Future<bool> deleteRoom(int id) async {
    rooms = rooms.where((r) => r.id != id).toList();
    return true;
  }
}

/// Fausse implémentation en mémoire de [CategoryRoomRepository].
class FakeCategoryRoomRepository implements CategoryRoomRepository {
  List<CategoryRoom> categoryRooms;

  FakeCategoryRoomRepository({List<CategoryRoom>? initial})
    : categoryRooms = initial ?? _defaultCategories();

  static List<CategoryRoom> _defaultCategories() => [
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

  @override
  Future<List<CategoryRoom>> getCategoryRooms() async => categoryRooms;

  @override
  Future<bool> saveCategoryRoom(CategoryRoom room) async {
    categoryRooms = [...categoryRooms, room];
    return true;
  }

  @override
  Future<bool> deleteCategoryRoom(int id) async {
    categoryRooms = categoryRooms.where((c) => c.id != id).toList();
    return true;
  }
}

/// Fausse implémentation en mémoire de [StructureRepository].
class FakeStructureRepository implements StructureRepository {
  List<Structure> structures;

  FakeStructureRepository({List<Structure>? initial})
    : structures =
          initial ??
          [
            Structure(
              codeCdi: 'DSI',
              libelleLongCdi: 'Direction des Systèmes d\'Information',
            ),
            Structure(
              codeCdi: 'DGB',
              libelleLongCdi: 'Direction Générale du Budget',
            ),
          ];

  @override
  Future<List<Structure>> getStructures() async => structures;

  @override
  Future<bool> saveStructure(Structure structure) async {
    structures = [...structures, structure];
    return true;
  }

  @override
  Future<bool> deleteStructure(String codeCdi) async {
    structures = structures.where((s) => s.codeCdi != codeCdi).toList();
    return true;
  }
}

/// Fausse implémentation en mémoire de [DirectionRegionaleRepository].
class FakeDirectionRegionaleRepository implements DirectionRegionaleRepository {
  List<DirectionRegionale> directions;

  FakeDirectionRegionaleRepository({List<DirectionRegionale>? initial})
    : directions =
          initial ??
          [
            DirectionRegionale(
              id: 'DGI-4',
              nom: 'Direction Régionale du Centre',
            ),
            DirectionRegionale(
              id: 'DGI-16',
              nom: 'Direction Régionale des Hauts-Bassins',
            ),
          ];

  @override
  Future<List<DirectionRegionale>> getDirectionsRegionales() async =>
      directions;
}

/// Fausse implémentation en mémoire de [ReservationRoomRepository].
class FakeReservationRoomRepository implements ReservationRoomRepository {
  /// Taille de page simulée (petite dans les tests de pagination).
  final int pageSize;
  List<ReservationRoom> reservations;
  int _nextId;

  FakeReservationRoomRepository({
    List<ReservationRoom>? initial,
    this.pageSize = 50,
  }) : reservations = initial ?? _defaultReservations(),
       _nextId = 3;

  static List<ReservationRoom> _defaultReservations() => [
    ReservationRoom(
      id: 1,
      roomId: 1,
      roomName: 'Salle Panafricaine',
      requesterName: 'Awa Ouédraogo',
      meetingSubject: 'Revue budgétaire',
      organizingStructure: 'DGB',
      date: '2026-09-10',
      startTime: '09:00:00',
      endTime: '11:00:00',
      status: 'en_attente',
    ),
    ReservationRoom(
      id: 2,
      roomId: 2,
      roomName: 'Salle Nazi Boni',
      requesterName: 'Awa Ouédraogo',
      meetingSubject: 'Comité de pilotage',
      organizingStructure: 'DGI',
      date: '2026-09-11',
      startTime: '14:00:00',
      endTime: '16:00:00',
      status: 'validee',
    ),
  ];

  @override
  Future<Paged<ReservationRoom>> getMyReservations({int offset = 0}) async =>
      Paged(
        reservations.skip(offset).take(pageSize).toList(),
        hasMore: reservations.length > offset + pageSize,
      );

  @override
  Future<Paged<ReservationRoom>> getAllReservations({int offset = 0}) async =>
      Paged(
        reservations.skip(offset).take(pageSize).toList(),
        hasMore: reservations.length > offset + pageSize,
      );

  @override
  Future<String?> createReservation({
    required int roomId,
    required String meetingSubject,
    required String organizingStructure,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    reservations = [
      ...reservations,
      ReservationRoom(
        id: _nextId++,
        roomId: roomId,
        meetingSubject: meetingSubject,
        organizingStructure: organizingStructure,
        date: date,
        startTime: startTime,
        endTime: endTime,
        status: 'en_attente',
      ),
    ];
    return null;
  }

  @override
  Future<bool> validateReservation(int id) async {
    reservations = reservations
        .map(
          (r) => r.id == id
              ? ReservationRoom(
                  id: r.id,
                  roomId: r.roomId,
                  roomName: r.roomName,
                  requesterName: r.requesterName,
                  meetingSubject: r.meetingSubject,
                  organizingStructure: r.organizingStructure,
                  date: r.date,
                  startTime: r.startTime,
                  endTime: r.endTime,
                  status: 'validee',
                )
              : r,
        )
        .toList();
    return true;
  }

  @override
  Future<bool> rejectReservation(int id, {String? reason}) async {
    reservations = reservations
        .map(
          (r) => r.id == id
              ? ReservationRoom(
                  id: r.id,
                  roomId: r.roomId,
                  roomName: r.roomName,
                  requesterName: r.requesterName,
                  meetingSubject: r.meetingSubject,
                  organizingStructure: r.organizingStructure,
                  date: r.date,
                  startTime: r.startTime,
                  endTime: r.endTime,
                  status: 'rejetee',
                  rejectionReason: reason,
                )
              : r,
        )
        .toList();
    return true;
  }
}

/// Fausse implémentation en mémoire de [AuthRepository], simulant une base
/// de comptes utilisateurs sans appel réseau réel.
class FakeAuthRepository implements AuthRepository {
  final List<Map<String, String>> _accounts;

  FakeAuthRepository({List<Map<String, String>>? seedAccounts})
    : _accounts =
          seedAccounts ??
          [
            {
              'nom': 'Ouédraogo',
              'prenom': 'Awa',
              'matricule': 'MAT001',
              'telephone': '+22670000000',
              'email': 'awa.ouedraogo@gsr.bf',
              'password': 'motdepasse123',
              'numeroFlotte': '+22670000001',
              'structureCode': 'DSI',
            },
          ];

  @override
  Future<AuthResult> register({
    required String nom,
    required String prenom,
    required String matricule,
    required String telephone,
    required String numeroFlotte,
    required String email,
    required String password,
    required String structureCode,
  }) async {
    final alreadyExists = _accounts.any(
      (a) => a['email'] == email || a['matricule'] == matricule,
    );
    if (alreadyExists) {
      return const AuthResult.failure(
        'Un compte existe déjà avec cet email ou ce matricule.',
      );
    }

    _accounts.add({
      'nom': nom,
      'prenom': prenom,
      'matricule': matricule,
      'telephone': telephone,
      'email': email,
      'password': password,
      'numeroFlotte': numeroFlotte,
      'structureCode': structureCode,
    });

    return const AuthResult.registered(
      'Compte créé. Vérifiez votre email pour activer votre compte, puis attendez la validation par un administrateur.',
    );
  }

  @override
  Future<User?> restoreSession(String token) async => null;

  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final account = _accounts.where((a) => a['email'] == email).toList();
    if (account.isEmpty || account.first['password'] != password) {
      return const AuthResult.failure('Email ou mot de passe incorrect.');
    }

    final a = account.first;
    return AuthResult.success(
      User(
        nom: a['nom']!,
        prenom: a['prenom']!,
        matricule: a['matricule']!,
        telephone: a['telephone']!,
        numeroFlotte: a['numeroFlotte'],
        email: a['email']!,
        structureCode: a['structureCode'],
        structureLibelle: a['structureCode'],
      ),
    );
  }
}

/// Fausse implémentation en mémoire de [UserManagementRepository].
class FakeUserManagementRepository implements UserManagementRepository {
  @override
  Future<List<User>> getPendingUsers() async => [];

  @override
  Future<bool> createUser({
    required String nom,
    required String prenom,
    required String matricule,
    required String telephone,
    required String numeroFlotte,
    required String email,
    required String password,
    required String structureCode,
    required String role,
  }) async => true;

  @override
  Future<bool> approveUser(String login) async => true;

  @override
  Future<bool> rejectUser(String login) async => true;
}

/// Fausse implémentation en mémoire de [NotificationRepository].
class FakeNotificationRepository implements NotificationRepository {
  @override
  Future<List<NotificationItem>> getNotifications() async => [];

  @override
  Future<bool> markAsRead(int id) async => true;
}

/// Fausse implémentation en mémoire de [MessageRepository].
class FakeMessageRepository implements MessageRepository {
  @override
  Future<List<Message>> getConversation({String? withLogin}) async => [];

  @override
  Future<bool> sendMessage({
    required String content,
    String? recipientLogin,
  }) async => true;

  @override
  Future<List<MessageThread>> getThreads() async => [];

  @override
  Future<List<MessageRecipient>> getRecipients() async => [];
}

/// Fausse implémentation en mémoire de [StatisticsRepository].
class FakeStatisticsRepository implements StatisticsRepository {
  @override
  Future<RoomStatistics> getRoomStatistics() async {
    return RoomStatistics(
      byStatus: const {},
      mostRequested: const [],
      byDirectionRegionale: const {},
    );
  }
}

/// Fournit l'ensemble des providers de l'application, câblés sur des dépôts
/// factices, pour tester la composition complète (navigation, rôles...)
/// sans dépendre d'un serveur réel. `home` est l'écran racine à afficher
/// (ex: AuthGate ou MainNavigationScreen directement).
Widget buildFakeApp({
  required Widget home,
  bool isAdmin = false,
  RoomRepository? roomRepository,
  UserManagementRepository? userManagementRepository,
  NotificationRepository? notificationRepository,
  MessageRepository? messageRepository,
}) {
  final roomRepo = roomRepository ?? FakeRoomRepository();
  final categoryRepo = FakeCategoryRoomRepository();
  final directionRepo = FakeDirectionRegionaleRepository();
  final structureRepo = FakeStructureRepository();
  final reservationRepo = FakeReservationRoomRepository();
  final authRepo = FakeAuthRepository();
  final userManagementRepo =
      userManagementRepository ?? FakeUserManagementRepository();
  final notificationRepo =
      notificationRepository ?? FakeNotificationRepository();
  final messageRepo = messageRepository ?? FakeMessageRepository();
  final statisticsRepo = FakeStatisticsRepository();

  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ChangeNotifierProvider(
        create: (_) {
          final provider = AuthProvider(
            loginUseCase: LoginUser(authRepo),
            registerUseCase: RegisterUser(authRepo),
          );
          if (isAdmin) {
            provider.debugSetUser(
              User(
                nom: 'Admin',
                prenom: 'Test',
                matricule: 'A1',
                telephone: '0000',
                email: 'admin@gsr.bf',
                structureCode: 'DSI',
                structureLibelle: 'DSI',
                role: 'admin',
              ),
            );
          }
          return provider;
        },
      ),
      ChangeNotifierProvider(
        create: (_) => RoomProvider(
          getRoomsUseCase: GetRooms(roomRepo),
          saveRoomUseCase: SaveRoom(roomRepo),
          deleteRoomUseCase: DeleteRoom(roomRepo),
          getAvailableRoomsUseCase: GetAvailableRooms(roomRepo),
        )..fetchRooms(),
      ),
      ChangeNotifierProvider(
        create: (_) => CategoryRoomProvider(
          getCategoryRoomsUseCase: GetCategoryRooms(categoryRepo),
          saveCategoryRoomUseCase: SaveCategoryRoom(categoryRepo),
          deleteCategoryRoomUseCase: DeleteCategoryRoom(categoryRepo),
        )..fetchRooms(),
      ),
      ChangeNotifierProvider(
        create: (_) => DirectionRegionaleProvider(
          getDirectionsRegionalesUseCase: GetDirectionsRegionales(
            directionRepo,
          ),
        )..fetchDirections(),
      ),
      ChangeNotifierProvider(
        create: (_) => StructureProvider(
          getStructuresUseCase: GetStructures(structureRepo),
          saveStructureUseCase: SaveStructure(structureRepo),
          deleteStructureUseCase: DeleteStructure(structureRepo),
        )..fetchStructures(),
      ),
      ChangeNotifierProvider(
        create: (_) => ReservationRoomProvider(
          getMyReservationsUseCase: GetMyReservations(reservationRepo),
          getAllReservationsUseCase: GetAllReservations(reservationRepo),
          createReservationUseCase: CreateReservation(reservationRepo),
          validateReservationUseCase: ValidateReservation(reservationRepo),
          rejectReservationUseCase: RejectReservation(reservationRepo),
        ),
      ),
      ChangeNotifierProvider(
        create: (_) => UserManagementProvider(
          getPendingUsersUseCase: GetPendingUsers(userManagementRepo),
          createUserUseCase: CreateUser(userManagementRepo),
          approveUserUseCase: ApproveUser(userManagementRepo),
          rejectUserUseCase: RejectUser(userManagementRepo),
        ),
      ),
      ChangeNotifierProvider(
        create: (_) => NotificationProvider(
          getNotificationsUseCase: GetNotifications(notificationRepo),
          markAsReadUseCase: MarkNotificationAsRead(notificationRepo),
        ),
      ),
      ChangeNotifierProvider(
        create: (_) => MessageProvider(
          getConversationUseCase: GetConversation(messageRepo),
          sendMessageUseCase: SendMessage(messageRepo),
          getThreadsUseCase: GetThreads(messageRepo),
          getRecipientsUseCase: GetRecipients(messageRepo),
        ),
      ),
      ChangeNotifierProvider(
        create: (_) => StatisticsProvider(
          getRoomStatisticsUseCase: GetRoomStatistics(statisticsRepo),
        ),
      ),
    ],
    child: home,
  );
}

/// [MaterialApp] en français avec les traductions de l'application, pour
/// tester un écran isolé.
Widget frApp(Widget home) => MaterialApp(
  locale: const Locale('fr'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: home,
);

/// Dépôt de salles dont le chargement peut échouer à la demande.
class FlakyRoomRepository extends FakeRoomRepository {
  bool failing = true;

  @override
  Future<List<Room>> getRooms() async {
    if (failing) throw const ApiException('Serveur injoignable');
    return super.getRooms();
  }
}

/// Dépôt de comptes qui mémorise les identifiants validés / rejetés.
class RecordingUserRepository extends FakeUserManagementRepository {
  final approved = <String>[];
  final rejected = <String>[];
  List<User> pending;

  RecordingUserRepository({List<User>? pending})
    : pending =
          pending ??
          [
            User(
              login: '217071K',
              nom: 'OUEDRAOGO',
              prenom: 'Awa',
              matricule: '',
              telephone: '',
              email: 'awa@dgi.bf',
            ),
          ];

  @override
  Future<List<User>> getPendingUsers() async => pending;

  @override
  Future<bool> approveUser(String login) async {
    approved.add(login);
    pending = pending.where((u) => u.login != login).toList();
    return true;
  }

  @override
  Future<bool> rejectUser(String login) async {
    rejected.add(login);
    pending = pending.where((u) => u.login != login).toList();
    return true;
  }
}
