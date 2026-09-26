import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    super.id,
    super.login,
    required super.nom,
    required super.prenom,
    required super.matricule,
    required super.telephone,
    super.numeroFlotte,
    required super.email,
    super.structureCode,
    super.structureLibelle,
    super.role,
    super.emailVerified,
    super.isActive,
    super.hasPhoto,
    super.photoUpdatedAt,
    super.firebasePhotoUrl,
  });

  Map<String, dynamic> toJson() => {
    'login': login,
    'nom': nom,
    'prenom': prenom,
    'matricule': matricule,
    'telephone': telephone,
    'numeroFlotte': numeroFlotte,
    'email': email,
    'structureCode': structureCode,
    'structureLibelle': structureLibelle,
    'role': role,
    'emailVerified': emailVerified,
    'isActive': isActive,
    'hasPhoto': hasPhoto,
    'photoUpdatedAt': photoUpdatedAt?.toIso8601String(),
    'firebasePhotoUrl': firebasePhotoUrl,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      login: json['login']?.toString(),
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      matricule: json['matricule'] ?? '',
      telephone: json['telephone'] ?? '',
      numeroFlotte: json['numeroFlotte'],
      email: json['email'] ?? '',
      structureCode: json['structureCode'],
      structureLibelle: json['structureLibelle'],
      role: json['role'] ?? 'agent',
      emailVerified: json['emailVerified'] ?? true,
      isActive: json['isActive'] ?? true,
      hasPhoto: json['hasPhoto'] == true,
      photoUpdatedAt: json['photoUpdatedAt'] == null
          ? null
          : DateTime.tryParse(json['photoUpdatedAt'].toString()),
      firebasePhotoUrl: json['firebasePhotoUrl']?.toString(),
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      login: user.login,
      nom: user.nom,
      prenom: user.prenom,
      matricule: user.matricule,
      telephone: user.telephone,
      numeroFlotte: user.numeroFlotte,
      email: user.email,
      structureCode: user.structureCode,
      structureLibelle: user.structureLibelle,
      role: user.role,
      emailVerified: user.emailVerified,
      isActive: user.isActive,
      hasPhoto: user.hasPhoto,
      photoUpdatedAt: user.photoUpdatedAt,
      firebasePhotoUrl: user.firebasePhotoUrl,
    );
  }
}
