import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/direction_regionale_provider.dart';
import '../../../../l10n/l10n_extensions.dart';
import '../../../../core/widgets/error_retry.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/drawer_menu_button.dart';

/// Liste en lecture seule : `ref_structure` appartient à un autre système.
class DirectionRegionaleScreen extends StatelessWidget {
  const DirectionRegionaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.regionalDirections),
        actions: const [DrawerMenuButton()],
      ),
      drawer: const AppDrawer(),
      body: Consumer<DirectionRegionaleProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null && provider.directions.isEmpty) {
            return ErrorRetry(
              message: provider.error!,
              onRetry: provider.fetchDirections,
            );
          }
          if (provider.directions.isEmpty) {
            return Center(child: Text(context.l10n.noRegionalDirections));
          }
          return ListView.builder(
            itemCount: provider.directions.length,
            itemBuilder: (context, index) {
              final direction = provider.directions[index];
              return ListTile(
                leading: const Icon(Icons.account_tree_outlined),
                title: Text(direction.nom),
                subtitle: Text(direction.id ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}
