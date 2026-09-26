import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';
import '../../domain/entities/notification_item.dart';
import '../../../../l10n/l10n_extensions.dart';
import '../../../../core/widgets/error_retry.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/drawer_menu_button.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<NotificationProvider>().fetchNotifications();
    });
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'reservation_validee':
        return Icons.check_circle;
      case 'reservation_rejetee':
        return Icons.cancel;
      case 'nouveau_message':
        return Icons.message;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.notifications),
        actions: const [DrawerMenuButton()],
      ),
      drawer: const AppDrawer(),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null && provider.notifications.isEmpty) {
            return ErrorRetry(
              message: provider.error!,
              onRetry: provider.fetchNotifications,
            );
          }
          if (provider.notifications.isEmpty) {
            return Center(child: Text(context.l10n.noNotifications));
          }
          return RefreshIndicator(
            onRefresh: provider.fetchNotifications,
            child: ListView.builder(
              itemCount: provider.notifications.length,
              itemBuilder: (context, index) {
                final NotificationItem item = provider.notifications[index];
                return ListTile(
                  leading: Icon(
                    _iconFor(item.type),
                    color: item.isRead
                        ? Colors.grey
                        : Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    item.title,
                    style: TextStyle(
                      fontWeight: item.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${item.body}\n${DateFormat('dd/MM/yyyy HH:mm').format(item.createdAt)}',
                  ),
                  isThreeLine: true,
                  onTap: item.isRead
                      ? null
                      : () => provider.markAsRead(item.id),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
