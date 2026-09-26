/// Photo de profil de l'utilisateur connecté. MySQL est le stockage
/// principal (voir server/controllers/profileController.js) ; le miroir
/// Firebase Storage est un détail d'implémentation côté serveur, invisible
/// ici.
abstract class ProfileRepository {
  Future<bool> uploadPhoto({
    required List<int> bytes,
    required String filename,
    required String contentType,
  });

  Future<bool> deletePhoto();
}
