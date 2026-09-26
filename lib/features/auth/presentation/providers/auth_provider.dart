import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../core/firebase/firebase_sync.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/session.dart';
import '../../../../l10n/l10n_extensions.dart';
import '../../../../core/storage/profile_cache.dart';
import '../../data/models/user_model.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/delete_profile_photo.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/usecases/restore_session.dart';
import '../../domain/usecases/upload_profile_photo.dart';

class AuthProvider with ChangeNotifier {
  final LoginUser loginUseCase;
  final RegisterUser registerUseCase;
  final RestoreSession? restoreSessionUseCase;
  final UploadProfilePhoto? uploadProfilePhotoUseCase;
  final DeleteProfilePhoto? deleteProfilePhotoUseCase;

  AuthProvider({
    required this.loginUseCase,
    required this.registerUseCase,
    this.restoreSessionUseCase,
    this.uploadProfilePhotoUseCase,
    this.deleteProfilePhotoUseCase,
  }) {
    // Un 401 sur un appel authentifié signifie que le jeton a expiré ou a été
    // révoqué : on ferme la session et on revient à l'écran de connexion.
    ApiClient.onUnauthorized = _onSessionExpired;
  }

  User? _currentUser;
  bool _isLoading = false;
  bool _isRestoring = false;
  String? _errorMessage;
  String? _infoMessage;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  bool get isRestoring => _isRestoring;
  String? get errorMessage => _errorMessage;
  String? get infoMessage => _infoMessage;

  /// À appeler au démarrage de l'app : si un token a été restauré depuis le
  /// stockage local (voir Session.restore(), appelé dans main()), vérifie
  /// qu'il est toujours valide et recharge l'utilisateur correspondant.
  Future<void> tryRestoreSession() async {
    final token = Session.token;
    if (token == null || restoreSessionUseCase == null) return;

    _isRestoring = true;
    notifyListeners();

    final user = await restoreSessionUseCase!(token);
    if (user == null) {
      await Session.clear();
    } else {
      _currentUser = user;
      // Best effort, non bloquant : réenregistre le jeton push de
      // l'appareil (la session Firebase Auth déjà ouverte, s'il y en a une,
      // est conservée par son propre SDK — voir FirebaseSync.onLogin).
      unawaited(FirebaseSync.onLogin(null));
    }

    _isRestoring = false;
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await loginUseCase(email: email, password: password);

    _isLoading = false;
    if (result.success) {
      _currentUser = result.user;
      if (result.token != null) {
        await Session.save(result.token!);
      }
      // Best effort, non bloquant : une éventuelle invite système de
      // permission de notifications ne doit pas retarder l'affichage.
      unawaited(FirebaseSync.onLogin(result.firebaseToken));
      notifyListeners();
      return true;
    }
    _errorMessage = result.errorMessage;
    notifyListeners();
    return false;
  }

  Future<bool> register({
    required String nom,
    required String prenom,
    required String matricule,
    required String telephone,
    required String numeroFlotte,
    required String email,
    required String password,
    required String structureCode,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await registerUseCase(
      nom: nom,
      prenom: prenom,
      matricule: matricule,
      telephone: telephone,
      numeroFlotte: numeroFlotte,
      email: email,
      password: password,
      structureCode: structureCode,
    );

    _isLoading = false;
    if (result.success) {
      _infoMessage = result.message;
      notifyListeners();
      return true;
    }
    _errorMessage = result.errorMessage;
    notifyListeners();
    return false;
  }

  Future<void> _onSessionExpired() async {
    if (_currentUser == null) return;
    _currentUser = null;
    _errorMessage = AppLocale.l10n.errSessionExpired;
    notifyListeners();
    await Session.clear();
    await FirebaseSync.onLogout();
  }

  Future<void> logout() async {
    _currentUser = null;
    _errorMessage = null;
    await Session.clear();
    await FirebaseSync.onLogout();
    notifyListeners();
  }

  /// Envoie une nouvelle photo de profil pour l'utilisateur connecté (MySQL
  /// = stockage principal, miroir Firebase Storage best-effort côté
  /// serveur). Met à jour [currentUser] et le cache hors ligne en cas de
  /// succès.
  Future<bool> uploadProfilePhoto({
    required List<int> bytes,
    required String filename,
    required String contentType,
  }) async {
    if (uploadProfilePhotoUseCase == null || _currentUser == null) return false;
    final success = await uploadProfilePhotoUseCase!(
      bytes: bytes,
      filename: filename,
      contentType: contentType,
    );
    if (success) {
      _currentUser = _currentUser!.withPhotoUpdated(DateTime.now());
      await ProfileCache.save(UserModel.fromEntity(_currentUser!).toJson());
      notifyListeners();
    }
    return success;
  }

  Future<bool> deleteProfilePhoto() async {
    if (deleteProfilePhotoUseCase == null || _currentUser == null) return false;
    final success = await deleteProfilePhotoUseCase!();
    if (success) {
      _currentUser = _currentUser!.withoutPhoto();
      await ProfileCache.save(UserModel.fromEntity(_currentUser!).toJson());
      notifyListeners();
    }
    return success;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearInfo() {
    _infoMessage = null;
    notifyListeners();
  }

  /// Réservé aux tests : impose un utilisateur courant sans passer par un
  /// appel réseau, pour vérifier l'affichage conditionnel par rôle.
  @visibleForTesting
  void debugSetUser(User user) {
    _currentUser = user;
    notifyListeners();
  }
}
