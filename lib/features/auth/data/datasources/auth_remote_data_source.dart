import 'dart:convert';

import '../../../../core/network/api_client.dart';
import '../../../../l10n/l10n_extensions.dart';
import '../../domain/exceptions/auth_exception.dart';
import '../models/user_model.dart';

/// Jeton + profil renvoyés par une connexion réussie.
class LoginSession {
  final String token;
  final UserModel user;

  /// Voir [AuthResult.firebaseToken].
  final String? firebaseToken;

  LoginSession(this.token, this.user, {this.firebaseToken});
}

class AuthRemoteDataSource {
  /// Inscription : le compte reste inactif tant que l'email n'est pas
  /// confirmé et qu'un administrateur ne l'a pas validé. Renvoie le message
  /// affiché à l'utilisateur (pas de session ouverte).
  Future<String> register({
    required String nom,
    required String prenom,
    required String matricule,
    required String telephone,
    required String numeroFlotte,
    required String email,
    required String password,
    required String structureCode,
  }) async {
    final body = await _post('/auth/register', {
      'nom': nom,
      'prenom': prenom,
      'login': matricule,
      'telephone': telephone,
      'numero_flotte': numeroFlotte,
      'email': email,
      'password': password,
      'structure_code': structureCode,
    });
    return body['message']?.toString() ?? AppLocale.l10n.accountCreatedSuccess;
  }

  Future<LoginSession> login({
    required String email,
    required String password,
  }) async {
    // `email` porte ici l'identifiant saisi (matricule = users.login).
    final body = await _post('/auth/login', {
      'login': email,
      'password': password,
    });
    return LoginSession(
      body['token'] as String,
      UserModel.fromJson(body['user'] as Map<String, dynamic>),
      firebaseToken: body['firebaseToken']?.toString(),
    );
  }

  /// Profil de l'utilisateur d'après le jeton courant (voir Session).
  /// Lève une [ApiException] : statut 401/403 si le jeton n'est plus valide,
  /// sans statut si le serveur est injoignable.
  Future<UserModel> getMe() async {
    final response = await ApiClient.get('/auth/me');
    return UserModel.fromJson(
      json.decode(response.body) as Map<String, dynamic>,
    );
  }

  /// POST non authentifié : renvoie le corps JSON d'une réponse 2xx, ou lève
  /// une [AuthException] portant le message d'erreur du serveur.
  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await ApiClient.post(path, body: payload, auth: false);
      return json.decode(response.body) as Map<String, dynamic>;
    } on ApiException catch (e) {
      throw AuthException(e.message);
    }
  }
}
