import 'package:flutter/material.dart';
import '../widgets/conversation_view.dart';
import '../../../../l10n/l10n_extensions.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/drawer_menu_button.dart';

/// Écran agent : discussion directe avec l'administration.
class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.messagingWithAdmin),
        actions: const [DrawerMenuButton()],
      ),
      drawer: const AppDrawer(),
      body: const ConversationView(),
    );
  }
}
