import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/gsr_colors.dart';
import '../providers/user_management_provider.dart';
import '../widgets/create_user_form_dialog.dart';
import '../../../../l10n/l10n_extensions.dart';
import '../../../../core/widgets/error_retry.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/drawer_menu_button.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<UserManagementProvider>().fetchPendingUsers();
    });
  }

  Future<void> _createUser(
    BuildContext context,
    UserManagementProvider provider,
  ) async {
    final data = await showCreateUserFormDialog(context);
    if (data == null) return;

    final success = await provider.createUser(
      nom: data.nom,
      prenom: data.prenom,
      matricule: data.matricule,
      telephone: data.telephone,
      numeroFlotte: data.numeroFlotte,
      email: data.email,
      password: data.password,
      structureCode: data.structureCode,
      role: data.role,
    );

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? context.l10n.accountCreatedSuccess
              : context.l10n.accountCreationFailed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.userAccountsManagement),
        actions: const [DrawerMenuButton()],
      ),
      drawer: const AppDrawer(),
      body: Consumer<UserManagementProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null && provider.pendingUsers.isEmpty) {
            return ErrorRetry(
              message: provider.error!,
              onRetry: provider.fetchPendingUsers,
            );
          }
          if (provider.pendingUsers.isEmpty) {
            return Center(child: Text(context.l10n.noPendingAccounts));
          }
          return ListView.builder(
            itemCount: provider.pendingUsers.length,
            itemBuilder: (context, index) {
              final user = provider.pendingUsers[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person_outline),
                  ),
                  title: Text(user.nomComplet),
                  subtitle: Text(
                    '${user.email}\n${user.structureLibelle ?? context.l10n.noStructureShort} · ${context.l10n.roleName(user.role)}',
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.check_circle,
                          color: GsrColors.primary,
                        ),
                        tooltip: context.l10n.approveAccount,
                        onPressed: user.login == null
                            ? null
                            : () => provider.approve(user.login!),
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        tooltip: context.l10n.rejectAccount,
                        onPressed: user.login == null
                            ? null
                            : () => provider.reject(user.login!),
                      ),
                    ],
                  ),
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
              _createUser(context, context.read<UserManagementProvider>()),
          child: const Icon(Icons.person_add, color: Colors.white),
        ),
      ),
    );
  }
}
