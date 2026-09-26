import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../storage/profile_cache.dart';

/// Détient le token JWT de la session en cours : en mémoire pour un accès
/// synchrone depuis les appels HTTP (en-têtes), et persisté dans le stockage
/// sécurisé de la plateforme (Keychain / Keystore) pour survivre au
/// redémarrage de l'app. Si ce stockage est indisponible, la session reste
/// simplement valable jusqu'à la fermeture de l'application.
class Session {
  Session._();

  static const _tokenKey = 'gsr_auth_token';
  static const _storage = FlutterSecureStorage();
  static String? _token;

  static String? get token => _token;

  static Map<String, String> get authHeaders =>
      _token == null ? const {} : {'Authorization': 'Bearer $_token'};

  static Future<void> restore() async {
    try {
      _token = await _storage.read(key: _tokenKey);
      _token ??= await _migrateLegacyToken();
    } catch (_) {
      _token = null;
    }
  }

  static Future<void> save(String token) async {
    _token = token;
    try {
      await _storage.write(key: _tokenKey, value: token);
    } catch (_) {
      // Non persisté : valable pour la session en cours uniquement.
    }
  }

  static Future<void> clear() async {
    _token = null;
    try {
      await _storage.delete(key: _tokenKey);
    } catch (_) {}
    await ProfileCache.clear();
  }

  /// Les anciennes versions stockaient le jeton en clair dans
  /// shared_preferences : on le déplace vers le stockage sécurisé.
  static Future<String?> _migrateLegacyToken() async {
    final prefs = await SharedPreferences.getInstance();
    final legacy = prefs.getString(_tokenKey);
    if (legacy == null) return null;
    await _storage.write(key: _tokenKey, value: legacy);
    await prefs.remove(_tokenKey);
    return legacy;
  }
}
