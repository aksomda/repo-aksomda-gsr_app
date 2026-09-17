import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../providers/reservation_room_provider.dart';
import '../../domain/entities/reservation_room.dart';

class ReservationRoomsScreen extends HookWidget {
  const ReservationRoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 3);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Demandes de Réservation'),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(
              text: 'En Cours',
              icon: Icon(
                Icons.hourglass_empty,
                semanticLabel: 'Icône en cours',
              ),
            ),
            Tab(
              text: 'Traitées',
              icon: Icon(Icons.check_circle, semanticLabel: 'Icône traitées'),
            ),
            Tab(
              text: 'Rejetées',
              icon: Icon(Icons.cancel, semanticLabel: 'Icône rejetées'),
            ),
          ],
        ),
      ),
      body: Consumer<ReservationRoomProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return TabBarView(
            controller: tabController,
            children: [
              _buildList(provider.getByState('en cours')),
              _buildList(provider.getByState('traitée')),
              _buildList(provider.getByState('rejetée')),
            ],
          );
        },
      ),
    );
  }

  Widget _buildList(List<ReservationRoom> items) {
    if (items.isEmpty) {
      return const Center(child: Text('Aucune réservation trouvée.'));
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: Semantics(
              label: 'Statut de la réservation : ${item.status}',
              child: const Icon(Icons.meeting_room),
            ),
            title: Text(
              item.meetingSubject,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Structure : ${item.organizingStructure}\nDate : ${item.date} (${item.startTime} - ${item.endTime})',
            ),
            trailing: Chip(
              label: Text(item.state),
              backgroundColor: item.state == 'traitée'
                  ? Colors.green[100]
                  : Colors.orange[100],
            ),
          ),
        );
      },
    );
  }
}
