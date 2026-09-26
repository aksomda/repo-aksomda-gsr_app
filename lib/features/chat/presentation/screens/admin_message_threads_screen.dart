import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/gsr_colors.dart';
import '../../../../core/widgets/searchable_select_field.dart';
import '../providers/message_provider.dart';
import '../widgets/conversation_view.dart';
import '../../../../l10n/l10n_extensions.dart';
import '../../../../core/widgets/error_retry.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/drawer_menu_button.dart';

/// Écran admin : liste des agents ayant écrit, puis conversation dédiée.
class AdminMessageThreadsScreen extends StatefulWidget {
  const AdminMessageThreadsScreen({super.key});

  @override
  State<AdminMessageThreadsScreen> createState() =>
      _AdminMessageThreadsScreenState();
}

class _AdminMessageThreadsScreenState extends State<AdminMessageThreadsScreen> {
  @override
  void initState() {
    super.initState();
    // Après le premier build : fetchThreads notifie les listeners.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<MessageProvider>().fetchThreads();
    });
  }

  Future<void> _openConversation(String login, String title) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: ConversationView(peerLogin: login),
        ),
      ),
    );
    if (mounted) context.read<MessageProvider>().fetchThreads();
  }

  Future<void> _newMessage() async {
    final provider = context.read<MessageProvider>();
    await provider.fetchRecipients();
    if (!mounted) return;

    final picked = await pickOption<String>(
      context,
      title: context.l10n.newMessageChooseAgent,
      options: provider.recipients
          .map((r) => SelectOption(r.login, '${r.nomComplet} (${r.login})'))
          .toList(),
    );
    if (picked == null || !mounted) return;

    final recipient = provider.recipients.firstWhere(
      (r) => r.login == picked.value,
    );
    await _openConversation(recipient.login, recipient.nomComplet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.messaging),
        actions: const [DrawerMenuButton()],
      ),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: GsrColors.primary,
        foregroundColor: Colors.white,
        onPressed: _newMessage,
        icon: const Icon(Icons.edit_outlined),
        label: Text(context.l10n.newMessage),
      ),
      body: Consumer<MessageProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null && provider.threads.isEmpty) {
            return ErrorRetry(
              message: provider.error!,
              onRetry: provider.fetchThreads,
            );
          }
          if (provider.threads.isEmpty) {
            return Center(
              child: Text(
                context.l10n.noAgentMessages,
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.builder(
            itemCount: provider.threads.length,
            itemBuilder: (context, index) {
              final thread = provider.threads[index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                title: Text(thread.nomComplet),
                trailing: thread.unreadCount > 0
                    ? CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.red,
                        child: Text(
                          '${thread.unreadCount}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : null,
                onTap: () => _openConversation(thread.login, thread.nomComplet),
              );
            },
          );
        },
      ),
    );
  }
}
