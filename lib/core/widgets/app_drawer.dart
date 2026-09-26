import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/gsr_colors.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/rooms/presentation/screens/rooms_screen.dart';
import '../../features/categories_rooms/presentation/screens/category_rooms_screen.dart';
import '../../features/reservations_rooms/presentation/screens/reservation_rooms_screen.dart';
import '../../features/statistics/presentation/screens/statistic_rooms_screen.dart';
import '../../features/directions_regionales/presentation/screens/direction_regionale_screen.dart';
import '../../features/ref_structure/presentation/screens/structure_screen.dart';
import '../../features/user_management/presentation/screens/user_management_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../l10n/l10n_extensions.dart';
import '../../screens/settings_screen.dart';

/// Une destination accessible depuis le tiroir de navigation.
class AppDrawerDestination {
  final String label;
  final IconData icon;
  final WidgetBuilder builder;
  final bool isHome;

  const AppDrawerDestination({
    required this.label,
    required this.icon,
    required this.builder,
    this.isHome = false,
  });
}

/// Liste des destinations du tiroir, identique pour l'écran racine et pour
/// le tiroir partagé affiché sur les écrans poussés.
List<AppDrawerDestination> buildAppDrawerDestinations(
  BuildContext context, {
  required bool isAdmin,
}) {
  return [
    AppDrawerDestination(
      label: context.l10n.home,
      icon: Icons.home_outlined,
      isHome: true,
      builder: (_) => const DashboardScreen(),
    ),
    AppDrawerDestination(
      label: context.l10n.roomsList,
      icon: Icons.meeting_room,
      builder: (_) => const RoomsScreen(),
    ),
    AppDrawerDestination(
      label: context.l10n.categories,
      icon: Icons.category,
      builder: (_) => const CategoryRoomsScreen(),
    ),
    AppDrawerDestination(
      label: context.l10n.reservations,
      icon: Icons.book_online,
      builder: (_) => const ReservationRoomsScreen(),
    ),
    AppDrawerDestination(
      label: context.l10n.statistics,
      icon: Icons.bar_chart,
      builder: (_) => const StatisticRoomsScreen(),
    ),
    if (isAdmin)
      AppDrawerDestination(
        label: context.l10n.userAccounts,
        icon: Icons.people_outline,
        builder: (_) => const UserManagementScreen(),
      ),
    if (isAdmin)
      AppDrawerDestination(
        label: context.l10n.regionalDirections,
        icon: Icons.account_tree_outlined,
        builder: (_) => const DirectionRegionaleScreen(),
      ),
    if (isAdmin)
      AppDrawerDestination(
        label: context.l10n.structures,
        icon: Icons.apartment_outlined,
        builder: (_) => const StructureScreen(),
      ),
    AppDrawerDestination(
      label: context.l10n.settings,
      icon: Icons.settings,
      builder: (_) => const SettingsConnectivityScreen(),
    ),
  ];
}

/// Tiroir de navigation partagé : affiché sur l'écran racine (tableau de
/// bord) et réutilisé sur chaque écran poussé, pour que le menu reste
/// accessible partout en plus du bouton retour natif.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final navigator = Navigator.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.logout),
        content: Text(context.l10n.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(context.l10n.logout),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    navigator.pop(); // ferme le tiroir
    await auth.logout();
  }

  void _navigateTo(BuildContext context, AppDrawerDestination destination) {
    final navigator = Navigator.of(context);
    navigator.pop(); // ferme le tiroir
    navigator.popUntil((route) => route.isFirst);
    if (!destination.isHome) {
      navigator.push(MaterialPageRoute(builder: destination.builder));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().currentUser?.isAdmin ?? false;
    final destinations = buildAppDrawerDestinations(context, isAdmin: isAdmin);

    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: GsrColors.primary),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'GsrApp',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ...destinations.map(
              (destination) => ListTile(
                leading: Icon(
                  destination.icon,
                  semanticLabel: destination.label,
                ),
                title: Text(destination.label),
                onTap: () => _navigateTo(context, destination),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(
                context.l10n.logout,
                style: TextStyle(color: Colors.red),
              ),
              onTap: () => _confirmLogout(context),
            ),
          ],
        ),
      ),
    );
  }
}
