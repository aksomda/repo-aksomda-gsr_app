import '../network/api_client.dart';
import 'firebase_auth_bridge.dart';
import 'firebase_bootstrap.dart';
import 'platform_firebase.dart';
import 'push_token_provider.dart';

/// Synchronise la session Firebase Auth et l'enregistrement des
/// notifications push avec le cycle de connexion/déconnexion de gsr_app
/// (voir AuthProvider). Entièrement best-effort : Firebase indisponible ou
/// non configuré ne bloque jamais la connexion, la restauration de session
/// ni la déconnexion MySQL, qui restent seules décisionnaires.
class FirebaseSync {
  FirebaseSync._();

  /// Remplaçables dans les tests pour éviter tout appel de plateforme réel.
  static FirebaseAuthBridge authBridge = PlatformFirebaseAuthBridge();
  static PushTokenProvider pushTokenProvider = PlatformPushTokenProvider();

  static String? _registeredToken;

  /// À appeler après une connexion réussie (jeton Firebase fourni par le
  /// serveur) ou après une restauration de session au démarrage
  /// ([firebaseToken] alors null : la session Firebase Auth précédente, si
  /// elle existe, est conservée par le SDK — seul le jeton push est
  /// réenregistré).
  static Future<void> onLogin(String? firebaseToken) async {
    if (!FirebaseBootstrap.available) return;
    try {
      if (firebaseToken != null) {
        await authBridge.signInWithCustomToken(firebaseToken);
      }
      final token = await pushTokenProvider.getToken();
      if (token != null) {
        await _registerToken(token);
      }
      pushTokenProvider.onTokenRefresh.listen(_registerToken);
    } catch (_) {
      // Best effort : voir la note de classe ci-dessus.
    }
  }

  static Future<void> _registerToken(String token) async {
    try {
      await ApiClient.post(
        '/fcm/token',
        body: {'token': token, 'platform': 'android'},
      );
      _registeredToken = token;
    } catch (_) {}
  }

  /// À appeler à la déconnexion : l'appareil ne doit plus recevoir de push
  /// pour ce compte, et la session Firebase Auth locale est fermée.
  static Future<void> onLogout() async {
    if (!FirebaseBootstrap.available) return;
    try {
      final token = _registeredToken;
      if (token != null) {
        await ApiClient.delete('/fcm/token', body: {'token': token});
      }
      await authBridge.signOut();
    } catch (_) {
    } finally {
      _registeredToken = null;
    }
  }
}
