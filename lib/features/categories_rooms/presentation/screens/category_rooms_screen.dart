import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/gsr_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../bloc/providers/category_room_provider.dart';
import '../../domain/entities/category_room.dart';
import '../widgets/category_room_form_dialog.dart';
import '../../../../l10n/l10n_extensions.dart';
import '../../../../core/widgets/error_retry.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/drawer_menu_button.dart';

class CategoryRoomsScreen extends StatelessWidget {
  const CategoryRoomsScreen({super.key});

  Future<void> _openForm(
    BuildContext context,
    CategoryRoomProvider provider, {
    CategoryRoom? initial,
  }) async {
    final result = await showCategoryRoomFormDialog(context, initial: initial);
    if (result == null) return;
    final success = await provider.addOrUpdateCategoryRoom(result);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? context.l10n.categorySaved : context.l10n.saveFailed,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    CategoryRoomProvider provider,
    CategoryRoom category,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.l10n.deleteCategory),
        content: Text(context.l10n.confirmDeleteNamed(category.libelleCat)),
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
    if (confirmed == true && category.id != null) {
      await provider.deleteCategoryRoom(category.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().currentUser?.isAdmin ?? false;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.categoriesManagementTitle),
          actions: const [DrawerMenuButton()],
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: context.l10n.all),
              Tab(text: context.l10n.tabFree),
              Tab(text: context.l10n.tabRental),
            ],
          ),
        ),
        drawer: const AppDrawer(),
        body: Consumer<CategoryRoomProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.error != null && provider.categoryRoom.isEmpty) {
              return ErrorRetry(
                message: provider.error!,
                onRetry: provider.fetchRooms,
              );
            }
            return TabBarView(
              children: [
                _buildCategoryRoomList(
                  context,
                  provider,
                  provider.categoryRoom,
                  isAdmin,
                ),
                _buildCategoryRoomList(
                  context,
                  provider,
                  provider.getCategoryRoomsByType('gratuite'),
                  isAdmin,
                ),
                _buildCategoryRoomList(
                  context,
                  provider,
                  provider.getCategoryRoomsByType('location'),
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
                      _openForm(context, context.read<CategoryRoomProvider>()),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildCategoryRoomList(
    BuildContext context,
    CategoryRoomProvider provider,
    List<CategoryRoom> categoryRooms,
    bool isAdmin,
  ) {
    if (categoryRooms.isEmpty) {
      return Center(child: Text(context.l10n.noCategories));
    }
    return ListView.builder(
      itemCount: categoryRooms.length,
      itemBuilder: (context, index) {
        final categoryRoom = categoryRooms[index];
        return ListTile(
          leading: Semantics(
            label: context.l10n.categoryIcon(categoryRoom.libelleCat),
            child: const Icon(Icons.category),
          ),
          title: Text(categoryRoom.libelleCat),
          subtitle: Text(
            (categoryRoom.isGratuite
                    ? context.l10n.categoryFree
                    : context.l10n.categoryRentalAmount(
                        categoryRoom.montantLocation.toStringAsFixed(0),
                      )) +
                (categoryRoom.actif == 1 ? '' : context.l10n.inactiveSuffix),
          ),
          trailing: isAdmin
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: context.l10n.edit,
                      onPressed: () =>
                          _openForm(context, provider, initial: categoryRoom),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      tooltip: context.l10n.delete,
                      onPressed: () =>
                          _confirmDelete(context, provider, categoryRoom),
                    ),
                  ],
                )
              : null,
        );
      },
    );
  }
}
