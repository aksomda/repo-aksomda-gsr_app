import 'package:flutter/foundation.dart';

/// Configuration de l'API GSR.
///
/// `API_BASE_URL` se fixe au build/run avec
/// `--dart-define=API_BASE_URL=https://mon-domaine.com/api/gsr` : jamais
/// codée en dur dans les sources de données. Sans valeur, on cible le serveur
/// local de développement.
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api/gsr',
  );

  /// Problème de configuration empêchant un build release de démarrer, ou
  /// null si tout est correct. En release, l'API doit être en https et ne
  /// pas pointer sur la machine locale (valeur de développement oubliée).
  static String? releaseConfigError({
    String url = baseUrl,
    bool isRelease = kReleaseMode,
  }) {
    if (!isRelease) return null;
    final uri = Uri.tryParse(url);
    if (uri == null || uri.scheme != 'https') {
      return 'API_BASE_URL doit être une URL https en production '
          '(actuellement : $url). Build avec '
          '--dart-define=API_BASE_URL=https://votre-domaine/api/gsr.';
    }
    const local = {'localhost', '127.0.0.1', '10.0.2.2'};
    if (local.contains(uri.host)) {
      return 'API_BASE_URL pointe sur une adresse locale ($url) : '
          'configuration de développement en production.';
    }
    return null;
  }
}
