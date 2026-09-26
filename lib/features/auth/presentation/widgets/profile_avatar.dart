import 'package:flutter/material.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/network/session.dart';
import '../../domain/entities/user.dart';

/// Avatar de [user] : la photo servie par l'API (`GET /profile/photo/:login`,
/// voir server/controllers/profileController.js) si elle existe, sinon une
/// icône par défaut. [photoUpdatedAt] sert d'anti-cache : l'URL change à
/// chaque envoi, pour que l'image affichée se rafraîchisse immédiatement.
class ProfileAvatar extends StatelessWidget {
  final User user;
  final double radius;

  const ProfileAvatar({super.key, required this.user, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    if (!user.hasPhoto || user.login == null) {
      return CircleAvatar(radius: radius, child: const Icon(Icons.person));
    }
    final version = user.photoUpdatedAt?.millisecondsSinceEpoch ?? 0;
    final url = '${ApiConfig.baseUrl}/profile/photo/${user.login}?v=$version';
    return CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(url, headers: Session.authHeaders),
      onBackgroundImageError: (_, _) {},
    );
  }
}
