import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:gsr_app/features/statistics/domain/entities/room_statistics.dart';
import 'package:gsr_app/features/statistics/domain/repositories/statistics_repository.dart';
import 'package:gsr_app/features/statistics/domain/usecases/get_room_statistics.dart';
import 'package:gsr_app/features/statistics/presentation/providers/statistics_provider.dart';
import 'package:gsr_app/features/statistics/presentation/screens/statistic_rooms_screen.dart';
import '../helpers/fakes.dart';

class _FakeStatisticsRepository implements StatisticsRepository {
  @override
  Future<RoomStatistics> getRoomStatistics() async {
    return RoomStatistics(
      byStatus: {'en_attente': 3, 'validee': 5, 'rejetee': 2},
      mostRequested: [
        MostRequestedRoom(roomId: 1, name: 'Salle Panafricaine', total: 4),
      ],
      byDirectionRegionale: {'Direction Régionale du Centre': 6},
    );
  }
}

void main() {
  Widget buildTestable() {
    return ChangeNotifierProvider(
      create: (_) => StatisticsProvider(
        getRoomStatisticsUseCase: GetRoomStatistics(
          _FakeStatisticsRepository(),
        ),
      ),
      child: frApp(const StatisticRoomsScreen()),
    );
  }

  testWidgets(
    'affiche les cartes chiffrées à partir des statistiques réelles',
    (tester) async {
      await tester.pumpWidget(buildTestable());
      await tester.pumpAndSettle();

      expect(find.text('Statistiques & Analytique GsrApp'), findsOneWidget);
      expect(find.text('3'), findsOneWidget); // en attente
      expect(find.text('5'), findsOneWidget); // validées
      expect(find.text('2'), findsOneWidget); // rejetées
      expect(find.text('Salle Panafricaine'), findsOneWidget);
    },
  );
}
