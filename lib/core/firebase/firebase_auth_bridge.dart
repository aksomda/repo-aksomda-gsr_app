/// Abstraction sur `firebase_auth`, pour rester testable sans dépendre du
/// canal de plateforme (voir [PlatformFirebaseAuthBridge] dans
/// `platform_firebase.dart`, remplaçable par une fausse implémentation dans
/// les tests unitaires de [FirebaseSync]).
abstract class FirebaseAuthBridge {
  Future<void> signInWithCustomToken(String token);
  Future<void> signOut();
}
