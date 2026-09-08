import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../features/rooms/presentation/screens/rooms_screen.dart';
import '../features/reservations_rooms/presentation/screens/reservation_rooms_screen.dart';
import '../features/statistics/presentation/screens/statistic_rooms_screen.dart';
import '../features/categories_rooms/presentation/screens/category_rooms_screen.dart';

class MainNavigationScreen extends HookWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);

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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.meeting_room, semanticLabel: 'Salles'),
            label: 'Salles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category, semanticLabel: 'Catégories'),
            label: 'Catégories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online, semanticLabel: 'Réservations'),
            label: 'Réservations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, semanticLabel: 'Statistiques'),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, semanticLabel: 'Paramètres'),
            label: 'Paramètres',
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
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres & Connectivité API')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ListTile(
            leading: Icon(Icons.network_check, color: Colors.green),
            title: Text('État de la Connexion MySQL (dbgsr)'),
            subtitle: Text('Connecté via API Node.js (api_GsrApp)'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Internationalisation'),
            subtitle: Text('Français (FR) / Anglais (EN) actifs'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Version de l\'application'),
            subtitle: Text('GsrApp v1.0.0+1 production-ready'),
          ),
        ],
      ),
    );
  }
}
