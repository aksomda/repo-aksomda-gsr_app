# GsrApp — Gestion des Salles de Réunion et des Réservations

![CI](https://github.com/aksomda/gsr_app/actions/workflows/ci.yml/badge.svg)
![Flutter](https://img.shields.io/badge/Flutter-stable-blue)

Application Flutter (Android, web, bureau) de gestion des salles de réunion de
la Direction Générale des Impôts du Burkina Faso, avec son API Node.js/Express
et sa base MySQL (`server/`).

## Sommaire

- [GsrApp — Gestion des Salles de Réunion et des Réservations](#gsrapp--gestion-des-salles-de-réunion-et-des-réservations)
  - [Sommaire](#sommaire)
  - [Fonctionnalités](#fonctionnalités)
  - [Architecture](#architecture)
  - [Prérequis](#prérequis)
  - [Installation et configuration](#installation-et-configuration)
  - [Lancer en développement](#lancer-en-développement)
  - [Tests](#tests)
  - [Build de production](#build-de-production)
  - [Performance](#performance)
  - [Sécurité](#sécurité)

## Fonctionnalités

| Domaine | Ce que fait l'application |
|---|---|
| **Accueil** | Tableau de bord : indicateurs clés et graphiques (salles par statut, réservations par statut, salles les plus demandées, réservations par direction régionale). |
| **Salles** | Liste filtrable par statut ; l'admin crée / modifie / supprime (nom, localisation, catégorie, direction régionale, statut, tarif, équipement informatique). |
| **Catégories** | Catégories gratuites ou en location, avec montant. |
| **Réservations** | L'agent demande une salle sur un créneau libre ; l'admin valide ou rejette (avec motif). Le serveur refuse les chevauchements dans une transaction verrouillée. |
| **Comptes** | Inscription d'un agent DGI existant → confirmation par e-mail → validation par un administrateur. L'admin peut aussi activer directement un agent. |
| **Messagerie** | Agent ↔ administration ; l'admin peut écrire à un agent (« Nouveau message »). |
| **Notifications** | Rafraîchies toutes les 20 s, marquage comme lues. |
| **Statistiques** | Demandes par statut, salles les plus demandées, fréquentation par direction régionale. |
| **Paramètres** | Profil, test de connexion API/MySQL, langue (français, English, Русский, 中文), mode sombre, version, déconnexion. |

Robustesse : délai maximal de 15 s sur chaque appel, erreurs réseau distinguées
des listes vides (message + bouton « Réessayer »), fermeture automatique de la
session si le jeton expire, **démarrage hors ligne** (le dernier profil connu est
conservé dans le stockage sécurisé : un serveur injoignable ne déconnecte plus),
**pagination** des réservations et des notifications (50 par page, « Charger plus »).

## Architecture

Organisation *feature-first*, inspirée de la Clean Architecture :

```
lib/
├── main.dart                 composition des dépendances (providers), thème, langue
├── core/
│   ├── config/               ApiConfig (API_BASE_URL, garde de configuration release)
│   ├── network/              ApiClient (timeout, erreurs typées, 401), Session (jeton sécurisé)
│   ├── settings/             préférences : thème, langue (persistées)
│   ├── theme/ widgets/       charte graphique, composants réutilisables (recherche, erreur/relance)
├── l10n/                     traductions ARB (fr, en, ru, zh) + accès `context.l10n`
├── screens/                  navigation principale, paramètres
└── features/<feature>/
    ├── domain/               entités, contrats de dépôt, cas d'usage
    ├── data/                 sources de données HTTP, modèles JSON, dépôts
    └── presentation/         providers (ChangeNotifier), écrans, widgets

server/
├── app.js / server.js        Express, helmet, CORS, limitation de débit, audit
├── routes/ controllers/      une route → un contrôleur
├── middlewares/              authenticate (JWT), requireRole
├── services/                 e-mail, notifications, journal d'activité
├── config/                   base de données, contrôles de configuration production
├── sql/                      migrations 001 → 007 (voir sql/README.md)
└── tests/                    Jest + Supertest
```

Flux d'une donnée : `Écran → Provider → UseCase → Repository → DataSource → ApiClient → API`.
Les tables `users` et `ref_structure` appartiennent à un autre système (intranet
DGI) : l'application les lit mais n'y ajoute jamais de colonne.

## Prérequis

- Flutter (canal stable, Dart ≥ 3.12) — `flutter doctor` sans erreur
- Node.js ≥ 20 et MySQL 8
- Android : JDK 17 (build), et pour Windows bureau le composant Visual Studio
  « C++ ATL » (requis par `flutter_secure_storage`)

## Installation et configuration

```bash
# 1. Client
flutter pub get

# 2. Serveur
cd server
npm ci
cp .env.example .env        # puis renseigner les valeurs (jamais versionné)
```

Dans `server/.env` : accès MySQL, `JWT_SECRET` (chaîne aléatoire ≥ 32 caractères),
`APP_BASE_URL`, `ALLOWED_ORIGIN` (CORS, web uniquement) et SMTP pour l'e-mail
d'activation (vide en développement : le lien est affiché dans la console).

Base de données : exécuter dans l'ordre les fichiers `server/sql/001_…` à
`007_…` (détails et conventions dans `server/sql/README.md`).

## Lancer en développement

```bash
# API (port 3000)
cd server && npm start

# Application
flutter run -d chrome                      # web : API sur http://localhost:3000
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api/gsr   # émulateur Android
```

L'URL de l'API se règle uniquement par `--dart-define=API_BASE_URL=…`.

## Tests

```bash
flutter analyze --fatal-infos           # analyse statique (0 problème attendu)
flutter test --coverage                 # unitaires + widgets (136 tests, ≈ 80 % de couverture)
xvfb-run flutter test integration_test -d linux   # intégration (appareil requis)
cd server && npm test                   # API : 70 tests
```

Les scénarios d'intégration (`integration_test/`) tournent sur un appareil ;
pour les exécuter sur la machine de développement sans appareil, copiez le
fichier dans `test/` en adaptant l'import de `helpers/fakes.dart` puis
`flutter test <fichier>`. Sur Android, `flutter test integration_test` installe
l'application sur le téléphone connecté ; relancez ensuite un `flutter build`
(le registre de plugins est régénéré) avant de produire une version release.

La CI (`.github/workflows/ci.yml`) exécute : formatage, analyse, tests avec seuil
de couverture (70 %, code généré exclu), tests d'intégration sous Linux, build
APK release et tests du serveur.

## Build de production

1. **Signature** — créer un keystore (une seule fois, à conserver) :
   ```bash
   keytool -genkey -v -keystore gsrapp-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias gsrapp
   ```
   puis copier `android/key.properties.example` en `android/key.properties`
   (ignoré par Git) et le remplir. Sans ce fichier, le build release est **refusé**
   (`ALLOW_DEBUG_SIGNING=1` autorise un essai local non distribuable).
2. **Version** — modifier `version: X.Y.Z+N` dans `pubspec.yaml` (nom + numéro de build).
3. **Build** :
   ```bash
   flutter build apk --release --dart-define=API_BASE_URL=https://api.votre-domaine.bf/api/gsr
   flutter build appbundle --release --dart-define=API_BASE_URL=https://api.votre-domaine.bf/api/gsr
   ```
   L'application refuse de démarrer en release si `API_BASE_URL` n'est pas en
   `https` ou pointe sur une adresse locale.
4. **Serveur** — démarrer avec `NODE_ENV=production` : le serveur refuse de
   démarrer si `JWT_SECRET` est faible, si `ALLOWED_ORIGIN` est absent ou si
   `APP_BASE_URL` n'est pas en `https`.

Identifiant d'application Android : `bf.dgi.gsrapp`.

## Performance

Taille mesurée : APK arm64 release **19,5 Mo** (AAB 53,5 Mo, distribué par
architecture). Le détail, les choix de performance et la procédure de mesure du
démarrage et de la mémoire sur appareil (Flutter DevTools) sont dans
[`docs/PERFORMANCE.md`](docs/PERFORMANCE.md) ; les mesures sur appareil restent
à faire.

## Sécurité

- Jeton JWT (8 h) conservé dans le stockage sécurisé de la plateforme (Keychain / Keystore).
- Autorisations vérifiées **côté serveur** (`authenticate`, `requireRole('admin')`) ;
  un 401 ferme la session côté client.
- `helmet`, limitation des tentatives de connexion/inscription, journal d'activité,
  requêtes SQL paramétrées, comparaison de mots de passe en temps constant.
- Aucun secret dans le dépôt : `server/.env` et `android/key.properties` sont ignorés.
- CORS fermé par défaut en production.