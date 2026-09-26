import '../../../auth/domain/entities/user.dart';
import '../repositories/user_management_repository.dart';

class GetPendingUsers {
  final UserManagementRepository repository;

  GetPendingUsers(this.repository);

  Future<List<User>> call() => repository.getPendingUsers();
}
