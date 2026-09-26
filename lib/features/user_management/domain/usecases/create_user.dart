import '../repositories/user_management_repository.dart';

class CreateUser {
  final UserManagementRepository repository;

  CreateUser(this.repository);

  Future<bool> call({
    required String nom,
    required String prenom,
    required String matricule,
    required String telephone,
    required String numeroFlotte,
    required String email,
    required String password,
    required String structureCode,
    required String role,
  }) {
    return repository.createUser(
      nom: nom,
      prenom: prenom,
      matricule: matricule,
      telephone: telephone,
      numeroFlotte: numeroFlotte,
      email: email,
      password: password,
      structureCode: structureCode,
      role: role,
    );
  }
}
