import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bloc/providers/room_provider.dart';
import '../../domain/entities/room.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gestion des Salles de Réunion'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Toutes'),
              Tab(text: 'Disponibles'),
              Tab(text: 'Réservées'),
              Tab(text: 'Réfection'),
              Tab(text: 'Dégradées'),
              Tab(text: 'Construction'),
            ],
          ),
        ),
        body: Consumer<RoomProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return TabBarView(
              children: [
                _buildRoomList(provider.rooms),
                _buildRoomList(provider.getRoomsByStatus('disponible')),
                _buildRoomList(provider.getRoomsByStatus('reservé')),
                _buildRoomList(provider.getRoomsByStatus('en refection')),
                _buildRoomList(provider.getRoomsByStatus('dégradé')),
                _buildRoomList(provider.getRoomsByStatus('en construction')),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRoomList(List<Room> rooms) {
    if (rooms.isEmpty) {
      return const Center(child: Text('Aucune salle enregistrée.'));
    }
    return ListView.builder(
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];
        return ListTile(
          leading: Semantics(
            label: 'Icône salle ${room.name}',
            child: const Icon(Icons.room),
          ),
          title: Text(room.name),
          subtitle: Text('${room.city} - ${room.status} (${room.category})'),
          trailing: Text(
            room.category == 'location'
                ? '${room.rentalAmount} FCFA'
                : 'Gratuit',
          ),
        );
      },
    );
  }
}
