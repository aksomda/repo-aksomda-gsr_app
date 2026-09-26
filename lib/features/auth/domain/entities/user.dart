class User {
  final int? id;
  final String? login;
  final String nom;
  final String prenom;
  final String matricule;
  final String telephone;
  final String? numeroFlotte;
  final String email;
  final String? structureCode;
  final String? structureLibelle;
  final String role;
  final bool emailVerified;
  final bool isActive;

  /// MySQL (`user_profiles.photo_blob`) est le stockage principal de la
  /// photo de profil ; [photoUpdatedAt] sert uniquement à construire une URL
  /// anti-cache (voir `ProfileAvatar`, widget de présentation) et
  /// [firebasePhotoUrl] est le miroir Firebase Storage best-effort (peut
  /// rester null).
  final bool hasPhoto;
  final DateTime? photoUpdatedAt;
  final String? firebasePhotoUrl;

  User({
    this.id,
    this.login,
    required this.nom,
    required this.prenom,
    required this.matricule,
    required this.telephone,
    this.numeroFlotte,
    required this.email,
    this.structureCode,
    this.structureLibelle,
    this.role = 'agent',
    this.emailVerified = true,
    this.isActive = true,
    this.hasPhoto = false,
    this.photoUpdatedAt,
    this.firebasePhotoUrl,
  });

  String get nomComplet => '$prenom $nom';
  bool get isAdmin => role == 'admin';

  User _copy({required bool hasPhoto, DateTime? photoUpdatedAt, String? firebasePhotoUrl}) {
    return User(
      id: id,
      login: login,
      nom: nom,
      prenom: prenom,
      matricule: matricule,
      telephone: telephone,
      numeroFlotte: numeroFlotte,
      email: email,
      structureCode: structureCode,
      structureLibelle: structureLibelle,
      role: role,
      emailVerified: emailVerified,
      isActive: isActive,
      hasPhoto: hasPhoto,
      photoUpdatedAt: photoUpdatedAt,
      firebasePhotoUrl: firebasePhotoUrl,
    );
  }

  /// Après un envoi réussi (voir AuthProvider.uploadProfilePhoto). [at] sert
  /// uniquement à invalider le cache d'affichage de l'image (voir
  /// `ProfileAvatar`) ; le miroir Firebase, asynchrone côté serveur, n'est
  /// pas connu ici et repart à null.
  User withPhotoUpdated(DateTime at) => _copy(hasPhoto: true, photoUpdatedAt: at);

  /// Après une suppression réussie (voir AuthProvider.deleteProfilePhoto).
  User withoutPhoto() => _copy(hasPhoto: false);
}
