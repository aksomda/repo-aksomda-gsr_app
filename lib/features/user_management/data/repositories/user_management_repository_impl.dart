import '../../../auth/domain/entities/user.dart';
import '../../domain/repositories/user_management_repository.dart';
import '../datasources/user_management_remote_data_source.dart';

class UserManagementRepositoryImpl implements UserManagementRepository {
  final UserManagementRemoteDataSource remoteDataSource;

  UserManagementRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<User>> getPendingUsers() => remoteDataSource.getPendingUsers();

  @override
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
  }) {
    // Seuls l'identifiant (matricule = users.login) et le mot de passe sont
    // utiles au serveur : le reste du profil vient de la base DGI.
    return remoteDataSource.activateAgent(login: matricule, password: password);
  }

  @override
  Future<bool> approveUser(String login) => remoteDataSource.approveUser(login);

  @override
  Future<bool> rejectUser(String login) => remoteDataSource.rejectUser(login);
}
