import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'GsrApp - Gestion des Salles de réunion et des Réservations'**
  String get appTitle;

  /// No description provided for @roomsList.
  ///
  /// In fr, this message translates to:
  /// **'Liste des Salles'**
  String get roomsList;

  /// No description provided for @categories.
  ///
  /// In fr, this message translates to:
  /// **'Catégories'**
  String get categories;

  /// No description provided for @reservations.
  ///
  /// In fr, this message translates to:
  /// **'Réservations'**
  String get reservations;

  /// No description provided for @statistics.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques'**
  String get statistics;

  /// No description provided for @settings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settings;

  /// No description provided for @available.
  ///
  /// In fr, this message translates to:
  /// **'Disponible'**
  String get available;

  /// No description provided for @reserved.
  ///
  /// In fr, this message translates to:
  /// **'Réservé'**
  String get reserved;

  /// No description provided for @refection.
  ///
  /// In fr, this message translates to:
  /// **'En réfection'**
  String get refection;

  /// No description provided for @degraded.
  ///
  /// In fr, this message translates to:
  /// **'Dégradé'**
  String get degraded;

  /// No description provided for @construction.
  ///
  /// In fr, this message translates to:
  /// **'En construction'**
  String get construction;

  /// No description provided for @free.
  ///
  /// In fr, this message translates to:
  /// **'Gratuit'**
  String get free;

  /// No description provided for @rental.
  ///
  /// In fr, this message translates to:
  /// **'En location'**
  String get rental;

  /// No description provided for @amount.
  ///
  /// In fr, this message translates to:
  /// **'Montant'**
  String get amount;

  /// No description provided for @computers.
  ///
  /// In fr, this message translates to:
  /// **'Ordinateurs'**
  String get computers;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get edit;

  /// No description provided for @close.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get close;

  /// No description provided for @create.
  ///
  /// In fr, this message translates to:
  /// **'Créer'**
  String get create;

  /// No description provided for @all.
  ///
  /// In fr, this message translates to:
  /// **'Toutes'**
  String get all;

  /// No description provided for @fieldRequired.
  ///
  /// In fr, this message translates to:
  /// **'Champ requis.'**
  String get fieldRequired;

  /// No description provided for @saveFailed.
  ///
  /// In fr, this message translates to:
  /// **'Échec de l\'enregistrement.'**
  String get saveFailed;

  /// No description provided for @searchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher...'**
  String get searchHint;

  /// No description provided for @clear.
  ///
  /// In fr, this message translates to:
  /// **'Effacer'**
  String get clear;

  /// No description provided for @noResults.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat.'**
  String get noResults;

  /// No description provided for @noOptions.
  ///
  /// In fr, this message translates to:
  /// **'Aucune option disponible.'**
  String get noOptions;

  /// No description provided for @noData.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée disponible.'**
  String get noData;

  /// No description provided for @notProvided.
  ///
  /// In fr, this message translates to:
  /// **'Non renseigné'**
  String get notProvided;

  /// No description provided for @confirmDeleteNamed.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer \"{name}\" ?'**
  String confirmDeleteNamed(String name);

  /// No description provided for @errServerUnreachable.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de joindre le serveur. Vérifiez votre connexion.'**
  String get errServerUnreachable;

  /// No description provided for @errUnexpected.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur inattendue est survenue.'**
  String get errUnexpected;

  /// No description provided for @errServerStatus.
  ///
  /// In fr, this message translates to:
  /// **'Erreur serveur ({code})'**
  String errServerStatus(String code);

  /// No description provided for @roomStatusAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Disponible'**
  String get roomStatusAvailable;

  /// No description provided for @roomStatusReserved.
  ///
  /// In fr, this message translates to:
  /// **'Réservée'**
  String get roomStatusReserved;

  /// No description provided for @roomStatusRefection.
  ///
  /// In fr, this message translates to:
  /// **'En réfection'**
  String get roomStatusRefection;

  /// No description provided for @roomStatusDegraded.
  ///
  /// In fr, this message translates to:
  /// **'Dégradée'**
  String get roomStatusDegraded;

  /// No description provided for @roomStatusConstruction.
  ///
  /// In fr, this message translates to:
  /// **'En construction'**
  String get roomStatusConstruction;

  /// No description provided for @tabAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Disponibles'**
  String get tabAvailable;

  /// No description provided for @tabReserved.
  ///
  /// In fr, this message translates to:
  /// **'Réservées'**
  String get tabReserved;

  /// No description provided for @tabRefection.
  ///
  /// In fr, this message translates to:
  /// **'Réfection'**
  String get tabRefection;

  /// No description provided for @tabDegraded.
  ///
  /// In fr, this message translates to:
  /// **'Dégradées'**
  String get tabDegraded;

  /// No description provided for @tabConstruction.
  ///
  /// In fr, this message translates to:
  /// **'Construction'**
  String get tabConstruction;

  /// No description provided for @resPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get resPending;

  /// No description provided for @resValidated.
  ///
  /// In fr, this message translates to:
  /// **'Validées'**
  String get resValidated;

  /// No description provided for @resRejected.
  ///
  /// In fr, this message translates to:
  /// **'Rejetées'**
  String get resRejected;

  /// No description provided for @roleAdmin.
  ///
  /// In fr, this message translates to:
  /// **'Administrateur'**
  String get roleAdmin;

  /// No description provided for @roleAgent.
  ///
  /// In fr, this message translates to:
  /// **'Agent'**
  String get roleAgent;

  /// No description provided for @home.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get home;

  /// No description provided for @userAccounts.
  ///
  /// In fr, this message translates to:
  /// **'Comptes utilisateurs'**
  String get userAccounts;

  /// No description provided for @regionalDirections.
  ///
  /// In fr, this message translates to:
  /// **'Directions régionales'**
  String get regionalDirections;

  /// No description provided for @structures.
  ///
  /// In fr, this message translates to:
  /// **'Structures'**
  String get structures;

  /// No description provided for @notifications.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @messaging.
  ///
  /// In fr, this message translates to:
  /// **'Messagerie'**
  String get messaging;

  /// No description provided for @logout.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment vous déconnecter ?'**
  String get logoutConfirm;

  /// No description provided for @loginForgotInfo.
  ///
  /// In fr, this message translates to:
  /// **'Contactez un administrateur pour réinitialiser votre mot de passe.'**
  String get loginForgotInfo;

  /// No description provided for @loginIdentifier.
  ///
  /// In fr, this message translates to:
  /// **'Email ou identifiant'**
  String get loginIdentifier;

  /// No description provided for @loginIdentifierRequired.
  ///
  /// In fr, this message translates to:
  /// **'L\'identifiant est requis.'**
  String get loginIdentifierRequired;

  /// No description provided for @password.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get password;

  /// No description provided for @showPassword.
  ///
  /// In fr, this message translates to:
  /// **'Afficher le mot de passe'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In fr, this message translates to:
  /// **'Masquer le mot de passe'**
  String get hidePassword;

  /// No description provided for @passwordRequired.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe est requis.'**
  String get passwordRequired;

  /// No description provided for @errorMessageLabel.
  ///
  /// In fr, this message translates to:
  /// **'Message d\'erreur'**
  String get errorMessageLabel;

  /// No description provided for @loginButtonLabel.
  ///
  /// In fr, this message translates to:
  /// **'Bouton se connecter'**
  String get loginButtonLabel;

  /// No description provided for @signIn.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get signIn;

  /// No description provided for @registerQuestion.
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire ?'**
  String get registerQuestion;

  /// No description provided for @forgotPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get forgotPassword;

  /// No description provided for @noAccountCreate.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ? Créer un compte'**
  String get noAccountCreate;

  /// No description provided for @dgiName.
  ///
  /// In fr, this message translates to:
  /// **'Direction Générale des Impôts du Burkina Faso'**
  String get dgiName;

  /// No description provided for @roomsManagementTitle.
  ///
  /// In fr, this message translates to:
  /// **'Gestion des Salles de Réunion'**
  String get roomsManagementTitle;

  /// No description provided for @roomsAndReservationsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Gestion des Salles de Réunion et des Réservations'**
  String get roomsAndReservationsTitle;

  /// No description provided for @loginWelcome.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous à votre espace'**
  String get loginWelcome;

  /// No description provided for @loginTagline.
  ///
  /// In fr, this message translates to:
  /// **'Réservez vos salles en toute simplicité'**
  String get loginTagline;

  /// No description provided for @createAccountButtonLabel.
  ///
  /// In fr, this message translates to:
  /// **'Bouton créer un compte'**
  String get createAccountButtonLabel;

  /// No description provided for @createAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get createAccount;

  /// No description provided for @footerInstitution.
  ///
  /// In fr, this message translates to:
  /// **'© {year} - Votre institution'**
  String footerInstitution(int year);

  /// No description provided for @fieldRequiredNamed.
  ///
  /// In fr, this message translates to:
  /// **'{label} est requis.'**
  String fieldRequiredNamed(String label);

  /// No description provided for @fieldSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Champ {label}'**
  String fieldSemantics(String label);

  /// No description provided for @registrationSent.
  ///
  /// In fr, this message translates to:
  /// **'Inscription envoyée'**
  String get registrationSent;

  /// No description provided for @accountCreatedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Compte créé avec succès.'**
  String get accountCreatedSuccess;

  /// No description provided for @lastName.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get lastName;

  /// No description provided for @firstName.
  ///
  /// In fr, this message translates to:
  /// **'Prénom'**
  String get firstName;

  /// No description provided for @matricule.
  ///
  /// In fr, this message translates to:
  /// **'Matricule'**
  String get matricule;

  /// No description provided for @phoneWhatsapp.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone (WhatsApp)'**
  String get phoneWhatsapp;

  /// No description provided for @fleetNumber.
  ///
  /// In fr, this message translates to:
  /// **'Numéro flotte'**
  String get fleetNumber;

  /// No description provided for @emailAddress.
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail'**
  String get emailAddress;

  /// No description provided for @emailRequired.
  ///
  /// In fr, this message translates to:
  /// **'L\'adresse e-mail est requise.'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail invalide.'**
  String get emailInvalid;

  /// No description provided for @passwordMin6.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit contenir au moins 8 caractères.'**
  String get passwordMin6;

  /// No description provided for @structureFieldLabel.
  ///
  /// In fr, this message translates to:
  /// **'Champ Structure'**
  String get structureFieldLabel;

  /// No description provided for @createAccountSubmitLabel.
  ///
  /// In fr, this message translates to:
  /// **'Bouton créer le compte'**
  String get createAccountSubmitLabel;

  /// No description provided for @createTheAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer le compte'**
  String get createTheAccount;

  /// No description provided for @categorySaved.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie enregistrée.'**
  String get categorySaved;

  /// No description provided for @deleteCategory.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la catégorie'**
  String get deleteCategory;

  /// No description provided for @categoriesManagementTitle.
  ///
  /// In fr, this message translates to:
  /// **'Gestion des catégories de salles de réunion'**
  String get categoriesManagementTitle;

  /// No description provided for @tabFree.
  ///
  /// In fr, this message translates to:
  /// **'Gratuites'**
  String get tabFree;

  /// No description provided for @tabRental.
  ///
  /// In fr, this message translates to:
  /// **'Location'**
  String get tabRental;

  /// No description provided for @noCategories.
  ///
  /// In fr, this message translates to:
  /// **'Aucune catégorie de salle de réunion enregistrée.'**
  String get noCategories;

  /// No description provided for @categoryIcon.
  ///
  /// In fr, this message translates to:
  /// **'Icône catégorie {name}'**
  String categoryIcon(String name);

  /// No description provided for @categoryFree.
  ///
  /// In fr, this message translates to:
  /// **'Gratuite'**
  String get categoryFree;

  /// No description provided for @categoryRentalAmount.
  ///
  /// In fr, this message translates to:
  /// **'Location - {amount} FCFA'**
  String categoryRentalAmount(String amount);

  /// No description provided for @inactiveSuffix.
  ///
  /// In fr, this message translates to:
  /// **' (inactive)'**
  String get inactiveSuffix;

  /// No description provided for @editCategory.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la catégorie'**
  String get editCategory;

  /// No description provided for @newCategory.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle catégorie'**
  String get newCategory;

  /// No description provided for @label.
  ///
  /// In fr, this message translates to:
  /// **'Libellé'**
  String get label;

  /// No description provided for @labelRequired.
  ///
  /// In fr, this message translates to:
  /// **'Le libellé est requis.'**
  String get labelRequired;

  /// No description provided for @type.
  ///
  /// In fr, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @rentalAmountFcfa.
  ///
  /// In fr, this message translates to:
  /// **'Montant de location (FCFA)'**
  String get rentalAmountFcfa;

  /// No description provided for @invalidAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant invalide.'**
  String get invalidAmount;

  /// No description provided for @active.
  ///
  /// In fr, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @newMessageChooseAgent.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau message : choisir un agent'**
  String get newMessageChooseAgent;

  /// No description provided for @newMessage.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau message'**
  String get newMessage;

  /// No description provided for @noAgentMessages.
  ///
  /// In fr, this message translates to:
  /// **'Aucun message d\'agent pour le moment.\nUtilisez « Nouveau message » pour écrire à un agent.'**
  String get noAgentMessages;

  /// No description provided for @messagingWithAdmin.
  ///
  /// In fr, this message translates to:
  /// **'Messagerie avec l\'administration'**
  String get messagingWithAdmin;

  /// No description provided for @noMessages.
  ///
  /// In fr, this message translates to:
  /// **'Aucun message pour le moment.'**
  String get noMessages;

  /// No description provided for @writeMessage.
  ///
  /// In fr, this message translates to:
  /// **'Écrire un message...'**
  String get writeMessage;

  /// No description provided for @dashRooms.
  ///
  /// In fr, this message translates to:
  /// **'Salles'**
  String get dashRooms;

  /// No description provided for @dashAvailableRooms.
  ///
  /// In fr, this message translates to:
  /// **'Salles disponibles'**
  String get dashAvailableRooms;

  /// No description provided for @dashValidationRate.
  ///
  /// In fr, this message translates to:
  /// **'Taux de validation'**
  String get dashValidationRate;

  /// No description provided for @dashRoomsByStatus.
  ///
  /// In fr, this message translates to:
  /// **'Salles par statut'**
  String get dashRoomsByStatus;

  /// No description provided for @dashReservationsByStatus.
  ///
  /// In fr, this message translates to:
  /// **'Réservations par statut'**
  String get dashReservationsByStatus;

  /// No description provided for @mostRequestedRooms.
  ///
  /// In fr, this message translates to:
  /// **'Salles les plus demandées'**
  String get mostRequestedRooms;

  /// No description provided for @dashReservationsByDirection.
  ///
  /// In fr, this message translates to:
  /// **'Réservations par direction régionale'**
  String get dashReservationsByDirection;

  /// No description provided for @welcome.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue'**
  String get welcome;

  /// No description provided for @helloName.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour, {name}'**
  String helloName(String name);

  /// No description provided for @dashSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Voici l\'activité de vos salles de réunion.'**
  String get dashSubtitle;

  /// No description provided for @noRegionalDirections.
  ///
  /// In fr, this message translates to:
  /// **'Aucune direction régionale trouvée.'**
  String get noRegionalDirections;

  /// No description provided for @noNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Aucune notification.'**
  String get noNotifications;

  /// No description provided for @structuresLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les structures. Touchez pour réessayer.'**
  String get structuresLoadError;

  /// No description provided for @editStructure.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la structure'**
  String get editStructure;

  /// No description provided for @newStructure.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle structure'**
  String get newStructure;

  /// No description provided for @codeCdi.
  ///
  /// In fr, this message translates to:
  /// **'Code CDI'**
  String get codeCdi;

  /// No description provided for @codeRequired.
  ///
  /// In fr, this message translates to:
  /// **'Le code est requis.'**
  String get codeRequired;

  /// No description provided for @noStructures.
  ///
  /// In fr, this message translates to:
  /// **'Aucune structure enregistrée.'**
  String get noStructures;

  /// No description provided for @structureRequired.
  ///
  /// In fr, this message translates to:
  /// **'La structure est requise.'**
  String get structureRequired;

  /// No description provided for @loadingStructures.
  ///
  /// In fr, this message translates to:
  /// **'Chargement des structures…'**
  String get loadingStructures;

  /// No description provided for @structure.
  ///
  /// In fr, this message translates to:
  /// **'Structure'**
  String get structure;

  /// No description provided for @chooseStructure.
  ///
  /// In fr, this message translates to:
  /// **'Choisir une structure'**
  String get chooseStructure;

  /// No description provided for @searchStructure.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une structure…'**
  String get searchStructure;

  /// No description provided for @noStructureFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucune structure trouvée.'**
  String get noStructureFound;

  /// No description provided for @rejectRequest.
  ///
  /// In fr, this message translates to:
  /// **'Rejeter la demande'**
  String get rejectRequest;

  /// No description provided for @rejectReasonOptional.
  ///
  /// In fr, this message translates to:
  /// **'Motif (optionnel)'**
  String get rejectReasonOptional;

  /// No description provided for @reject.
  ///
  /// In fr, this message translates to:
  /// **'Rejeter'**
  String get reject;

  /// No description provided for @validate.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get validate;

  /// No description provided for @reservationRequests.
  ///
  /// In fr, this message translates to:
  /// **'Demandes de Réservation'**
  String get reservationRequests;

  /// No description provided for @iconPending.
  ///
  /// In fr, this message translates to:
  /// **'Icône en attente'**
  String get iconPending;

  /// No description provided for @iconValidated.
  ///
  /// In fr, this message translates to:
  /// **'Icône validées'**
  String get iconValidated;

  /// No description provided for @iconRejected.
  ///
  /// In fr, this message translates to:
  /// **'Icône rejetées'**
  String get iconRejected;

  /// No description provided for @request.
  ///
  /// In fr, this message translates to:
  /// **'Demander'**
  String get request;

  /// No description provided for @noReservations.
  ///
  /// In fr, this message translates to:
  /// **'Aucune réservation trouvée.'**
  String get noReservations;

  /// No description provided for @reservationStatusLabel.
  ///
  /// In fr, this message translates to:
  /// **'Statut de la réservation : {status}'**
  String reservationStatusLabel(String status);

  /// No description provided for @roomNumberFallback.
  ///
  /// In fr, this message translates to:
  /// **'Salle #{id}'**
  String roomNumberFallback(String id);

  /// No description provided for @reservationStructureLine.
  ///
  /// In fr, this message translates to:
  /// **'Structure : {value}'**
  String reservationStructureLine(String value);

  /// No description provided for @reservationDateLine.
  ///
  /// In fr, this message translates to:
  /// **'Date : {date} ({start} - {end})'**
  String reservationDateLine(String date, String start, String end);

  /// No description provided for @reservationReasonLine.
  ///
  /// In fr, this message translates to:
  /// **'Motif : {reason}'**
  String reservationReasonLine(String reason);

  /// No description provided for @selectDateSlot.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez une date et un créneau.'**
  String get selectDateSlot;

  /// No description provided for @endAfterStart.
  ///
  /// In fr, this message translates to:
  /// **'L\'heure de fin doit être après l\'heure de début.'**
  String get endAfterStart;

  /// No description provided for @noRoomAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Aucune salle disponible sur ce créneau.'**
  String get noRoomAvailable;

  /// No description provided for @chooseAvailableRoom.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez une salle disponible.'**
  String get chooseAvailableRoom;

  /// No description provided for @requestSent.
  ///
  /// In fr, this message translates to:
  /// **'Demande de réservation envoyée.'**
  String get requestSent;

  /// No description provided for @requestFailed.
  ///
  /// In fr, this message translates to:
  /// **'Échec de la demande.'**
  String get requestFailed;

  /// No description provided for @newReservationRequest.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle demande de réservation'**
  String get newReservationRequest;

  /// No description provided for @date.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @startTime.
  ///
  /// In fr, this message translates to:
  /// **'Début'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In fr, this message translates to:
  /// **'Fin'**
  String get endTime;

  /// No description provided for @viewAvailableRooms.
  ///
  /// In fr, this message translates to:
  /// **'Voir les salles disponibles'**
  String get viewAvailableRooms;

  /// No description provided for @meetingSubject.
  ///
  /// In fr, this message translates to:
  /// **'Objet de la réunion'**
  String get meetingSubject;

  /// No description provided for @subjectRequired.
  ///
  /// In fr, this message translates to:
  /// **'L\'objet est requis.'**
  String get subjectRequired;

  /// No description provided for @organizingStructure.
  ///
  /// In fr, this message translates to:
  /// **'Structure organisatrice'**
  String get organizingStructure;

  /// No description provided for @sendRequest.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer la demande'**
  String get sendRequest;

  /// No description provided for @roomSaved.
  ///
  /// In fr, this message translates to:
  /// **'Salle enregistrée.'**
  String get roomSaved;

  /// No description provided for @deleteRoom.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la salle'**
  String get deleteRoom;

  /// No description provided for @noRooms.
  ///
  /// In fr, this message translates to:
  /// **'Aucune salle enregistrée.'**
  String get noRooms;

  /// No description provided for @roomIcon.
  ///
  /// In fr, this message translates to:
  /// **'Icône salle {name}'**
  String roomIcon(String name);

  /// No description provided for @noCategory.
  ///
  /// In fr, this message translates to:
  /// **'Sans catégorie'**
  String get noCategory;

  /// No description provided for @roomSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'{city} - {status} ({category})'**
  String roomSubtitle(String city, String status, String category);

  /// No description provided for @amountFcfa.
  ///
  /// In fr, this message translates to:
  /// **'{amount} FCFA'**
  String amountFcfa(String amount);

  /// No description provided for @editRoom.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la salle'**
  String get editRoom;

  /// No description provided for @newRoom.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle salle'**
  String get newRoom;

  /// No description provided for @roomName.
  ///
  /// In fr, this message translates to:
  /// **'Nom de la salle'**
  String get roomName;

  /// No description provided for @region.
  ///
  /// In fr, this message translates to:
  /// **'Région'**
  String get region;

  /// No description provided for @province.
  ///
  /// In fr, this message translates to:
  /// **'Province'**
  String get province;

  /// No description provided for @city.
  ///
  /// In fr, this message translates to:
  /// **'Ville'**
  String get city;

  /// No description provided for @location.
  ///
  /// In fr, this message translates to:
  /// **'Emplacement (bloc, étage...)'**
  String get location;

  /// No description provided for @category.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get category;

  /// No description provided for @regionalDirection.
  ///
  /// In fr, this message translates to:
  /// **'Direction régionale'**
  String get regionalDirection;

  /// No description provided for @status.
  ///
  /// In fr, this message translates to:
  /// **'Statut'**
  String get status;

  /// No description provided for @rentalAmountFree.
  ///
  /// In fr, this message translates to:
  /// **'Montant de location (FCFA, 0 si gratuite)'**
  String get rentalAmountFree;

  /// No description provided for @computerCount.
  ///
  /// In fr, this message translates to:
  /// **'Nombre d\'ordinateurs'**
  String get computerCount;

  /// No description provided for @equippedComputers.
  ///
  /// In fr, this message translates to:
  /// **'Équipée en ordinateurs'**
  String get equippedComputers;

  /// No description provided for @statsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques & Analytique GsrApp'**
  String get statsTitle;

  /// No description provided for @reservationRequestsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Demandes de réservation'**
  String get reservationRequestsTitle;

  /// No description provided for @successRate.
  ///
  /// In fr, this message translates to:
  /// **'Taux de succès'**
  String get successRate;

  /// No description provided for @frequencyByDirection.
  ///
  /// In fr, this message translates to:
  /// **'Fréquentation par direction régionale'**
  String get frequencyByDirection;

  /// No description provided for @noReservationsYet.
  ///
  /// In fr, this message translates to:
  /// **'Aucune réservation enregistrée pour le moment.'**
  String get noReservationsYet;

  /// No description provided for @requestsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{{count} demande} other{{count} demandes}}'**
  String requestsCount(int count);

  /// No description provided for @accountCreationFailed.
  ///
  /// In fr, this message translates to:
  /// **'Échec de la création du compte.'**
  String get accountCreationFailed;

  /// No description provided for @userAccountsManagement.
  ///
  /// In fr, this message translates to:
  /// **'Gestion des comptes utilisateurs'**
  String get userAccountsManagement;

  /// No description provided for @noPendingAccounts.
  ///
  /// In fr, this message translates to:
  /// **'Aucun compte en attente de validation.'**
  String get noPendingAccounts;

  /// No description provided for @noStructureShort.
  ///
  /// In fr, this message translates to:
  /// **'Sans structure'**
  String get noStructureShort;

  /// No description provided for @approveAccount.
  ///
  /// In fr, this message translates to:
  /// **'Valider le compte'**
  String get approveAccount;

  /// No description provided for @rejectAccount.
  ///
  /// In fr, this message translates to:
  /// **'Rejeter le compte'**
  String get rejectAccount;

  /// No description provided for @temporaryPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe temporaire'**
  String get temporaryPassword;

  /// No description provided for @atLeast6Chars.
  ///
  /// In fr, this message translates to:
  /// **'Au moins 8 caractères.'**
  String get atLeast6Chars;

  /// No description provided for @role.
  ///
  /// In fr, this message translates to:
  /// **'Rôle'**
  String get role;

  /// No description provided for @email.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @connectedAccount.
  ///
  /// In fr, this message translates to:
  /// **'Compte connecté'**
  String get connectedAccount;

  /// No description provided for @appLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue de l\'application'**
  String get appLanguage;

  /// No description provided for @appTheme.
  ///
  /// In fr, this message translates to:
  /// **'Thème de l\'application'**
  String get appTheme;

  /// No description provided for @darkMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode sombre'**
  String get darkMode;

  /// No description provided for @darkModeOn.
  ///
  /// In fr, this message translates to:
  /// **'Thème sombre activé'**
  String get darkModeOn;

  /// No description provided for @lightModeOn.
  ///
  /// In fr, this message translates to:
  /// **'Thème clair activé'**
  String get lightModeOn;

  /// No description provided for @logoutButtonLabel.
  ///
  /// In fr, this message translates to:
  /// **'Bouton se déconnecter'**
  String get logoutButtonLabel;

  /// No description provided for @identifier.
  ///
  /// In fr, this message translates to:
  /// **'Identifiant'**
  String get identifier;

  /// No description provided for @phone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get phone;

  /// No description provided for @fleetNumberFull.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de flotte'**
  String get fleetNumberFull;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @connChecking.
  ///
  /// In fr, this message translates to:
  /// **'Vérification en cours…'**
  String get connChecking;

  /// No description provided for @connUnreachable.
  ///
  /// In fr, this message translates to:
  /// **'Serveur injoignable'**
  String get connUnreachable;

  /// No description provided for @connDbDown.
  ///
  /// In fr, this message translates to:
  /// **'API joignable, base de données indisponible'**
  String get connDbDown;

  /// No description provided for @connOk.
  ///
  /// In fr, this message translates to:
  /// **'Connecté à l\'API et à MySQL ({ms} ms)'**
  String connOk(int ms);

  /// No description provided for @connSemantics.
  ///
  /// In fr, this message translates to:
  /// **'État de la connexion à l\'API'**
  String get connSemantics;

  /// No description provided for @connTitle.
  ///
  /// In fr, this message translates to:
  /// **'État de la connexion MySQL (dbgsr)'**
  String get connTitle;

  /// No description provided for @retest.
  ///
  /// In fr, this message translates to:
  /// **'Tester à nouveau'**
  String get retest;

  /// No description provided for @appVersion.
  ///
  /// In fr, this message translates to:
  /// **'Version de l\'application'**
  String get appVersion;

  /// No description provided for @aboutDescription.
  ///
  /// In fr, this message translates to:
  /// **'Gestion des salles de réunion et des réservations.'**
  String get aboutDescription;

  /// No description provided for @errTimeout.
  ///
  /// In fr, this message translates to:
  /// **'Le serveur met trop de temps à répondre.'**
  String get errTimeout;

  /// No description provided for @errSessionExpired.
  ///
  /// In fr, this message translates to:
  /// **'Session expirée, veuillez vous reconnecter.'**
  String get errSessionExpired;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @activateAgentHint.
  ///
  /// In fr, this message translates to:
  /// **'L\'identifiant doit correspondre à un agent DGI existant.'**
  String get activateAgentHint;

  /// No description provided for @loadMore.
  ///
  /// In fr, this message translates to:
  /// **'Charger plus'**
  String get loadMore;

  /// No description provided for @changePhoto.
  ///
  /// In fr, this message translates to:
  /// **'Changer la photo'**
  String get changePhoto;

  /// No description provided for @removePhoto.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la photo'**
  String get removePhoto;

  /// No description provided for @photoUpdateSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Photo de profil mise à jour.'**
  String get photoUpdateSuccess;

  /// No description provided for @photoUpdateFailed.
  ///
  /// In fr, this message translates to:
  /// **'Échec de l\'envoi de la photo.'**
  String get photoUpdateFailed;

  /// No description provided for @photoRemoveSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Photo de profil supprimée.'**
  String get photoRemoveSuccess;

  /// No description provided for @photoInvalidType.
  ///
  /// In fr, this message translates to:
  /// **'Formats acceptés : JPEG, PNG, WEBP.'**
  String get photoInvalidType;

  /// No description provided for @photoTooLarge.
  ///
  /// In fr, this message translates to:
  /// **'Photo trop volumineuse (5 Mo maximum).'**
  String get photoTooLarge;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr', 'ru', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
