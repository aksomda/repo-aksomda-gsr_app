import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Langues proposées, avec leur nom écrit dans leur propre langue.
const supportedLanguages = <(String code, String name)>[
  ('fr', 'Français'),
  ('en', 'English'),
  ('ru', 'Русский'),
  ('zh', '中文'),
];

String languageName(String code) => supportedLanguages
    .firstWhere((l) => l.$1 == code, orElse: () => supportedLanguages.first)
    .$2;

/// Préférences d'affichage de l'utilisateur (thème clair/sombre, langue),
/// conservées entre deux lancements de l'application.
class SettingsProvider with ChangeNotifier {
  static const _themeKey = 'settings.dark_mode';
  static const _localeKey = 'settings.locale';

  ThemeMode _themeMode;
  Locale? _locale;

  SettingsProvider({
    ThemeMode themeMode = ThemeMode.light,
    Locale? locale = const Locale('fr'),
  })
    // ignore: prefer_initializing_formals
    : _themeMode = themeMode,
       // ignore: prefer_initializing_formals
       _locale = locale;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  /// Français tant que l'utilisateur n'a rien choisi.
  Locale? get locale => _locale;

  static Future<SettingsProvider> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_localeKey);
      return SettingsProvider(
        themeMode: (prefs.getBool(_themeKey) ?? false)
            ? ThemeMode.dark
            : ThemeMode.light,
        locale: Locale(code ?? 'fr'),
      );
    } catch (_) {
      return SettingsProvider();
    }
  }

  Future<void> setDark(bool dark) async {
    _themeMode = dark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    await _save((prefs) => prefs.setBool(_themeKey, dark));
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
    await _save((prefs) => prefs.setString(_localeKey, locale.languageCode));
  }

  Future<void> _save(Future<bool> Function(SharedPreferences) write) async {
    try {
      await write(await SharedPreferences.getInstance());
    } catch (_) {
      // Préférence non persistée : elle reste valable pour la session.
    }
  }
}
