import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/room_statistics.dart';
import '../providers/statistics_provider.dart';
import '../../../../l10n/l10n_extensions.dart';
import '../../../../core/widgets/error_retry.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/drawer_menu_button.dart';

class StatisticRoomsScreen extends StatefulWidget {
  const StatisticRoomsScreen({super.key});

  @override
  State<StatisticRoomsScreen> createState() => _StatisticRoomsScreenState();
}

class _StatisticRoomsScreenState extends State<StatisticRoomsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<StatisticsProvider>().fetchStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.statsTitle),
        actions: const [DrawerMenuButton()],
      ),
      drawer: const AppDrawer(),
      body: Consumer<StatisticsProvider>(
        builder: (context, provider, child) {
          if (provider.error != null && provider.statistics == null) {
            return ErrorRetry(
              message: provider.error!,
              onRetry: provider.fetchStatistics,
            );
          }
          if (provider.isLoading || provider.statistics == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final stats = provider.statistics!;

          return RefreshIndicator(
            onRefresh: provider.fetchStatistics,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.reservationRequestsTitle,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _buildCubeCard(
                        context.l10n.resPending,
                        '${stats.countFor('en_attente')}',
                        Colors.orange,
                      ),
                      _buildCubeCard(
                        context.l10n.resValidated,
                        '${stats.countFor('validee')}',
                        Colors.green,
                      ),
                      _buildCubeCard(
                        context.l10n.resRejected,
                        '${stats.countFor('rejetee')}',
                        Colors.red,
                      ),
                      _buildCubeCard(
                        context.l10n.successRate,
                        '${(stats.successRate() * 100).toStringAsFixed(0)}%',
                        Colors.blue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    context.l10n.frequencyByDirection,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildFrequencyChart(stats),
                  const SizedBox(height: 24),
                  Text(
                    context.l10n.mostRequestedRooms,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ..._buildMostRequested(stats),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCubeCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencyChart(RoomStatistics stats) {
    if (stats.byDirectionRegionale.isEmpty) {
      return Text(context.l10n.noData);
    }
    final maxValue = stats.byDirectionRegionale.values.fold(
      1,
      (a, b) => a > b ? a : b,
    );

    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: stats.byDirectionRegionale.entries
            .map(
              (entry) =>
                  _buildBar(entry.key, entry.value / maxValue, Colors.teal),
            )
            .toList(),
      ),
    );
  }

  List<Widget> _buildMostRequested(RoomStatistics stats) {
    if (stats.mostRequested.isEmpty) {
      return [Text(context.l10n.noReservationsYet)];
    }
    return stats.mostRequested
        .map(
          (room) => ListTile(
            leading: const Icon(Icons.meeting_room),
            title: Text(room.name),
            trailing: Text(context.l10n.requestsCount(room.total)),
          ),
        )
        .toList();
  }

  Widget _buildBar(String label, double factor, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: 100 * factor.clamp(0.02, 1.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 60,
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
