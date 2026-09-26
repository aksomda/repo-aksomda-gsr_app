import 'dart:convert';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/room_statistics.dart';

class StatisticsRemoteDataSource {
  /// Lève une [ApiException] si le chargement échoue.
  Future<RoomStatistics> getRoomStatistics() async {
    final response = await ApiClient.get('/statistics/rooms');
    final body = json.decode(response.body) as Map<String, dynamic>;

    final byStatus = <String, int>{};
    for (final row in (body['byStatus'] as List? ?? [])) {
      byStatus[row['status'] ?? ''] =
          int.tryParse(row['total'].toString()) ?? 0;
    }

    final mostRequested = (body['mostRequested'] as List? ?? [])
        .map(
          (row) => MostRequestedRoom(
            roomId: int.tryParse(row['room_id'].toString()) ?? 0,
            name: row['name'] ?? '',
            total: int.tryParse(row['total'].toString()) ?? 0,
          ),
        )
        .toList();

    // Le serveur regroupe par structure de rattachement de la salle
    // (ref_structure) : c'est la direction régionale choisie sur la salle.
    final byDirectionRegionale = <String, int>{};
    for (final row in (body['byStructure'] as List? ?? [])) {
      byDirectionRegionale[row['structure'] ?? '—'] =
          int.tryParse(row['total'].toString()) ?? 0;
    }

    return RoomStatistics(
      byStatus: byStatus,
      mostRequested: mostRequested,
      byDirectionRegionale: byDirectionRegionale,
    );
  }
}
