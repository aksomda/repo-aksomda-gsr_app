import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/config/api_config.dart';
import 'core/firebase/firebase_bootstrap.dart';
import 'core/network/session.dart';
import 'core/settings/settings_provider.dart';
import 'l10n/l10n_extensions.dart';

import 'features/rooms/data/datasources/room_remote_data_source.dart';
import 'features/rooms/data/repositories/room_repository_impl.dart';
import 'features/rooms/domain/usecases/delete_room.dart';
import 'features/rooms/domain/usecases/get_available_rooms.dart';
import 'features/rooms/domain/usecases/get_rooms.dart';
import 'features/rooms/domain/usecases/save_room.dart';
import 'features/rooms/presentation/bloc/providers/room_provider.dart';

import 'features/categories_rooms/data/datasources/category_room_remote_data_source.dart';
import 'features/categories_rooms/data/repositories/category_room_repository_impl.dart';
import 'features/categories_rooms/domain/usecases/delete_category_room.dart';
import 'features/categories_rooms/domain/usecases/get_category_rooms.dart';
import 'features/categories_rooms/domain/usecases/save_category_room.dart';
import 'features/categories_rooms/presentation/bloc/providers/category_room_provider.dart';

import 'features/directions_regionales/data/datasources/direction_regionale_remote_data_source.dart';
import 'features/directions_regionales/data/repositories/direction_regionale_repository_impl.dart';
import 'features/directions_regionales/domain/usecases/get_directions_regionales.dart';
import 'features/directions_regionales/presentation/providers/direction_regionale_provider.dart';

import 'features/ref_structure/data/datasources/structure_remote_data_source.dart';
import 'features/ref_structure/data/repositories/structure_repository_impl.dart';
import 'features/ref_structure/domain/usecases/delete_structure.dart';
import 'features/ref_structure/domain/usecases/get_structures.dart';
import 'features/ref_structure/domain/usecases/save_structure.dart';
import 'features/ref_structure/presentation/providers/structure_provider.dart';

import 'features/reservations_rooms/data/datasources/reservation_room_remote_data_source.dart';
import 'features/reservations_rooms/data/repositories/reservation_room_repository_impl.dart';
import 'features/reservations_rooms/domain/usecases/create_reservation.dart';
import 'features/reservations_rooms/domain/usecases/get_all_reservations.dart';
import 'features/reservations_rooms/domain/usecases/get_my_reservations.dart';
import 'features/reservations_rooms/domain/usecases/reject_reservation.dart';
import 'features/reservations_rooms/domain/usecases/validate_reservation.dart';
import 'features/reservations_rooms/presentation/providers/reservation_room_provider.dart';

import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/domain/usecases/register_user.dart';
import 'features/auth/domain/usecases/restore_session.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';

import 'features/user_management/data/datasources/user_management_remote_data_source.dart';
import 'features/user_management/data/repositories/user_management_repository_impl.dart';
import 'features/user_management/domain/usecases/approve_user.dart';
import 'features/user_management/domain/usecases/create_user.dart';
import 'features/user_management/domain/usecases/get_pending_users.dart';
import 'features/user_management/domain/usecases/reject_user.dart';
import 'features/user_management/presentation/providers/user_management_provider.dart';

import 'features/notifications/data/datasources/notification_remote_datasource.dart';
import 'features/notifications/data/repositories/notification_repository_impl.dart';
import 'features/notifications/domain/usecases/get_notifications.dart';
import 'features/notifications/domain/usecases/mark_notification_as_read.dart';
import 'features/notifications/presentation/providers/notification_provider.dart';

import 'features/chat/data/datasources/message_remote_datasource.dart';
import 'features/chat/data/repositories/message_repository_impl.dart';
import 'features/chat/domain/usecases/get_conversation.dart';
import 'features/chat/domain/usecases/get_recipients.dart';
import 'features/chat/domain/usecases/get_threads.dart';
import 'features/chat/domain/usecases/send_message.dart';
import 'features/chat/presentation/providers/message_provider.dart';

import 'features/statistics/data/datasources/statistics_remote_datasource.dart';
import 'features/statistics/data/repositories/statistics_repository_impl.dart';
import 'features/statistics/domain/usecases/get_room_statistics.dart';
import 'features/statistics/presentation/providers/statistics_provider.dart';

