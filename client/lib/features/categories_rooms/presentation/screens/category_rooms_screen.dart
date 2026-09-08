import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repo_aksomda_gsr_app/features/categories_rooms/domain/entities/category_room.dart';
import '../../domain/entities/category_room.dart' as Icons;
import '../bloc/providers/category_room_provider.dart';
import '../../domain/entities/category_room.dart';

class CategoryRoomsScreen extends StatelessWidget {
  const CategoryRoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gestion des catégories de salles de réunion'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Toutes'),
              Tab(text: 'GRATUIT'),
              Tab(text: 'LOCATION'),
            ],
          ),
        ),
        body: Consumer<CategoryRoomProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return TabBarView(
              children: [
                _buildCategoryRoomList(provider.categoryRoom),
                _buildCategoryRoomList(
                  provider.getCategoryRoomsByLibelleCat('GRATUIT'),
                ),
                _buildCategoryRoomList(
                  provider.getCategoryRoomsByLibelleCat('LOCATION'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryRoomList(List<CategoryRoom> categoryRooms) {
    if (categoryRooms.isEmpty) {
      return const Center(
        child: Text('Aucune catégorie de salle de réunion enregistrée.'),
      );
    }
    return ListView.builder(
      itemCount: categoryRooms.length,
      itemBuilder: (context, index) {
        final categoryRoom = categoryRooms[index];
        return ListTile(
          leading: Semantics(
            label: 'Icône salle ${categoryRoom.libelleCat}',
            child: const Icon(Icons.categoryRoom),
          ),
          title: Text(categoryRoom.libelleCat),
          subtitle: Text(
            '${categoryRoom.libelleCat} - ${categoryRoom.montantLocation} (${categoryRoom.actif})',
          ),
        );
      },
    );
  }
}
