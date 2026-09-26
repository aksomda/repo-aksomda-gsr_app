import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/gsr_colors.dart';
import '../../domain/entities/structure.dart';
import '../providers/structure_provider.dart';
import '../../../../l10n/l10n_extensions.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/drawer_menu_button.dart';

class StructureScreen extends StatelessWidget {
  const StructureScreen({super.key});

  Future<void> _openForm(
    BuildContext context,
    StructureProvider provider, {
    Structure? initial,
  }) async {
    final codeController = TextEditingController(text: initial?.codeCdi ?? '');
    final libelleController = TextEditingController(
      text: initial?.libelleLongCdi ?? '',
    );
    final formKey = GlobalKey<FormState>();
    final isEditing = initial != null;

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          isEditing ? context.l10n.editStructure : context.l10n.newStructure,
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: codeController,
                enabled: !isEditing,
                decoration: InputDecoration(labelText: context.l10n.codeCdi),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? context.l10n.codeRequired
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: libelleController,
                decoration: InputDecoration(labelText: context.l10n.label),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? context.l10n.labelRequired
                    : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: GsrColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(context).pop(true);
              }
            },
            child: Text(context.l10n.save),
          ),
        ],
      ),
    );

    if (result == true) {
      await provider.addOrUpdateStructure(
        Structure(
          codeCdi: codeController.text.trim(),
          libelleLongCdi: libelleController.text.trim(),
        ),
      );
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    StructureProvider provider,
    Structure structure,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.l10n.delete),
        content: Text(
          context.l10n.confirmDeleteNamed(structure.libelleLongCdi),
        ),
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
    if (confirmed == true) {
      await provider.deleteStructure(structure.codeCdi);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.structures),
        actions: const [DrawerMenuButton()],
      ),
      drawer: const AppDrawer(),
      body: Consumer<StructureProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.structures.isEmpty) {
            return Center(child: Text(context.l10n.noStructures));
          }
          return ListView.builder(
            itemCount: provider.structures.length,
            itemBuilder: (context, index) {
              final structure = provider.structures[index];
              return ListTile(
                leading: const Icon(Icons.apartment_outlined),
                title: Text(structure.libelleLongCdi),
                subtitle: Text(structure.codeCdi),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () =>
                          _openForm(context, provider, initial: structure),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () =>
                          _confirmDelete(context, provider, structure),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          backgroundColor: GsrColors.primary,
          onPressed: () =>
              _openForm(context, context.read<StructureProvider>()),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
