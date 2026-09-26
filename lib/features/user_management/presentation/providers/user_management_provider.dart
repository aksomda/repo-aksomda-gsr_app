import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/usecases/approve_user.dart';
import '../../domain/usecases/create_user.dart';
import '../../domain/usecases/get_pending_users.dart';
import '../../domain/usecases/reject_user.dart';

class UserManagementProvider with ChangeNotifier {
  final GetPendingUsers getPendingUsersUseCase;
  final CreateUser createUserUseCase;
  final ApproveUser approveUserUseCase;
  final RejectUser rejectUserUseCase;

  UserManagementProvider({
    required this.getPendingUsersUseCase,
    required this.createUserUseCase,
    required this.approveUserUseCase,
    required this.rejectUserUseCase,
  });

  List<User> _pendingUsers = [];
  bool _isLoading = false;
  String? _error;

  List<User> get pendingUsers => _pendingUsers;
  bool get isLoading => _isLoading;

  /// Message de la dernière erreur de chargement, null si tout va bien.
  String? get error => _error;

  Future<void> fetchPendingUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _pendingUsers = await getPendingUsersUseCase();
    } catch (e) {
      _error = errorMessageOf(e);
    }
    _isLoading = false;
    notifyListeners();
  }

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
  }) async {
    return createUserUseCase(
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

  /// [login] : identifiant DGI du compte (users.login).
  Future<bool> approve(String login) async {
    final success = await approveUserUseCase(login);
    if (success) await fetchPendingUsers();
    return success;
  }

  Future<bool> reject(String login) async {
    final success = await rejectUserUseCase(login);
    if (success) await fetchPendingUsers();
    return success;
  }
}
