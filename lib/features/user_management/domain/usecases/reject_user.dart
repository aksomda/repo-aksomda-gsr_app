import '../repositories/user_management_repository.dart';

class RejectUser {
  final UserManagementRepository repository;

  RejectUser(this.repository);

  Future<bool> call(String login) => repository.rejectUser(login);
}
