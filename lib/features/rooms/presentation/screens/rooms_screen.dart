import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/gsr_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../categories_rooms/presentation/bloc/providers/category_room_provider.dart';
import '../../../categories_rooms/domain/entities/category_room.dart';
import '../../../directions_regionales/presentation/providers/direction_regionale_provider.dart';
import '../bloc/providers/room_provider.dart';
import '../../domain/entities/room.dart';
import '../widgets/room_form_dialog.dart';
import '../../../../l10n/l10n_extensions.dart';
import '../../../../core/widgets/error_retry.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/drawer_menu_button.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  Future<void> _openForm(
    BuildContext context,
    RoomProvider provider, {
    Room? initial,
  }) async {
    final categoryProvider = context.read<CategoryRoomProvider>();
    final directionProvider = context.read<DirectionRegionaleProvider>();

    // Ces listes sont chargées au démarrage, avant la connexion : vides tant
    // que l'utilisateur n'était pas authentifié. On les recharge à l'ouverture.
    await Future.wait([
      categoryProvider.fetchRooms(),
      directionProvider.fetchDirections(),
    ]);
    if (!context.mounted) return;

    final categories = categoryProvider.categoryRoom;
    final directions = directionProvider.directions;

    final result = await showRoomFormDialog(
      context,
      initial: initial,
      categories: categories,
      directions: directions,
    );
    if (result == null) return;
    final success = await provider.addOrUpdateRoom(result);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? context.l10n.roomSaved : context.l10n.saveFailed,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    RoomProvider provider,
    Room room,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.l10n.deleteRoom),
        content: Text(context.l10n.confirmDeleteNamed(room.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true && room.id != null) {
      await provider.deleteRoom(room.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().currentUser?.isAdmin ?? false;

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.roomsManagementTitle),
          actions: const [DrawerMenuButton()],
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: context.l10n.all),
              Tab(text: context.l10n.tabAvailable),
              Tab(text: context.l10n.tabReserved),
              Tab(text: context.l10n.tabRefection),
              Tab(text: context.l10n.tabDegraded),
              Tab(text: context.l10n.tabConstruction),
            ],
          ),
        ),
        drawer: const AppDrawer(),
        body: Consumer<RoomProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.error != null && provider.rooms.isEmpty) {
              return ErrorRetry(
                message: provider.error!,
                onRetry: provider.fetchRooms,
              );
            }
            return TabBarView(
              children: [
                _buildRoomList(context, provider, provider.rooms, isAdmin),
                _buildRoomList(
                  context,
                  provider,
                  provider.getRoomsByStatus('disponible'),
                  isAdmin,
                ),
                _buildRoomList(
                  context,
                  provider,
                  provider.getRoomsByStatus('reservé'),
                  isAdmin,
                ),
                _buildRoomList(
                  context,
                  provider,
                  provider.getRoomsByStatus('en refection'),
                  isAdmin,
                ),
                _buildRoomList(
                  context,
                  provider,
                  provider.getRoomsByStatus('dégradé'),
                  isAdmin,
                ),
                _buildRoomList(
                  context,
                  provider,
                  provider.getRoomsByStatus('en construction'),
                  isAdmin,
                ),
              ],
            );
          },
        ),
        floatingActionButton: isAdmin
            ? Builder(
                builder: (context) => FloatingActionButton(
                  backgroundColor: GsrColors.primary,
                  onPressed: () =>
                      _openForm(context, context.read<RoomProvider>()),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildRoomList(
    BuildContext context,
    RoomProvider provider,
    List<Room> rooms,
    bool isAdmin,
  ) {
    if (rooms.isEmpty) {
      return Center(child: Text(context.l10n.noRooms));
    }
    return Consumer<CategoryRoomProvider>(
      builder: (context, categoryProvider, child) {
        return ListView.builder(
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            final room = rooms[index];
            final category = categoryProvider.categoryRoom
                .cast<CategoryRoom?>()
                .firstWhere(
                  (c) => c?.id == room.categoryId,
                  orElse: () => null,
                );
            return ListTile(
              leading: Semantics(
                label: context.l10n.roomIcon(room.name),
                child: const Icon(Icons.room),
              ),
              title: Text(room.name),
              subtitle: Text(
                context.l10n.roomSubtitle(
                  room.city,
                  context.l10n.roomStatusName(room.status),
                  category?.libelleCat ?? context.l10n.noCategory,
                ),
              ),
              trailing: isAdmin
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          tooltip: context.l10n.edit,
                          onPressed: () =>
                              _openForm(context, provider, initial: room),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          tooltip: context.l10n.delete,
                          onPressed: () =>
                              _confirmDelete(context, provider, room),
                        ),
                      ],
                    )
                  : Text(
                      category != null && !category.isGratuite
                          ? context.l10n.amountFcfa(
                              category.montantLocation.toStringAsFixed(0),
                            )
                          : context.l10n.free,
                    ),
            );
          },
        );
      },
    );
  }
}
