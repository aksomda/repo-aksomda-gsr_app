import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/gsr_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/reservation_room_provider.dart';
import '../widgets/reservation_request_form.dart';
import '../../domain/entities/reservation_room.dart';
import '../../../../l10n/l10n_extensions.dart';
import '../../../../core/widgets/error_retry.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/drawer_menu_button.dart';

class ReservationRoomsScreen extends HookWidget {
  const ReservationRoomsScreen({super.key});

  Future<void> _reject(
    BuildContext context,
    ReservationRoomProvider provider,
    ReservationRoom reservation,
  ) async {
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.l10n.rejectRequest),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: context.l10n.rejectReasonOptional,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: Text(context.l10n.reject),
          ),
        ],
      ),
    );
    if (reason == null) return;
    if (reservation.id != null) {
      await provider.reject(
        reservation.id!,
        reason: reason.isEmpty ? null : reason,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 3);
    final isAdmin = context.watch<AuthProvider>().currentUser?.isAdmin ?? false;

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = context.read<ReservationRoomProvider>();
        if (isAdmin) {
          provider.fetchAll();
        } else {
          provider.fetchMine();
        }
      });
      return null;
    }, [isAdmin]);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.reservationRequests),
        actions: const [DrawerMenuButton()],
        bottom: TabBar(
          controller: tabController,
          tabs: [
            Tab(
              text: context.l10n.resPending,
              icon: Icon(
                Icons.hourglass_empty,
                semanticLabel: context.l10n.iconPending,
              ),
            ),
            Tab(
              text: context.l10n.resValidated,
              icon: Icon(
                Icons.check_circle,
                semanticLabel: context.l10n.iconValidated,
              ),
            ),
            Tab(
              text: context.l10n.resRejected,
              icon: Icon(
                Icons.cancel,
                semanticLabel: context.l10n.iconRejected,
              ),
            ),
          ],
        ),
      ),
      drawer: const AppDrawer(),
      body: Consumer<ReservationRoomProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null && provider.reservations.isEmpty) {
            return ErrorRetry(
              message: provider.error!,
              onRetry: isAdmin ? provider.fetchAll : provider.fetchMine,
            );
          }
          return TabBarView(
            controller: tabController,
            children: [
              _buildList(
                context,
                provider,
                provider.getByStatus('en_attente'),
                isAdmin,
              ),
              _buildList(
                context,
                provider,
                provider.getByStatus('validee'),
                isAdmin,
              ),
              _buildList(
                context,
                provider,
                provider.getByStatus('rejetee'),
                isAdmin,
              ),
            ],
          );
        },
      ),
      floatingActionButton: isAdmin
          ? null
          : Builder(
              builder: (context) => FloatingActionButton.extended(
                backgroundColor: GsrColors.primary,
                onPressed: () => showReservationRequestForm(context),
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text(
                  context.l10n.request,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
    );
  }

  Widget _loadMoreButton(
    BuildContext context,
    ReservationRoomProvider provider,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: provider.isLoadingMore
            ? const CircularProgressIndicator()
            : OutlinedButton.icon(
                onPressed: provider.loadMore,
                icon: const Icon(Icons.expand_more),
                label: Text(context.l10n.loadMore),
              ),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    ReservationRoomProvider provider,
    List<ReservationRoom> items,
    bool isAdmin,
  ) {
    if (items.isEmpty && !provider.hasMore) {
      return Center(child: Text(context.l10n.noReservations));
    }
    final footer = provider.hasMore ? 1 : 0;
    return ListView.builder(
      itemCount: items.length + footer,
      itemBuilder: (context, index) {
        if (index == items.length) return _loadMoreButton(context, provider);
        final item = items[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Semantics(
                    label: context.l10n.reservationStatusLabel(
                      context.l10n.reservationStatusName(item.status),
                    ),
                    child: const Icon(Icons.meeting_room),
                  ),
                  title: Text(
                    item.meetingSubject,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${item.roomName ?? context.l10n.roomNumberFallback('${item.roomId}')}'
                    '${isAdmin && item.requesterName != null ? ' - ${item.requesterName}' : ''}\n'
                    '${context.l10n.reservationStructureLine(item.organizingStructure)}\n'
                    '${context.l10n.reservationDateLine(item.date, item.startTimeShort, item.endTimeShort)}'
                    '${item.status == 'rejetee' && item.rejectionReason != null ? '\n${context.l10n.reservationReasonLine(item.rejectionReason!)}' : ''}',
                  ),
                  isThreeLine: true,
                ),
                if (isAdmin && item.status == 'en_attente')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => _reject(context, provider, item),
                        child: Text(
                          context.l10n.reject,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: item.id == null
                            ? null
                            : () => provider.validate(item.id!),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GsrColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(context.l10n.validate),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
