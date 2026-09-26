import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<AuthResult> call({
    required String nom,
    required String prenom,
    required String matricule,
    required String telephone,
    required String numeroFlotte,
    required String email,
    required String password,
    required String structureCode,
  }) {
    return repository.register(
      nom: nom,
      prenom: prenom,
      matricule: matricule,
      telephone: telephone,
      numeroFlotte: numeroFlotte,
      email: email,
      password: password,
      structureCode: structureCode,
    );
  }
}
