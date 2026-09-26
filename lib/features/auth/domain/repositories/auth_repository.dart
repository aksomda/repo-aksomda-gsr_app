import '../entities/auth_result.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<AuthResult> register({
    required String nom,
    required String prenom,
    required String matricule,
    required String telephone,
    required String numeroFlotte,
    required String email,
    required String password,
    required String structureCode,
  });

  Future<AuthResult> login({required String email, required String password});

  /// Restaure le profil associé à un token JWT stocké localement. Renvoie
  /// null si le token n'est plus valide.
  Future<User?> restoreSession(String token);
}
