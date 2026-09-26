import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';

/// Initialise Firebase quand la plateforme et la configuration le
/// permettent (voir FIREBASE_SETUP.md : google-services.json côté Android,
/// seule plateforme prise en charge par ce projet pour l'instant). Ne lève
/// jamais : sans configuration, l'application continue de fonctionner
/// normalement — MySQL reste la seule source de vérité —, seules la
/// synchronisation Firebase Auth et les notifications push restent
/// indisponibles (voir [FirebaseSync]).
class FirebaseBootstrap {
  FirebaseBootstrap._();

  static bool available = false;

  static Future<void> init() async {
    if (kIsWeb || !Platform.isAndroid) {
      return;
    }
    try {
      await Firebase.initializeApp();
      available = true;
    } catch (_) {
      available = false;
    }
  }
}
