/// Abstraction sur `firebase_messaging`, pour rester testable (voir
/// [FirebaseAuthBridge]).
abstract class PushTokenProvider {
  /// Demande la permission puis renvoie le jeton de l'appareil, ou null si
  /// la permission est refusée ou le jeton indisponible.
  Future<String?> getToken();

  /// Émet un nouveau jeton chaque fois que Firebase le renouvelle (ex :
  /// réinstallation, changement d'identifiant d'instance).
  Stream<String> get onTokenRefresh;
}
