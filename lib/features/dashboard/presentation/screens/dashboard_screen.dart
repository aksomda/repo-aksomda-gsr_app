import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/gsr_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../rooms/presentation/bloc/providers/room_provider.dart';
import '../../../statistics/domain/entities/room_statistics.dart';
import '../../../statistics/presentation/providers/statistics_provider.dart';
import '../../../../l10n/l10n_extensions.dart';
import '../../../../core/widgets/error_retry.dart';

const _roomStatusColors = <String, Color>{
  'disponible': Color(0xFF1B8A5A),
  'reservé': Color(0xFFF59E0B),
  'en refection': Color(0xFF3B82F6),
  'dégradé': Color(0xFFDC2626),
  'en construction': Color(0xFF8B5CF6),
  'occupé': Color(0xFF8B5CF6),
};

const _reservationStatusColors = <String, Color>{
  'en_attente': Color(0xFFF59E0B),
  'validee': Color(0xFF1B8A5A),
  'rejetee': Color(0xFFDC2626),
};

/// Page d'accueil : indicateurs clés et graphiques d'activité.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<StatisticsProvider>().fetchStatistics();
    });
  }

  Future<void> _refresh() async {
    await Future.wait([
      context.read<RoomProvider>().fetchRooms(),
      context.read<StatisticsProvider>().fetchStatistics(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final rooms = context.watch<RoomProvider>().rooms;
    final statsProvider = context.watch<StatisticsProvider>();
    final stats = statsProvider.statistics;

    final roomsByStatus = <String, int>{};
    for (final room in rooms) {
      roomsByStatus[room.status] = (roomsByStatus[room.status] ?? 0) + 1;
    }
    final available = roomsByStatus['disponible'] ?? 0;

    return RefreshIndicator(
      onRefresh: _refresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;
          final chartWidth = wide
              ? (constraints.maxWidth - 16 * 2 - 16) / 2
              : constraints.maxWidth - 16 * 2;

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              _Header(name: user?.prenom ?? ''),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _KpiCard(
                    icon: Icons.meeting_room,
                    label: context.l10n.dashRooms,
                    value: '${rooms.length}',
                    color: GsrColors.primary,
                  ),
                  _KpiCard(
                    icon: Icons.check_circle_outline,
                    label: context.l10n.dashAvailableRooms,
                    value: '$available',
                    color: const Color(0xFF3B82F6),
                  ),
                  _KpiCard(
                    icon: Icons.book_online,
                    label: context.l10n.reservations,
                    value: '${stats?.total ?? 0}',
                    color: const Color(0xFF8B5CF6),
                  ),
                  _KpiCard(
                    icon: Icons.hourglass_top,
                    label: context.l10n.resPending,
                    value: '${stats?.countFor('en_attente') ?? 0}',
                    color: const Color(0xFFF59E0B),
                  ),
                  _KpiCard(
                    icon: Icons.trending_up,
                    label: context.l10n.dashValidationRate,
                    value:
                        '${((stats?.successRate() ?? 0) * 100).toStringAsFixed(0)}%',
                    color: const Color(0xFF1B8A5A),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _ChartCard(
                    width: chartWidth,
                    title: context.l10n.dashRoomsByStatus,
                    child: _RoomsDonut(counts: roomsByStatus),
                  ),
                  _ChartCard(
                    width: chartWidth,
                    title: context.l10n.dashReservationsByStatus,
                    child: stats == null && statsProvider.isLoading
                        ? const _Loading()
                        : stats == null && statsProvider.error != null
                        ? ErrorRetry(
                            message: statsProvider.error!,
                            onRetry: statsProvider.fetchStatistics,
                          )
                        : _ReservationsBars(stats: stats),
                  ),
                  _ChartCard(
                    width: chartWidth,
                    title: context.l10n.mostRequestedRooms,
                    child: _RankedBars(
                      entries: {
                        for (final r in stats?.mostRequested ?? const [])
                          r.name: r.total,
                      },
                      color: GsrColors.primary,
                    ),
                  ),
                  _ChartCard(
                    width: chartWidth,
                    title: context.l10n.dashReservationsByDirection,
                    child: _RankedBars(
                      entries: stats?.byDirectionRegionale ?? const {},
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String name;

  const _Header({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [GsrColors.primary, GsrColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.dashboard_outlined, color: Colors.white, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty
                      ? context.l10n.welcome
                      : context.l10n.helloName(name),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.dashSubtitle,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _KpiCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final double width;
  final String title;
  final Widget child;

  const _ChartCard({
    required this.width,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) => const SizedBox(
    height: 200,
    child: Center(child: CircularProgressIndicator()),
  );
}

class _NoData extends StatelessWidget {
  const _NoData();

  @override
  Widget build(BuildContext context) =>
      SizedBox(height: 120, child: Center(child: Text(context.l10n.noData)));
}

class _RoomsDonut extends StatelessWidget {
  final Map<String, int> counts;

  const _RoomsDonut({required this.counts});

  @override
  Widget build(BuildContext context) {
    final entries = counts.entries.where((e) => e.value > 0).toList();
    if (entries.isEmpty) return const _NoData();

    final total = entries.fold<int>(0, (sum, e) => sum + e.value);

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 48,
              sections: [
                for (final e in entries)
                  PieChartSectionData(
                    value: e.value.toDouble(),
                    color: _roomStatusColors[e.key] ?? Colors.grey,
                    radius: 42,
                    title: '${e.value}',
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            for (final e in entries)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _roomStatusColors[e.key] ?? Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${context.l10n.roomStatusName(e.key)} '
                    '(${(e.value * 100 / total).toStringAsFixed(0)}%)',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class _ReservationsBars extends StatelessWidget {
  final RoomStatistics? stats;

  const _ReservationsBars({required this.stats});

  @override
  Widget build(BuildContext context) {
    if (stats == null || stats!.total == 0) return const _NoData();

    final keys = _reservationStatusColors.keys.toList();
    final maxValue = keys
        .map((k) => stats!.countFor(k))
        .fold<int>(1, (a, b) => a > b ? a : b);

    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          maxY: maxValue * 1.2,
          alignment: BarChartAlignment.spaceAround,
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(drawVerticalLine: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) => value % 1 == 0
                    ? SideTitleWidget(
                        meta: meta,
                        child: Text(
                          '${value.toInt()}',
                          style: const TextStyle(fontSize: 11),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(
                    context.l10n.reservationStatusName(keys[value.toInt()]),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < keys.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: stats!.countFor(keys[i]).toDouble(),
                    color: _reservationStatusColors[keys[i]]!,
                    width: 32,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Classement en barres horizontales (libellés potentiellement longs).
class _RankedBars extends StatelessWidget {
  final Map<String, int> entries;
  final Color color;

  const _RankedBars({required this.entries, required this.color});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const _NoData();

    final sorted = entries.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxValue = sorted.first.value == 0 ? 1 : sorted.first.value;

    return Column(
      children: [
        for (final e in sorted.take(6))
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        e.key,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    Text(
                      '${e.value}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: e.value / maxValue,
                    minHeight: 10,
                    color: color,
                    backgroundColor: color.withValues(alpha: 0.12),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
