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
}
