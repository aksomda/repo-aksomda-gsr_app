import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gsr_app/core/settings/settings_provider.dart';
import 'package:gsr_app/l10n/app_localizations.dart';
import 'package:gsr_app/screens/settings_screen.dart';
import 'package:provider/provider.dart';

import '../helpers/fakes.dart';

Widget _buildApp() {
  return buildFakeApp(
    isAdmin: true,
    home: Builder(
      builder: (context) {
        final settings = context.watch<SettingsProvider>();
        return MaterialApp(
          themeMode: settings.themeMode,
          theme: ThemeData(useMaterial3: true),
          darkTheme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
          locale: settings.locale ?? const Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SettingsConnectivityScreen(),
        );
      },
    ),
  );
}

void main() {
  testWidgets('le commutateur bascule entre thème clair et thème sombre', (
    tester,
  ) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    expect(
      Theme.of(tester.element(find.byType(Scaffold))).brightness,
      Brightness.light,
    );
    expect(find.text('Thème clair activé'), findsOneWidget);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(Scaffold))).brightness,
      Brightness.dark,
    );
    expect(find.text('Thème sombre activé'), findsOneWidget);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(Scaffold))).brightness,
      Brightness.light,
    );
  });

  testWidgets('le choix de la langue traduit tout l’écran (EN, RU, ZH, FR)', (
    tester,
  ) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    expect(find.text('Paramètres'), findsOneWidget);
    expect(find.text('Mode sombre'), findsOneWidget);

    Future<void> choose(String language) async {
      await tester.tap(find.byIcon(Icons.language));
      await tester.pumpAndSettle();
      await tester.tap(find.text(language).last);
      await tester.pumpAndSettle();
    }

    await choose('English');
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Dark mode'), findsOneWidget);
    expect(find.text('Log out'), findsOneWidget);

    await choose('Русский');
    expect(find.text('Настройки'), findsOneWidget);
    expect(find.text('Тёмная тема'), findsOneWidget);
    expect(find.text('Выйти'), findsOneWidget);

    await choose('中文');
    expect(find.text('设置'), findsOneWidget);
    expect(find.text('深色模式'), findsOneWidget);
    expect(find.text('退出登录'), findsOneWidget);

    await choose('Français');
    expect(find.text('Paramètres'), findsOneWidget);
  });

  testWidgets('le profil et la version ouvrent leur détail', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Version de l\'application'));
    await tester.pumpAndSettle();
    expect(
      find.text('Gestion des salles de réunion et des réservations.'),
      findsOneWidget,
    );
  });

  testWidgets('la connexion est testée et signale un serveur injoignable', (
    tester,
  ) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Serveur injoignable'), findsOneWidget);
    expect(find.byTooltip('Tester à nouveau'), findsOneWidget);
  });
}
