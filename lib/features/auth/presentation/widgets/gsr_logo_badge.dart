import 'package:flutter/material.dart';

/// Badge circulaire "salle de réunion" réutilisé sur les écrans
/// d'authentification (web et mobile), pour éviter de dupliquer ce décor.
class GsrLogoBadge extends StatelessWidget {
  final double size;
  final Color background;
  final Color iconColor;

  const GsrLogoBadge({
    super.key,
    this.size = 72,
    this.background = Colors.white,
    this.iconColor = const Color(0xFF1B8A5A),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(Icons.groups_rounded, size: size * 0.52, color: iconColor),
    );
  }
}
