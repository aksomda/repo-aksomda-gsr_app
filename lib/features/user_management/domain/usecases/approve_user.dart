import '../repositories/user_management_repository.dart';

class ApproveUser {
  final UserManagementRepository repository;

  ApproveUser(this.repository);

  Future<bool> call(String login) => repository.approveUser(login);
}
