import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stockage clé/valeur chiffré. Remplaçable dans les tests.
abstract class SecureKeyValueStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

class PlatformSecureStore implements SecureKeyValueStore {
  const PlatformSecureStore();

  static const _storage = FlutterSecureStorage();

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

/// Dernier profil connu de l'utilisateur, conservé dans le stockage
/// sécurisé (données personnelles). Il permet de rouvrir l'application sans
/// réseau : le jeton reste valable et l'utilisateur n'est pas déconnecté
/// parce que le serveur est momentanément injoignable.
class ProfileCache {
  ProfileCache._();

  static const _key = 'gsr_cached_profile';

  static SecureKeyValueStore store = const PlatformSecureStore();

  static Future<void> save(Map<String, dynamic> profile) async {
    try {
      await store.write(_key, json.encode(profile));
    } catch (_) {
      // Sans stockage disponible, le mode hors ligne est simplement indisponible.
    }
  }

  static Future<Map<String, dynamic>?> load() async {
    try {
      final raw = await store.read(_key);
      if (raw == null) return null;
      return json.decode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear() async {
    try {
      await store.delete(_key);
    } catch (_) {}
  }
}
