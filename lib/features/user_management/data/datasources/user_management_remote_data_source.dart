import '../../../../core/network/api_client.dart';
import '../../../auth/data/models/user_model.dart';

class UserManagementRemoteDataSource {
  /// Comptes dont l'email est confirmé et qui attendent la validation d'un
  /// administrateur. Lève une [ApiException] si le chargement échoue.
  Future<List<UserModel>> getPendingUsers() async {
    final data = await ApiClient.getList('/users');
    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  /// Active directement l'accès d'un agent DGI existant (identifiant = login)
  /// avec le mot de passe fourni. Les agents eux-mêmes viennent de la table
  /// `users` d'un autre système : le serveur ne crée jamais de nouvel agent.
  Future<bool> activateAgent({
    required String login,
    required String password,
  }) async {
    try {
      await ApiClient.post(
        '/users/activate-direct',
        body: {'login': login, 'password': password},
      );
      return true;
    } on ApiException {
      return false;
    }
  }

  Future<bool> approveUser(String login) => _decide(login, 'approve');

  Future<bool> rejectUser(String login) => _decide(login, 'reject');

  Future<bool> _decide(String login, String action) async {
    try {
      await ApiClient.post('/users/${Uri.encodeComponent(login)}/$action');
      return true;
    } on ApiException {
      return false;
    }
  }
}
