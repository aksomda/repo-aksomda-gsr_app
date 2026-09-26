import '../../../../core/network/api_client.dart';
import '../../../../core/storage/profile_cache.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/entities/user.dart';
import '../../domain/exceptions/auth_exception.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';
import '../../../../l10n/l10n_extensions.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<AuthResult> register({
    required String nom,
    required String prenom,
    required String matricule,
    required String telephone,
    required String numeroFlotte,
    required String email,
    required String password,
    required String structureCode,
  }) async {
    try {
      final message = await remoteDataSource.register(
        nom: nom,
        prenom: prenom,
        matricule: matricule,
        telephone: telephone,
        numeroFlotte: numeroFlotte,
        email: email,
        password: password,
        structureCode: structureCode,
      );
      return AuthResult.registered(message);
    } on AuthException catch (e) {
      return AuthResult.failure(e.message);
    } catch (_) {
      return AuthResult.failure(AppLocale.l10n.errUnexpected);
    }
  }

  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final session = await remoteDataSource.login(
        email: email,
        password: password,
      );
      await ProfileCache.save(session.user.toJson());
      return AuthResult.success(
        session.user,
        token: session.token,
        firebaseToken: session.firebaseToken,
      );
    } on AuthException catch (e) {
      return AuthResult.failure(e.message);
    } catch (_) {
      return AuthResult.failure(AppLocale.l10n.errUnexpected);
    }
  }

  /// Rouvre la session d'après le jeton stocké :
  /// - serveur joignable : profil à jour (et mis en cache) ;
  /// - jeton refusé (401/403) : null, l'utilisateur doit se reconnecter ;
  /// - serveur injoignable ou en panne : dernier profil connu, pour que
  ///   l'application reste utilisable hors ligne au lieu de déconnecter.
  @override
  Future<User?> restoreSession(String token) async {
    try {
      final user = await remoteDataSource.getMe();
      await ProfileCache.save(user.toJson());
      return user;
    } on ApiException catch (e) {
      final rejected = e.statusCode == 401 || e.statusCode == 403;
      if (rejected) return null;
      final cached = await ProfileCache.load();
      return cached == null ? null : UserModel.fromJson(cached);
    }
  }
}
