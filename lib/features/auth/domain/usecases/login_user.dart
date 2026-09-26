import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<AuthResult> call({required String email, required String password}) {
    return repository.login(email: email, password: password);
  }
}
