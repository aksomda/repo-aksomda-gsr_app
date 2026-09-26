import 'package:flutter/widgets.dart';
import 'app_localizations.dart';

/// Accès court aux traductions : `context.l10n.save`.
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

/// Langue active de l'application, pour le code sans [BuildContext]
/// (sources de données, providers). Tenue à jour par `GsrApp`.
class AppLocale {
  AppLocale._();

  static Locale current = const Locale('fr');

  static AppLocalizations get l10n {
    try {
      return lookupAppLocalizations(current);
    } catch (_) {
      return lookupAppLocalizations(const Locale('fr'));
    }
  }
}

/// Libellés des valeurs métier (stockées en base sous forme de codes).
extension L10nLabels on AppLocalizations {
  String roomStatusName(String status) {
    switch (status.toLowerCase()) {
      case 'disponible':
        return roomStatusAvailable;
      case 'reservé':
        return roomStatusReserved;
      case 'en refection':
        return roomStatusRefection;
      case 'dégradé':
        return roomStatusDegraded;
      case 'en construction':
        return roomStatusConstruction;
      default:
        return status;
    }
  }

  String reservationStatusName(String status) {
    switch (status) {
      case 'en_attente':
        return resPending;
      case 'validee':
        return resValidated;
      case 'rejetee':
        return resRejected;
      default:
        return status;
    }
  }

  String roleName(String role) => role == 'admin' ? roleAdmin : roleAgent;
}
