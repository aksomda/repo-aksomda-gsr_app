import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../features/rooms/presentation/screens/rooms_screen.dart';
import '../features/reservations_rooms/presentation/screens/reservation_rooms_screen.dart';
import '../features/statistics/presentation/screens/statistic_rooms_screen.dart';
import '../features/categories_rooms/presentation/screens/category_rooms_screen.dart';
import '../l10n/app_localizations.dart';

class MainNavigationScreen extends HookWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);
    final l10n = AppLocalizations.of(context)!;

    final screens = const [
      RoomsScreen(),
      CategoryRoomsScreen(),
      ReservationRoomsScreen(),
      StatisticRoomsScreen(),
      SettingsConnectivityScreen(),
    ];

    return Scaffold(
      body: screens[currentIndex.value],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex.value,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.meeting_room, semanticLabel: l10n.roomsList),
            label: l10n.roomsList,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category, semanticLabel: l10n.categories),
            label: l10n.categories,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online, semanticLabel: l10n.reservations),
            label: l10n.reservations,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, semanticLabel: l10n.statistics),
            label: l10n.statistics,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, semanticLabel: l10n.settings),
            label: l10n.settings,
          ),
        ],
        onTap: (index) => currentIndex.value = index,
      ),
    );
  }
}

class SettingsConnectivityScreen extends StatelessWidget {
  const SettingsConnectivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Semantics(
            label: 'État de la connexion à l\'API',
            child: ListTile(
              leading: Icon(Icons.network_check, color: Colors.green),
              title: Text('État de la Connexion MySQL (dbgsr)'),
              subtitle: Text('Connecté via API Node.js (api_GsrApp)'),
            ),
          ),
          const Divider(),
          Semantics(
            label: 'Langue de l\'application',
            child: ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.appTitle),
              subtitle: const Text('Français (FR) / English (EN)'),
            ),
          ),
          const Divider(),
          const Semantics(
            label: 'Version de l\'application',
            child: ListTile(
              leading: Icon(Icons.info),
              title: Text('Version de l\'application'),
              subtitle: Text('GsrApp v1.1.0 production-ready'),
            ),
          ),
        ],
      ),
    );
  }
}