import 'l10n/app_localizations.dart';
import 'screens/main_navigation_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Un build release configuré comme en développement ne doit pas démarrer.
  final configError = ApiConfig.releaseConfigError();
  if (configError != null) {
    runApp(_ConfigErrorApp(message: configError));
    return;
  }

  // Optionnel : voir FIREBASE_SETUP.md. Sans configuration, l'app continue
  // normalement (MySQL reste la seule source de vérité) — seules la
  // synchronisation Firebase Auth et les notifications push restent inactives.
  await FirebaseBootstrap.init();

  await Session.restore();
  final settings = await SettingsProvider.load();

  final roomRepository = RoomRepositoryImpl(RoomRemoteDataSource());
  final categoryRepository = CategoryRoomRepositoryImpl(
    CategoryRoomRemoteDataSource(),
  );
  final directionRepository = DirectionRegionaleRepositoryImpl(
    DirectionRegionaleRemoteDataSource(),
  );
  final structureRepository = StructureRepositoryImpl(
    StructureRemoteDataSource(),
  );
  final reservationRepository = ReservationRoomRepositoryImpl(
    ReservationRoomRemoteDataSource(),
  );
  final authRepository = AuthRepositoryImpl(AuthRemoteDataSource());
  final userManagementRepository = UserManagementRepositoryImpl(
    UserManagementRemoteDataSource(),
  );
  final notificationRepository = NotificationRepositoryImpl(
    NotificationRemoteDataSource(),
  );
  final messageRepository = MessageRepositoryImpl(MessageRemoteDataSource());
  final statisticsRepository = StatisticsRepositoryImpl(
    StatisticsRemoteDataSource(),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settings),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUseCase: LoginUser(authRepository),
            registerUseCase: RegisterUser(authRepository),
            restoreSessionUseCase: RestoreSession(authRepository),
          )..tryRestoreSession(),
        ),
        ChangeNotifierProvider(
          create: (_) => RoomProvider(
            getRoomsUseCase: GetRooms(roomRepository),
            saveRoomUseCase: SaveRoom(roomRepository),
            deleteRoomUseCase: DeleteRoom(roomRepository),
            getAvailableRoomsUseCase: GetAvailableRooms(roomRepository),
          )..fetchRooms(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryRoomProvider(
            getCategoryRoomsUseCase: GetCategoryRooms(categoryRepository),
            saveCategoryRoomUseCase: SaveCategoryRoom(categoryRepository),
            deleteCategoryRoomUseCase: DeleteCategoryRoom(categoryRepository),
          )..fetchRooms(),
        ),
        ChangeNotifierProvider(
          create: (_) => DirectionRegionaleProvider(
            getDirectionsRegionalesUseCase: GetDirectionsRegionales(
              directionRepository,
            ),
          )..fetchDirections(),
        ),
        ChangeNotifierProvider(
          create: (_) => StructureProvider(
            getStructuresUseCase: GetStructures(structureRepository),
            saveStructureUseCase: SaveStructure(structureRepository),
            deleteStructureUseCase: DeleteStructure(structureRepository),
          )..fetchStructures(),
        ),
        ChangeNotifierProvider(
          create: (_) => ReservationRoomProvider(
            getMyReservationsUseCase: GetMyReservations(reservationRepository),
            getAllReservationsUseCase: GetAllReservations(
              reservationRepository,
            ),
            createReservationUseCase: CreateReservation(reservationRepository),
            validateReservationUseCase: ValidateReservation(
              reservationRepository,
            ),
            rejectReservationUseCase: RejectReservation(reservationRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => UserManagementProvider(
            getPendingUsersUseCase: GetPendingUsers(userManagementRepository),
            createUserUseCase: CreateUser(userManagementRepository),
            approveUserUseCase: ApproveUser(userManagementRepository),
            rejectUserUseCase: RejectUser(userManagementRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(
            getNotificationsUseCase: GetNotifications(notificationRepository),
            markAsReadUseCase: MarkNotificationAsRead(notificationRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => MessageProvider(
            getConversationUseCase: GetConversation(messageRepository),
            sendMessageUseCase: SendMessage(messageRepository),
            getThreadsUseCase: GetThreads(messageRepository),
            getRecipientsUseCase: GetRecipients(messageRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => StatisticsProvider(
            getRoomStatisticsUseCase: GetRoomStatistics(statisticsRepository),
          ),
        ),
      ],
      child: const GsrApp(),
    ),
  );
}

class GsrApp extends StatelessWidget {
  const GsrApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return MaterialApp(
      title: 'GsrApp',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: settings.themeMode,
      locale: settings.locale,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // Garde à jour la langue pour le code sans BuildContext (AppLocale).
      builder: (context, child) {
        AppLocale.current = Localizations.localeOf(context);
        return child ?? const SizedBox.shrink();
      },
      home: const AuthGate(),
    );
  }
}

/// Affiche l'écran de connexion tant que l'utilisateur n'est pas
/// authentifié, puis bascule sur la navigation principale une fois connecté.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.isRestoring) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return auth.isAuthenticated
        ? const MainNavigationScreen()
        : const LoginScreen();
  }
}

/// Écran de secours affiché quand la configuration de production est invalide.
class _ConfigErrorApp extends StatelessWidget {
  final String message;

  const _ConfigErrorApp({required this.message});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(message, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
