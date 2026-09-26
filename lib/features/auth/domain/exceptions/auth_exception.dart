/// Levée quand l'API d'authentification renvoie une erreur métier
/// (email déjà utilisé, identifiants incorrects, champs manquants, etc.)
class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => message;
}
