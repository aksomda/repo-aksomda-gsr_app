import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// Résultat d'un test de connexion à l'API GSR.
class ApiHealth {
  /// Le serveur a répondu.
  final bool reachable;

  /// Le serveur a pu interroger MySQL.
  final bool database;

  /// Durée de l'aller-retour, si le serveur a répondu.
  final int? latencyMs;

  const ApiHealth({
    required this.reachable,
    required this.database,
    this.latencyMs,
  });

  static const unreachable = ApiHealth(reachable: false, database: false);
}

Future<ApiHealth> checkApiHealth({
  Duration timeout = const Duration(seconds: 5),
}) async {
  final stopwatch = Stopwatch()..start();
  try {
    final response = await http
        .get(Uri.parse('${ApiConfig.baseUrl}/health'))
        .timeout(timeout);
    return ApiHealth(
      reachable: response.statusCode == 200 || response.statusCode == 503,
      database: response.statusCode == 200,
      latencyMs: stopwatch.elapsedMilliseconds,
    );
  } catch (_) {
    return ApiHealth.unreachable;
  }
}
