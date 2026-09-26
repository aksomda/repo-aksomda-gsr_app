class MostRequestedRoom {
  final int roomId;
  final String name;
  final int total;

  MostRequestedRoom({
    required this.roomId,
    required this.name,
    required this.total,
  });
}

class RoomStatistics {
  final Map<String, int> byStatus;
  final List<MostRequestedRoom> mostRequested;
  final Map<String, int> byDirectionRegionale;

  RoomStatistics({
    required this.byStatus,
    required this.mostRequested,
    required this.byDirectionRegionale,
  });

  int countFor(String status) => byStatus[status] ?? 0;

  int get total => byStatus.values.fold(0, (a, b) => a + b);

  double successRate() {
    if (total == 0) return 0;
    return countFor('validee') / total;
  }
}
