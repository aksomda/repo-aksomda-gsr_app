// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle =>
      'GsrApp - Gestion des Salles de réunion et des Réservations';

  @override
  String get roomsList => 'Liste des Salles';

  @override
  String get categories => 'Catégories';

  @override
  String get reservations => 'Réservations';

  @override
  String get statistics => 'Statistiques';

  @override
  String get settings => 'Paramètres';

  @override
  String get available => 'Disponible';

  @override
  String get reserved => 'Réservé';

  @override
  String get refection => 'En réfection';

  @override
  String get degraded => 'Dégradé';

  @override
  String get construction => 'En construction';

  @override
  String get free => 'Gratuit';

  @override
  String get rental => 'En location';

  @override
  String get amount => 'Montant';

  @override
  String get computers => 'Ordinateurs';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get close => 'Fermer';

  @override
  String get create => 'Créer';

  @override
  String get all => 'Toutes';

  @override
  String get fieldRequired => 'Champ requis.';

  @override
  String get saveFailed => 'Échec de l\'enregistrement.';

  @override
  String get searchHint => 'Rechercher...';

  @override
  String get clear => 'Effacer';

  @override
  String get noResults => 'Aucun résultat.';

  @override
  String get noOptions => 'Aucune option disponible.';

  @override
  String get noData => 'Aucune donnée disponible.';

  @override
  String get notProvided => 'Non renseigné';

  @override
  String confirmDeleteNamed(String name) {
    return 'Supprimer \"$name\" ?';
  }

  @override
  String get errServerUnreachable =>
      'Impossible de joindre le serveur. Vérifiez votre connexion.';

  @override
  String get errUnexpected => 'Une erreur inattendue est survenue.';

  @override
  String errServerStatus(String code) {
    return 'Erreur serveur ($code)';
  }

  @override
  String get roomStatusAvailable => 'Disponible';

  @override
  String get roomStatusReserved => 'Réservée';

  @override
  String get roomStatusRefection => 'En réfection';

  @override
  String get roomStatusDegraded => 'Dégradée';

  @override
  String get roomStatusConstruction => 'En construction';

  @override
  String get tabAvailable => 'Disponibles';

  @override
  String get tabReserved => 'Réservées';

  @override
  String get tabRefection => 'Réfection';

  @override
  String get tabDegraded => 'Dégradées';

  @override
  String get tabConstruction => 'Construction';

  @override
  String get resPending => 'En attente';

  @override
  String get resValidated => 'Validées';

  @override
  String get resRejected => 'Rejetées';

  @override
  String get roleAdmin => 'Administrateur';

  @override
  String get roleAgent => 'Agent';

  @override
  String get home => 'Accueil';

  @override
  String get userAccounts => 'Comptes utilisateurs';

  @override
  String get regionalDirections => 'Directions régionales';

  @override
  String get structures => 'Structures';

  @override
  String get notifications => 'Notifications';

  @override
  String get messaging => 'Messagerie';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get logoutConfirm => 'Voulez-vous vraiment vous déconnecter ?';

  @override
  String get loginForgotInfo =>
      'Contactez un administrateur pour réinitialiser votre mot de passe.';

  @override
  String get loginIdentifier => 'Email ou identifiant';

  @override
  String get loginIdentifierRequired => 'L\'identifiant est requis.';

  @override
  String get password => 'Mot de passe';

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String get passwordRequired => 'Le mot de passe est requis.';

  @override
  String get errorMessageLabel => 'Message d\'erreur';

  @override
  String get loginButtonLabel => 'Bouton se connecter';

  @override
  String get signIn => 'Se connecter';

  @override
  String get registerQuestion => 'S\'inscrire ?';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get noAccountCreate => 'Pas encore de compte ? Créer un compte';

  @override
  String get dgiName => 'Direction Générale des Impôts du Burkina Faso';

  @override
  String get roomsManagementTitle => 'Gestion des Salles de Réunion';

  @override
  String get roomsAndReservationsTitle =>
      'Gestion des Salles de Réunion et des Réservations';

  @override
  String get loginWelcome => 'Connectez-vous à votre espace';

  @override
  String get loginTagline => 'Réservez vos salles en toute simplicité';

  @override
  String get createAccountButtonLabel => 'Bouton créer un compte';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String footerInstitution(int year) {
    return '© $year - Votre institution';
  }

  @override
  String fieldRequiredNamed(String label) {
    return '$label est requis.';
  }

  @override
  String fieldSemantics(String label) {
    return 'Champ $label';
  }

  @override
  String get registrationSent => 'Inscription envoyée';

  @override
  String get accountCreatedSuccess => 'Compte créé avec succès.';

  @override
  String get lastName => 'Nom';

  @override
  String get firstName => 'Prénom';

  @override
  String get matricule => 'Matricule';

  @override
  String get phoneWhatsapp => 'Téléphone (WhatsApp)';

  @override
  String get fleetNumber => 'Numéro flotte';

  @override
  String get emailAddress => 'Adresse e-mail';

  @override
  String get emailRequired => 'L\'adresse e-mail est requise.';

  @override
  String get emailInvalid => 'Adresse e-mail invalide.';

  @override
  String get passwordMin6 =>
      'Le mot de passe doit contenir au moins 8 caractères.';

  @override
  String get structureFieldLabel => 'Champ Structure';

  @override
  String get createAccountSubmitLabel => 'Bouton créer le compte';

  @override
  String get createTheAccount => 'Créer le compte';

  @override
  String get categorySaved => 'Catégorie enregistrée.';

  @override
  String get deleteCategory => 'Supprimer la catégorie';

  @override
  String get categoriesManagementTitle =>
      'Gestion des catégories de salles de réunion';

  @override
  String get tabFree => 'Gratuites';

  @override
  String get tabRental => 'Location';

  @override
  String get noCategories =>
      'Aucune catégorie de salle de réunion enregistrée.';

  @override
  String categoryIcon(String name) {
    return 'Icône catégorie $name';
  }

  @override
  String get categoryFree => 'Gratuite';

  @override
  String categoryRentalAmount(String amount) {
    return 'Location - $amount FCFA';
  }

  @override
  String get inactiveSuffix => ' (inactive)';

  @override
  String get editCategory => 'Modifier la catégorie';

  @override
  String get newCategory => 'Nouvelle catégorie';

  @override
  String get label => 'Libellé';

  @override
  String get labelRequired => 'Le libellé est requis.';

  @override
  String get type => 'Type';

  @override
  String get rentalAmountFcfa => 'Montant de location (FCFA)';

  @override
  String get invalidAmount => 'Montant invalide.';

  @override
  String get active => 'Active';

  @override
  String get newMessageChooseAgent => 'Nouveau message : choisir un agent';

  @override
  String get newMessage => 'Nouveau message';

  @override
  String get noAgentMessages =>
      'Aucun message d\'agent pour le moment.\nUtilisez « Nouveau message » pour écrire à un agent.';

  @override
  String get messagingWithAdmin => 'Messagerie avec l\'administration';

  @override
  String get noMessages => 'Aucun message pour le moment.';

  @override
  String get writeMessage => 'Écrire un message...';

  @override
  String get dashRooms => 'Salles';

  @override
  String get dashAvailableRooms => 'Salles disponibles';

  @override
  String get dashValidationRate => 'Taux de validation';

  @override
  String get dashRoomsByStatus => 'Salles par statut';

  @override
  String get dashReservationsByStatus => 'Réservations par statut';

  @override
  String get mostRequestedRooms => 'Salles les plus demandées';

  @override
  String get dashReservationsByDirection =>
      'Réservations par direction régionale';

  @override
  String get welcome => 'Bienvenue';

  @override
  String helloName(String name) {
    return 'Bonjour, $name';
  }

  @override
  String get dashSubtitle => 'Voici l\'activité de vos salles de réunion.';

  @override
  String get noRegionalDirections => 'Aucune direction régionale trouvée.';

  @override
  String get noNotifications => 'Aucune notification.';

  @override
  String get structuresLoadError =>
      'Impossible de charger les structures. Touchez pour réessayer.';

  @override
  String get editStructure => 'Modifier la structure';

  @override
  String get newStructure => 'Nouvelle structure';

  @override
  String get codeCdi => 'Code CDI';

  @override
  String get codeRequired => 'Le code est requis.';

  @override
  String get noStructures => 'Aucune structure enregistrée.';

  @override
  String get structureRequired => 'La structure est requise.';

  @override
  String get loadingStructures => 'Chargement des structures…';

  @override
  String get structure => 'Structure';

  @override
  String get chooseStructure => 'Choisir une structure';

  @override
  String get searchStructure => 'Rechercher une structure…';

  @override
  String get noStructureFound => 'Aucune structure trouvée.';

  @override
  String get rejectRequest => 'Rejeter la demande';

  @override
  String get rejectReasonOptional => 'Motif (optionnel)';

  @override
  String get reject => 'Rejeter';

  @override
  String get validate => 'Valider';

  @override
  String get reservationRequests => 'Demandes de Réservation';

  @override
  String get iconPending => 'Icône en attente';

  @override
  String get iconValidated => 'Icône validées';

  @override
  String get iconRejected => 'Icône rejetées';

  @override
  String get request => 'Demander';

  @override
  String get noReservations => 'Aucune réservation trouvée.';

  @override
  String reservationStatusLabel(String status) {
    return 'Statut de la réservation : $status';
  }

  @override
  String roomNumberFallback(String id) {
    return 'Salle #$id';
  }

  @override
  String reservationStructureLine(String value) {
    return 'Structure : $value';
  }

  @override
  String reservationDateLine(String date, String start, String end) {
    return 'Date : $date ($start - $end)';
  }

  @override
  String reservationReasonLine(String reason) {
    return 'Motif : $reason';
  }

  @override
  String get selectDateSlot => 'Sélectionnez une date et un créneau.';

  @override
  String get endAfterStart =>
      'L\'heure de fin doit être après l\'heure de début.';

  @override
  String get noRoomAvailable => 'Aucune salle disponible sur ce créneau.';

  @override
  String get chooseAvailableRoom => 'Choisissez une salle disponible.';

  @override
  String get requestSent => 'Demande de réservation envoyée.';

  @override
  String get requestFailed => 'Échec de la demande.';

  @override
  String get newReservationRequest => 'Nouvelle demande de réservation';

  @override
  String get date => 'Date';

  @override
  String get startTime => 'Début';

  @override
  String get endTime => 'Fin';

  @override
  String get viewAvailableRooms => 'Voir les salles disponibles';

  @override
  String get meetingSubject => 'Objet de la réunion';

  @override
  String get subjectRequired => 'L\'objet est requis.';

  @override
  String get organizingStructure => 'Structure organisatrice';

  @override
  String get sendRequest => 'Envoyer la demande';

  @override
  String get roomSaved => 'Salle enregistrée.';

  @override
  String get deleteRoom => 'Supprimer la salle';

  @override
  String get noRooms => 'Aucune salle enregistrée.';

  @override
  String roomIcon(String name) {
    return 'Icône salle $name';
  }

  @override
  String get noCategory => 'Sans catégorie';

  @override
  String roomSubtitle(String city, String status, String category) {
    return '$city - $status ($category)';
  }

  @override
  String amountFcfa(String amount) {
    return '$amount FCFA';
  }

  @override
  String get editRoom => 'Modifier la salle';

  @override
  String get newRoom => 'Nouvelle salle';

  @override
  String get roomName => 'Nom de la salle';

  @override
  String get region => 'Région';

  @override
  String get province => 'Province';

  @override
  String get city => 'Ville';

  @override
  String get location => 'Emplacement (bloc, étage...)';

  @override
  String get category => 'Catégorie';

  @override
  String get regionalDirection => 'Direction régionale';

  @override
  String get status => 'Statut';

  @override
  String get rentalAmountFree => 'Montant de location (FCFA, 0 si gratuite)';

  @override
  String get computerCount => 'Nombre d\'ordinateurs';

  @override
  String get equippedComputers => 'Équipée en ordinateurs';

  @override
  String get statsTitle => 'Statistiques & Analytique GsrApp';

  @override
  String get reservationRequestsTitle => 'Demandes de réservation';

  @override
  String get successRate => 'Taux de succès';

  @override
  String get frequencyByDirection => 'Fréquentation par direction régionale';

  @override
  String get noReservationsYet =>
      'Aucune réservation enregistrée pour le moment.';

  @override
  String requestsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count demandes',
      one: '$count demande',
    );
    return '$_temp0';
  }

  @override
  String get accountCreationFailed => 'Échec de la création du compte.';

  @override
  String get userAccountsManagement => 'Gestion des comptes utilisateurs';

  @override
  String get noPendingAccounts => 'Aucun compte en attente de validation.';

  @override
  String get noStructureShort => 'Sans structure';

  @override
  String get approveAccount => 'Valider le compte';

  @override
  String get rejectAccount => 'Rejeter le compte';

  @override
  String get temporaryPassword => 'Mot de passe temporaire';

  @override
  String get atLeast6Chars => 'Au moins 8 caractères.';

  @override
  String get role => 'Rôle';

  @override
  String get email => 'Email';

  @override
  String get connectedAccount => 'Compte connecté';

  @override
  String get appLanguage => 'Langue de l\'application';

  @override
  String get appTheme => 'Thème de l\'application';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get darkModeOn => 'Thème sombre activé';

  @override
  String get lightModeOn => 'Thème clair activé';

  @override
  String get logoutButtonLabel => 'Bouton se déconnecter';

  @override
  String get identifier => 'Identifiant';

  @override
  String get phone => 'Téléphone';

  @override
  String get fleetNumberFull => 'Numéro de flotte';

  @override
  String get language => 'Langue';

  @override
  String get connChecking => 'Vérification en cours…';

  @override
  String get connUnreachable => 'Serveur injoignable';

  @override
  String get connDbDown => 'API joignable, base de données indisponible';

  @override
  String connOk(int ms) {
    return 'Connecté à l\'API et à MySQL ($ms ms)';
  }

  @override
  String get connSemantics => 'État de la connexion à l\'API';

  @override
  String get connTitle => 'État de la connexion MySQL (dbgsr)';

  @override
  String get retest => 'Tester à nouveau';

  @override
  String get appVersion => 'Version de l\'application';

  @override
  String get aboutDescription =>
      'Gestion des salles de réunion et des réservations.';

  @override
  String get errTimeout => 'Le serveur met trop de temps à répondre.';

  @override
  String get errSessionExpired => 'Session expirée, veuillez vous reconnecter.';

  @override
  String get retry => 'Réessayer';

  @override
  String get activateAgentHint =>
      'L\'identifiant doit correspondre à un agent DGI existant.';

  @override
  String get loadMore => 'Charger plus';

  @override
  String get changePhoto => 'Changer la photo';

  @override
  String get removePhoto => 'Supprimer la photo';

  @override
  String get photoUpdateSuccess => 'Photo de profil mise à jour.';

  @override
  String get photoUpdateFailed => 'Échec de l\'envoi de la photo.';

  @override
  String get photoRemoveSuccess => 'Photo de profil supprimée.';

  @override
  String get photoInvalidType => 'Formats acceptés : JPEG, PNG, WEBP.';

  @override
  String get photoTooLarge => 'Photo trop volumineuse (5 Mo maximum).';
}
