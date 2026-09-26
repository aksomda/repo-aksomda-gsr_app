import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RestoreSession {
  final AuthRepository repository;

  RestoreSession(this.repository);

  Future<User?> call(String token) => repository.restoreSession(token);
}
