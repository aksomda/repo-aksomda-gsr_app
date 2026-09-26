import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../l10n/l10n_extensions.dart';
import '../models/paged.dart';
import '../config/api_config.dart';
import 'session.dart';

/// Erreur d'appel API, avec un message déjà prêt à afficher.
/// [statusCode] est null quand le serveur n'a pas pu être joint.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  bool get isNetworkError => statusCode == null;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Message affichable pour n'importe quelle erreur attrapée par un provider.
String errorMessageOf(Object error) =>
    error is ApiException ? error.message : AppLocale.l10n.errUnexpected;

/// Point d'entrée unique des appels HTTP : URL de base, en-tête
/// d'authentification, délai maximal, et traduction des échecs en
/// [ApiException]. Toute réponse 2xx est renvoyée telle quelle.
class ApiClient {
  ApiClient._();

  /// Délai maximal d'un appel (modifiable dans les tests).
  static Duration timeout = const Duration(seconds: 15);

  /// Appelé quand le serveur refuse le jeton (401) : la session a expiré.
  static void Function()? onUnauthorized;

  /// Remplaçable dans les tests (`MockClient`).
  static http.Client client = http.Client();

  static Future<http.Response> get(
    String path, {
    Map<String, String>? query,
    bool auth = true,
  }) {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}$path',
    ).replace(queryParameters: query);
    return _send(() => client.get(uri, headers: _headers(auth)), auth);
  }

  static Future<http.Response> post(
    String path, {
    Object? body,
    bool auth = true,
  }) {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    return _send(
      () => client.post(
        uri,
        headers: {'Content-Type': 'application/json', ..._headers(auth)},
        body: body == null ? null : json.encode(body),
      ),
      auth,
    );
  }

  static Future<http.Response> delete(String path, {Object? body, bool auth = true}) {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    return _send(
      () => client.send(
        http.Request('DELETE', uri)
          ..headers.addAll({'Content-Type': 'application/json', ..._headers(auth)})
          ..body = body == null ? '' : json.encode(body),
      ).then(http.Response.fromStream),
      auth,
    );
  }

  /// Envoi d'un fichier en `multipart/form-data` (ex : photo de profil).
  /// [fieldName] est le nom du champ attendu par le serveur (voir
  /// `multer().single(fieldName)` côté API).
  static Future<http.Response> postMultipart(
    String path, {
    required String fieldName,
    required List<int> bytes,
    required String filename,
    String? contentType,
    bool auth = true,
  }) {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    return _send(() async {
      final request = http.MultipartRequest('POST', uri)..headers.addAll(_headers(auth));
      request.files.add(
        http.MultipartFile.fromBytes(
          fieldName,
          bytes,
          filename: filename,
          contentType: contentType == null ? null : MediaType.parse(contentType),
        ),
      );
      final streamed = await client.send(request);
      return http.Response.fromStream(streamed);
    }, auth);
  }

  /// GET d'une liste JSON.
  static Future<List<dynamic>> getList(
    String path, {
    Map<String, String>? query,
    bool auth = true,
  }) async {
    final response = await get(path, query: query, auth: auth);
    final data = json.decode(response.body);
    if (data is! List) {
      throw ApiException(
        AppLocale.l10n.errUnexpected,
        statusCode: response.statusCode,
      );
    }
    return data;
  }

  /// Taille de page demandée au serveur pour les listes paginées.
  static const int pageSize = 50;

  /// GET d'une page d'une liste paginée (?limit=&offset=). Le serveur indique
  /// s'il reste des résultats dans l'en-tête X-Has-More.
  static Future<Paged<dynamic>> getPage(
    String path, {
    int offset = 0,
    Map<String, String>? query,
  }) async {
    final response = await get(
      path,
      query: {...?query, 'limit': '$pageSize', 'offset': '$offset'},
    );
    final data = json.decode(response.body);
    if (data is! List) {
      throw ApiException(
        AppLocale.l10n.errUnexpected,
        statusCode: response.statusCode,
      );
    }
    return Paged(data, hasMore: response.headers['x-has-more'] == 'true');
  }

  static Map<String, String> _headers(bool auth) =>
      auth ? Session.authHeaders : const {};

  static Future<http.Response> _send(
    Future<http.Response> Function() request,
    bool auth,
  ) async {
    final http.Response response;
    try {
      response = await request().timeout(timeout);
    } on TimeoutException {
      throw ApiException(AppLocale.l10n.errTimeout);
    } catch (_) {
      throw ApiException(AppLocale.l10n.errServerUnreachable);
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    }
    if (response.statusCode == 401 && auth) {
      onUnauthorized?.call();
      throw ApiException(
        AppLocale.l10n.errSessionExpired,
        statusCode: response.statusCode,
      );
    }
    throw ApiException(
      _serverMessage(response) ??
          AppLocale.l10n.errServerStatus('${response.statusCode}'),
      statusCode: response.statusCode,
    );
  }

  static String? _serverMessage(http.Response response) {
    try {
      final body = json.decode(response.body);
      if (body is Map && body['error'] != null) {
        return body['error'].toString();
      }
    } catch (_) {}
    return null;
  }
}
