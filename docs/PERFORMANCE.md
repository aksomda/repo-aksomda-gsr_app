# Performance et taille

Ce document sépare ce qui a été **mesuré** de ce qui reste à **mesurer sur un
appareil** (démarrage, mémoire, fluidité) : ces chiffres ne peuvent pas être
déduits du code et ne sont pas inventés ici.

## Mesuré (build release Android, arm64)

| Indicateur | Valeur | Commande |
|---|---|---|
| APK release arm64 | **19,5 Mo** | `flutter build apk --release --analyze-size --target-platform android-arm64` |
| AAB (toutes architectures) | 53,5 Mo | `flutter build appbundle --release` |
| Code Dart (AOT) | ≈ 7 Mo, dont `package:gsr_app` 312 Ko | rapport `--analyze-size` |
| Moteur Flutter + bibliothèques natives | ≈ 18 Mo (`lib/arm64-v8a`) | idem |
| Ressources (`flutter_assets`) | 229 Ko | idem |
| Polices d'icônes | 1,6 Mo → 9 Ko (tree-shaking) | automatique en release |

Détail de la taille : `dart devtools --appSizeBase=<fichier json généré par --analyze-size>`.

Le Play Store distribue un APK par architecture à partir de l'AAB : l'utilisateur
télécharge donc environ 20 Mo, pas 53.

## Choix ayant un effet sur la performance

- **Réseau** : un seul client HTTP, délai maximal de 15 s, pas de requête en
  double au démarrage ; les listes de salles, catégories et directions sont
  chargées une fois à l'ouverture de la session.
- **Pagination** : les réservations (liste admin et liste personnelle) et les
  notifications sont paginées côté serveur (`?limit=&offset=`, 50 par défaut,
  200 maximum, en-tête `X-Has-More`) ; l'application charge la page suivante
  à la demande (« Charger plus »).
- **Démarrage hors ligne** : le dernier profil connu est conservé dans le
  stockage sécurisé, l'application s'ouvre sans attendre le réseau si le
  serveur est injoignable.
- **Base de données** : requêtes paramétrées, index sur les colonnes de
  filtrage des réservations, contrôle des chevauchements dans une transaction.
- **Interface** : `const` systématique quand c'est possible, listes en
  `ListView.builder` (construction à la demande), graphiques dessinés par
  `fl_chart` (162 Ko).

## À mesurer sur un appareil (procédure)

Ces mesures exigent un téléphone Android réel en mode **profile** (jamais en
debug, dont les chiffres sont sans valeur).

1. **Temps de démarrage**
   ```bash
   flutter run --profile --trace-startup -d <appareil> \
     --dart-define=API_BASE_URL=https://api.votre-domaine.bf/api/gsr
   ```
   Le fichier `build/start_up_info.json` donne `timeToFirstFrameMicros` et
   `timeToFrameworkInitMicros`.
2. **Mémoire** — après connexion et ouverture de l'accueil :
   ```bash
   adb shell dumpsys meminfo bf.dgi.gsrapp
   ```
   Relever `TOTAL PSS`. Puis, dans Flutter DevTools (onglet *Memory*), prendre
   une capture avant/après 20 allers-retours entre les écrans pour repérer une
   fuite.
3. **Fluidité** — DevTools, onglet *Performance* : parcourir la liste des
   réservations (charger 3 pages) et le tableau de bord ; aucune image ne doit
   dépasser 16 ms en profile.
4. **Reconstructions inutiles** — DevTools, *Widget rebuild stats* sur le
   tableau de bord.

| Mesure | Résultat | Appareil | Date |
|---|---|---|---|
| Premier affichage (`timeToFirstFrame`) | à mesurer | | |
| Mémoire (TOTAL PSS) à l'accueil | à mesurer | | |
| 90ᵉ percentile de durée d'image (liste) | à mesurer | | |

Les captures de DevTools correspondantes se placent dans `docs/screenshots/`
et se référencent depuis le README.
