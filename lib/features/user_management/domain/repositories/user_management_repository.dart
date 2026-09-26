import '../../../auth/domain/entities/user.dart';

abstract class UserManagementRepository {
  /// Comptes ayant confirmé leur email mais pas encore validés par un admin.
  Future<List<User>> getPendingUsers();

  Future<bool> createUser({
    required String nom,
    required String prenom,
    required String matricule,
    required String telephone,
    required String numeroFlotte,
    required String email,
    required String password,
    required String structureCode,
    required String role,
  });

  Future<bool> approveUser(String login);
  Future<bool> rejectUser(String login);
}
