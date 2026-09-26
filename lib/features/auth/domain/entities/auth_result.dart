import 'user.dart';

/// Résultat d'une tentative d'inscription ou de connexion.
///
/// - Une connexion réussie porte un [user] et un [token] JWT.
/// - Une inscription réussie ne porte ni l'un ni l'autre : le compte reste
///   inactif tant que l'email n'est pas confirmé et qu'un administrateur ne
///   l'a pas validé (voir [message]).
class AuthResult {
  final bool success;
  final User? user;
  final String? token;

  /// Jeton personnalisé permettant d'ouvrir une session Firebase Auth
  /// synchronisée avec cette connexion MySQL ; null si Firebase n'est pas
  /// configuré côté serveur ou si la synchronisation a échoué (voir
  /// FirebaseSync.onLogin — cela ne bloque jamais la connexion gsr_app).
  final String? firebaseToken;
  final String? message;
  final String? errorMessage;

  const AuthResult.success(this.user, {this.token, this.firebaseToken})
    : success = true,
      message = null,
      errorMessage = null;

  const AuthResult.registered(this.message)
    : success = true,
      user = null,
      token = null,
      firebaseToken = null,
      errorMessage = null;

  const AuthResult.failure(this.errorMessage)
    : success = false,
      user = null,
      token = null,
      firebaseToken = null,
      message = null;
}
