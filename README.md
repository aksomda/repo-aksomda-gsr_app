# GsrApp — Gestion des Salles de Réunion et des Réservations

![CI](https://github.com/aksomda/gsr_app/actions/workflows/ci.yml/badge.svg)
![Flutter](https://img.shields.io/badge/Flutter-stable-blue)
![License](https://img.shields.io/badge/license-MIT-lightgrey)

Application Flutter de gestion des salles de réunion : catalogue des salles,
catégories tarifaires, demandes de réservation et tableau de bord statistique.
Le projet suit une architecture *feature-first* inspirée de la Clean
Architecture (couches `data` / `domain` / `presentation`), avec un backend
Node.js/Express + MySQL fourni dans `server/`.

## Sommaire

- [Fonctionnalités](#fonctionnalités)
- [Architecture](#architecture)
- [Installation](#installation)
- [Lancer l'application](#lancer-lapplication)
- [Tests](#tests)
- [Internationalisation](#internationalisation)
- [Accessibilité](#accessibilité)
- [CI/CD](#cicd)
- [Captures d'écran](#captures-décran)

## Fonctionnalités

L'application comporte 5 écrans, accessibles depuis une barre de navigation
inférieure (`MainNavigationScreen`) :

| # | Écran | Description |
|---|-------|-------------|
| 1 | **Salles** | Liste des salles de réunion, filtrable par statut (disponible, réservée, en réfection, dégradée, en construction). |
| 2 | **Catégories** | Gestion des catégories de salles (gratuites / en location) avec montant de location. |
| 3 | **Réservations** | Suivi des demandes de réservation par état (en cours, traitées, rejetées). |
| 4 | **Statistiques** | Tableau de bord analytique filtrable par mois/région (cartes chiffrées + histogramme). |
| 5 | **Paramètres** | État de la connexion à l'API et informations sur l'application. |

Chaque salle/catégorie/réservation est persistée côté serveur (API REST
`server/`, MySQL) via `http`, et exposée à l'UI par le pattern
Repository + UseCase + `ChangeNotifier` (Provider).

## Architecture

```
lib/
├── main.dart                     # Point d'entrée, injection des dépendances
├── screens/
│   └── main_navigation_screen.dart   # Barre de navigation (5 onglets)
├── l10n/                         # Fichiers .arb + classes générées (FR/EN)
└── features/
    ├── rooms/
    │   ├── data/
    │   │   ├── datasources/      # Appels HTTP vers l'API
    │   │   ├── models/           # (De)sérialisation JSON
    │   │   └── repositories/     # Implémentation des interfaces domain
    │   ├── domain/
    │   │   ├── entities/         # Objets métier purs
    │   │   ├── repositories/     # Interfaces abstraites (testables)
    │   │   └── usecases/         # Un cas d'usage = une classe
    │   └── presentation/
    │       ├── bloc/providers/   # State management (ChangeNotifier)
    │       └── screens/
    ├── categories_rooms/         # Même structure que rooms/
    ├── reservations_rooms/       # Même structure que rooms/
    └── statistics/               # Écran auto-porté (flutter_hooks, sans provider)
```

Cette séparation en couches permet de tester la logique métier
(`domain`/`presentation`) sans dépendre du réseau : chaque `Repository` est
une interface abstraite, remplacée par un `Fake*Repository` en mémoire dans
les tests (`test/helpers/fakes.dart`).

## Installation

Prérequis : [Flutter SDK](https://docs.flutter.dev/get-started/install) (canal
stable), Dart ≥ 3.12.

```bash
git clone https://github.com/aksomda/gsr_app.git
cd gsr_app
flutter pub get
```

Le backend (optionnel pour explorer l'UI, nécessaire pour des données réelles)
se lance depuis `server/` :

```bash
cd server
npm install
node server.js
```

## Lancer l'application

```bash
flutter run
```

Sans backend actif, l'application démarre normalement : les appels réseau
échouent silencieusement et les listes s'affichent vides ("Aucune salle
enregistrée.", etc.) plutôt que de faire planter l'app.

## Tests

La suite de tests est répartie en trois niveaux :

```bash
flutter test                     # tests unitaires + widgets (test/)
flutter test integration_test    # tests d'intégration (parcours complet)
flutter test --coverage          # avec rapport de couverture (coverage/lcov.info)
```

| Type | Emplacement | Contenu |
|------|-------------|---------|
| Unitaires | `test/unit/` | Sérialisation des modèles (`RoomModel`, `CategoryRoomModel`, `ReservationRoomModel`), logique des providers (filtrage, chargement, ajout). |
| Widgets | `test/widget/` | Rendu de chaque écran (`RoomsScreen`, `CategoryRoomsScreen`, `ReservationRoomsScreen`, `StatisticRoomsScreen`, `MainNavigationScreen`) avec des dépôts factices. |
| Intégration | `integration_test/` | Démarrage complet de l'application + navigation entre les 5 onglets. |

Analyse statique :

```bash
flutter analyze
```

## Internationalisation

Support **Français / Anglais** via `flutter_localizations` + `intl`
(fichiers `.arb` dans `lib/l10n/`, régénérés par `flutter gen-l10n`). Les
libellés de la barre de navigation et les titres principaux utilisent
`AppLocalizations.of(context)`.

## Accessibilité

Les éléments interactifs et informatifs (icônes de statut, cartes de
réservation, barre de navigation) sont annotés avec des `Semantics(label:
...)` pour une lecture correcte par les lecteurs d'écran (TalkBack /
VoiceOver).

## CI/CD

Le workflow GitHub Actions (`.github/workflows/ci.yml`) exécute à chaque push
et pull request sur `main` :

1. `dart format --set-exit-if-changed` (formatage)
2. `flutter analyze --fatal-infos` (lint, zéro avertissement toléré)
3. `flutter test --coverage` (unitaires + widgets)
4. `flutter test integration_test` (intégration)
5. Publication du rapport de couverture en artefact

## Captures d'écran

*(à ajouter : `docs/screenshots/rooms.png`, `categories.png`,
`reservations.png`, `statistics.png`, `settings.png`)*

## Licence

MIT — voir [CHANGELOG.md](CHANGELOG.md) pour l'historique des versions.
