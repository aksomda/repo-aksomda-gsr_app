import 'package:flutter/material.dart';

/// Bouton menu ouvrant le [Drawer] de l'écran courant. À placer dans les
/// `actions` d'un [AppBar] dont le `leading` affiche déjà le bouton retour
/// automatique (écran poussé), pour garder le tiroir accessible partout.
class DrawerMenuButton extends StatelessWidget {
  const DrawerMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      onPressed: () => Scaffold.of(context).openDrawer(),
    );
  }
}
