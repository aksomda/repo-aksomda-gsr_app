# Changelog

Toutes les modifications notables de ce projet sont documentées dans ce
fichier. Le format suit [Keep a Changelog](https://keepachangelog.com/fr/1.1.0/)
et le projet suit [Semantic Versioning](https://semver.org/lang/fr/).

## [1.1.0] - 2026-09-13

### Corrigé
- Consolidation du projet en un seul module Flutter à la racine du dépôt
  (l'ancien dossier `client/` contenait le vrai code applicatif alors que la
  racine ne comportait aucun `lib/`, cassant `flutter analyze`/`flutter test`).
- Import erroné dans `main.dart` (`presentation/providers/room_provider.dart`
  au lieu de `presentation/bloc/providers/room_provider.dart`).
- Alias d'import invalide `import '...category_room.dart' as Icons;` dans
  `CategoryRoomsScreen`, qui masquait les vraies icônes Material et référençait
  un membre `Icons.categoryRoom` inexistant.
- Écran `MainNavigationScreen` (5 onglets) implémenté mais jamais monté dans
  `main.dart` : l'application ne montrait qu'un seul écran (`RoomsScreen`).
- `localizationsDelegates` / `supportedLocales` absents de `MaterialApp` :
  les fichiers `AppLocalizations` FR/EN existaient mais n'étaient pas actifs.
- Fonctionnalité "Réservations" incomplète : entité, dépôt, source de données
  et provider manquants pour `ReservationRoomsScreen`.
- Utilisation de `Color.withOpacity` (déprécié) remplacée par `withValues`.
- Suppression du code mort (`api_service.dart`, méthode `Room.fromJson` stub
  non implémentée, fichiers de widgets vides).
- Suite de tests à la racine (`test/unit_test.dart`, `test/widget_test.dart`)
  qui référençait un package `gsr_app` inexistant : remplacée par une suite
  cohérente avec le code réel.

### Ajouté
- Clé de traduction `categories` (FR/EN) et branchement de
  `AppLocalizations` dans la barre de navigation.
- 16 tests unitaires (`test/unit/`) couvrant modèles et providers.
- 8 tests de widgets (`test/widget/`) couvrant les 5 écrans.
- 2 scénarios de tests d'intégration (`integration_test/app_test.dart`)
  couvrant le démarrage et la navigation complète entre les 5 onglets.
- Étapes `dart format`, `flutter test integration_test` et publication du
  rapport de couverture dans le workflow CI.

## [1.0.1] - 2026-08-30

### Ajouté
- Écran Statistiques (`StatisticRoomsScreen`) avec filtres par mois/région,
  cartes chiffrées et histogramme de fréquentation par structure.
- Migration de `RoomsScreen` et `CategoryRoomsScreen` vers `flutter_hooks`
  pour réduire les rebuilds inutiles.

### Corrigé
- Annotations `Semantics` ajoutées sur les icônes de statut des salles et
  catégories pour l'accessibilité.

## [1.0.0] - 2026-08-15

### Ajouté
- Version initiale de GsrApp : gestion des salles de réunion (CRUD via API
  Node.js/MySQL) et gestion des catégories tarifaires.
- Architecture en couches `data` / `domain` / `presentation` par
  fonctionnalité (`features/rooms`, `features/categories_rooms`).
- Écran de réservation des salles avec suivi par état de traitement.
