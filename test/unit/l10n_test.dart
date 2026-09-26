import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gsr_app/l10n/app_localizations.dart';
import 'package:gsr_app/l10n/l10n_extensions.dart';

Map<String, dynamic> _arb(String code) =>
    json.decode(File('lib/l10n/app_$code.arb').readAsStringSync())
        as Map<String, dynamic>;

Set<String> _keys(Map<String, dynamic> arb) =>
    arb.keys.where((k) => !k.startsWith('@')).toSet();

void main() {
  test('les 4 langues (fr, en, ru, zh) sont prises en charge', () {
    expect(
      AppLocalizations.supportedLocales.map((l) => l.languageCode).toSet(),
      {'fr', 'en', 'ru', 'zh'},
    );
  });

  test('chaque langue traduit exactement les mêmes clés que le français', () {
    final fr = _keys(_arb('fr'));
    for (final code in ['en', 'ru', 'zh']) {
      final keys = _keys(_arb(code));
      expect(fr.difference(keys), isEmpty, reason: 'clés manquantes en $code');
      expect(keys.difference(fr), isEmpty, reason: 'clés en trop en $code');
    }
  });

  test('aucune traduction n\'est vide ou restée en français par oubli', () {
    final fr = _arb('fr');
    for (final code in ['en', 'ru', 'zh']) {
      final arb = _arb(code);
      for (final key in _keys(fr)) {
        expect((arb[key] as String).trim(), isNotEmpty, reason: '$key ($code)');
      }
      // Les libellés principaux doivent différer du français.
      for (final key in ['settings', 'logout', 'darkMode', 'newMessage']) {
        expect(arb[key], isNot(fr[key]), reason: '$key ($code)');
      }
    }
  });

  test('les messages hors contexte suivent la langue active', () {
    AppLocale.current = const Locale('ru');
    expect(AppLocale.l10n.errUnexpected, 'Произошла непредвиденная ошибка.');
    AppLocale.current = const Locale('zh');
    expect(AppLocale.l10n.errUnexpected, '发生了意外错误。');
    AppLocale.current = const Locale('fr');
  });

  test('les statuts et rôles métier sont traduits', () {
    final ru = lookupAppLocalizations(const Locale('ru'));
    expect(ru.roomStatusName('disponible'), 'Доступен');
    expect(ru.reservationStatusName('validee'), 'Подтверждённые');
    expect(ru.roleName('admin'), 'Администратор');
  });

  test('le pluriel russe suit les règles de la langue', () {
    final ru = lookupAppLocalizations(const Locale('ru'));
    expect(ru.requestsCount(1), '1 заявка');
    expect(ru.requestsCount(3), '3 заявки');
    expect(ru.requestsCount(5), '5 заявок');
  });
}
