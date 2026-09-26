import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/gsr_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/message_provider.dart';
import '../../../../l10n/l10n_extensions.dart';
import '../../../../core/widgets/error_retry.dart';

/// Vue de conversation réutilisée par l'écran agent (discussion avec
/// l'administration) et l'écran admin (discussion avec un agent précis).
class ConversationView extends StatefulWidget {
  final String? peerLogin;

  const ConversationView({super.key, this.peerLogin});

  @override
  State<ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends State<ConversationView> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  MessageProvider? _messageProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _messageProvider = context.read<MessageProvider>();
      _messageProvider!.fetchConversation(withLogin: widget.peerLogin);
      _messageProvider!.startPolling();
    });
  }

  @override
  void dispose() {
    _messageProvider?.stopPolling();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    await context.read<MessageProvider>().send(
      text,
      recipientLogin: widget.peerLogin,
    );
  }

  @override
  Widget build(BuildContext context) {
    final myLogin = context.watch<AuthProvider>().currentUser?.login;

    return Column(
      children: [
        Expanded(
          child: Consumer<MessageProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading && provider.messages.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (provider.error != null && provider.messages.isEmpty) {
                return ErrorRetry(
                  message: provider.error!,
                  onRetry: () =>
                      provider.fetchConversation(withLogin: widget.peerLogin),
                );
              }
              if (provider.messages.isEmpty) {
                return Center(child: Text(context.l10n.noMessages));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: provider.messages.length,
                itemBuilder: (context, index) {
                  final message = provider.messages[index];
                  final isMine = message.senderLogin == myLogin;
                  return Align(
                    alignment: isMine
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: isMine ? GsrColors.primary : Colors.grey[200],
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        message.content,
                        style: TextStyle(
                          color: isMine ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: context.l10n.writeMessage,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: GsrColors.primary),
                  onPressed: _send,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
