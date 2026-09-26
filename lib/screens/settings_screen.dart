import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import '../core/network/health_check.dart';
import '../core/settings/settings_provider.dart';
import '../features/auth/domain/entities/user.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../l10n/app_localizations.dart';
import '../l10n/l10n_extensions.dart';
import '../core/widgets/app_drawer.dart';
import '../core/widgets/drawer_menu_button.dart';

class SettingsConnectivityScreen extends StatelessWidget {
  const SettingsConnectivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();
    final settings = context.watch<SettingsProvider>();
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        actions: const [DrawerMenuButton()],
      ),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          if (user != null)
            Semantics(
              label: context.l10n.connectedAccount,
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(user.nomComplet),
                subtitle: Text(
                  '${user.email}\n${user.structureLibelle ?? context.l10n.noStructureShort} · ${context.l10n.roleName(user.role)}',
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showProfile(context, user),
              ),
            ),
          const Divider(),
          const _ConnectionTile(),
          const Divider(),
          Semantics(
            label: context.l10n.appLanguage,
            child: ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.appTitle),
              subtitle: Text(
                languageName(Localizations.localeOf(context).languageCode),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _chooseLanguage(context),
            ),
          ),
          const Divider(),
          Semantics(
            label: context.l10n.appTheme,
            child: SwitchListTile(
              secondary: Icon(
                settings.isDark ? Icons.dark_mode : Icons.light_mode,
              ),
              title: Text(context.l10n.darkMode),
              subtitle: Text(
                settings.isDark
                    ? context.l10n.darkModeOn
                    : context.l10n.lightModeOn,
              ),
              value: settings.isDark,
              onChanged: settings.setDark,
            ),
          ),
          const Divider(),
          const _VersionTile(),
        ],
      ),
    );
  }

  void _showProfile(BuildContext context, User user) {
    Widget row(IconData icon, String label, String? value) => ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(
        value == null || value.isEmpty ? context.l10n.notProvided : value,
        style: const TextStyle(fontSize: 15),
      ),
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(user.nomComplet),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                row(Icons.badge_outlined, context.l10n.identifier, user.login),
                row(Icons.email_outlined, context.l10n.email, user.email),
                row(Icons.phone_outlined, context.l10n.phone, user.telephone),
                row(
                  Icons.smartphone_outlined,
                  context.l10n.fleetNumberFull,
                  user.numeroFlotte,
                ),
                row(
                  Icons.apartment_outlined,
                  context.l10n.structure,
                  user.structureLibelle,
                ),
                row(
                  Icons.admin_panel_settings_outlined,
                  context.l10n.role,
                  user.isAdmin
                      ? context.l10n.roleAdmin
                      : context.l10n.roleAgent,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(context.l10n.close),
          ),
        ],
      ),
    );
  }

  Future<void> _chooseLanguage(BuildContext context) async {
    final settings = context.read<SettingsProvider>();
    final current = Localizations.localeOf(context).languageCode;

    final picked = await showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text(context.l10n.language),
        children: [
          for (final (code, label) in supportedLanguages)
            ListTile(
              title: Text(label),
              trailing: code == current ? const Icon(Icons.check) : null,
              onTap: () => Navigator.of(dialogContext).pop(code),
            ),
        ],
      ),
    );
    if (picked != null) await settings.setLocale(Locale(picked));
  }
}

/// Teste réellement l'API et la base MySQL ; un appui relance le test.
class _ConnectionTile extends StatefulWidget {
  const _ConnectionTile();

  @override
  State<_ConnectionTile> createState() => _ConnectionTileState();
}

class _ConnectionTileState extends State<_ConnectionTile> {
  ApiHealth? _health;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    setState(() => _checking = true);
    final health = await checkApiHealth();
    if (!mounted) return;
    setState(() {
      _health = health;
      _checking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final health = _health;
    final (color, text) = _checking || health == null
        ? (Colors.grey, context.l10n.connChecking)
        : !health.reachable
        ? (Colors.red, context.l10n.connUnreachable)
        : !health.database
        ? (Colors.orange, context.l10n.connDbDown)
        : (Colors.green, context.l10n.connOk(health.latencyMs ?? 0));

    return Semantics(
      label: context.l10n.connSemantics,
      child: ListTile(
        leading: _checking
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(Icons.network_check, color: color),
        title: Text(context.l10n.connTitle),
        subtitle: Text(text),
        trailing: IconButton(
          tooltip: context.l10n.retest,
          icon: const Icon(Icons.refresh),
          onPressed: _checking ? null : _check,
        ),
        onTap: _checking ? null : _check,
      ),
    );
  }
}

class _VersionTile extends StatelessWidget {
  const _VersionTile();

  Future<PackageInfo?> _info() async {
    try {
      return await PackageInfo.fromPlatform();
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo?>(
      future: _info(),
      builder: (context, snapshot) {
        final info = snapshot.data;
        final version = info == null
            ? null
            : 'v${info.version} (build ${info.buildNumber})';

        return Semantics(
          label: context.l10n.appVersion,
          child: ListTile(
            leading: const Icon(Icons.info),
            title: Text(context.l10n.appVersion),
            subtitle: Text(version == null ? 'GsrApp' : 'GsrApp $version'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'GsrApp',
              applicationVersion: version,
              applicationIcon: const Icon(Icons.meeting_room, size: 40),
              children: [Text(context.l10n.aboutDescription)],
            ),
          ),
        );
      },
    );
  }
}
