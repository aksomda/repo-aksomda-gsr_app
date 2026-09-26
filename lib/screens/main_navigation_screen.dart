import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/widgets/app_drawer.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/rooms/presentation/bloc/providers/room_provider.dart';
import '../features/categories_rooms/presentation/bloc/providers/category_room_provider.dart';
import '../features/directions_regionales/presentation/providers/direction_regionale_provider.dart';
import '../features/notifications/presentation/providers/notification_provider.dart';
import '../features/notifications/presentation/screens/notifications_screen.dart';
import '../features/chat/presentation/screens/messages_screen.dart';
import '../features/chat/presentation/screens/admin_message_threads_screen.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../l10n/l10n_extensions.dart';

/// Écran racine de l'application : affiche le tableau de bord et héberge le
/// tiroir de navigation. Les autres destinations sont poussées via
/// [Navigator.push] (voir [AppDrawer]) afin que chaque écran dispose d'un
/// bouton retour natif.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  NotificationProvider? _notificationProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _notificationProvider = context.read<NotificationProvider>();
      _notificationProvider!.fetchNotifications();
      _notificationProvider!.startPolling();

      // Ces listes sont chargées au démarrage de l'app, avant la connexion :
      // vides tant que l'utilisateur n'était pas authentifié.
      context.read<RoomProvider>().fetchRooms();
      context.read<CategoryRoomProvider>().fetchRooms();
      context.read<DirectionRegionaleProvider>().fetchDirections();
    });
  }

  @override
  void dispose() {
    _notificationProvider?.stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().currentUser?.isAdmin ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.home),
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, notifications, child) {
              return IconButton(
                tooltip: context.l10n.notifications,
                icon: Badge(
                  label: Text('${notifications.unreadCount}'),
                  isLabelVisible: notifications.unreadCount > 0,
                  child: const Icon(Icons.notifications_outlined),
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                ),
              );
            },
          ),
          IconButton(
            tooltip: context.l10n.messaging,
            icon: const Icon(Icons.message_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => isAdmin
                    ? const AdminMessageThreadsScreen()
                    : const MessagesScreen(),
              ),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: const DashboardScreen(),
    );
  }
}
