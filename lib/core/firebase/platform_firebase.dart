import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_messaging/firebase_messaging.dart' as fb_msg;
import 'firebase_auth_bridge.dart';
import 'push_token_provider.dart';

/// Implémentations réelles (canal de plateforme) des abstractions
/// [FirebaseAuthBridge] et [PushTokenProvider], utilisées par défaut par
/// [FirebaseSync] en dehors des tests.
class PlatformFirebaseAuthBridge implements FirebaseAuthBridge {
  @override
  Future<void> signInWithCustomToken(String token) =>
      fb_auth.FirebaseAuth.instance.signInWithCustomToken(token);

  @override
  Future<void> signOut() => fb_auth.FirebaseAuth.instance.signOut();
}

class PlatformPushTokenProvider implements PushTokenProvider {
  @override
  Future<String?> getToken() async {
    final messaging = fb_msg.FirebaseMessaging.instance;
    final settings = await messaging.requestPermission();
    if (settings.authorizationStatus == fb_msg.AuthorizationStatus.denied) {
      return null;
    }
    return messaging.getToken();
  }

  @override
  Stream<String> get onTokenRefresh =>
      fb_msg.FirebaseMessaging.instance.onTokenRefresh;
}
