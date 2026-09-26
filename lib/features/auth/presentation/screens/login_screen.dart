import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/gsr_colors.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/gsr_logo_badge.dart';
import 'register_screen.dart';
import '../../../../l10n/l10n_extensions.dart';

const _kPrimaryGreen = GsrColors.primary;
const _kDarkGreen = GsrColors.primaryDark;
const _kWideBreakpoint = 900.0;

/// Écran de connexion, avec deux présentations distinctes selon la largeur
/// disponible :
/// - Web/desktop (>= 900px) : formulaire affiché directement, en deux
///   colonnes (bandeau institutionnel + carte de connexion).
/// - Mobile/tablette (< 900px) : écran d'accueil avec "Se connecter" /
///   "Créer un compte", le formulaire n'apparaissant qu'après avoir appuyé
///   sur "Se connecter" (pattern habituel sur petit écran).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _showMobileForm = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthProvider auth) async {
    if (!_formKey.currentState!.validate()) return;
    await auth.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  void _openRegister(AuthProvider auth) {
    auth.clearError();
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const RegisterScreen()));
  }

  void _forgotPassword() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.loginForgotInfo)));
  }

  Widget _buildForm({required bool compact}) {
    final auth = context.watch<AuthProvider>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthTextField(
            controller: _emailController,
            label: context.l10n.loginIdentifier,
            hint: 'nom.prenom@institution.bf',
            prefixIcon: Icons.person_outline,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return context.l10n.loginIdentifierRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AuthTextField(
            controller: _passwordController,
            label: context.l10n.password,
            hint: '••••••••',
            prefixIcon: Icons.lock_outline,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              tooltip: _obscurePassword
                  ? context.l10n.showPassword
                  : context.l10n.hidePassword,
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.l10n.passwordRequired;
              }
              return null;
            },
          ),
          if (auth.errorMessage != null) ...[
            const SizedBox(height: 16),
            Semantics(
              label: context.l10n.errorMessageLabel,
              child: Text(
                auth.errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          const SizedBox(height: 24),
          Semantics(
            label: context.l10n.loginButtonLabel,
            button: true,
            child: ElevatedButton(
              onPressed: auth.isLoading ? null : () => _submit(auth),
              style: ElevatedButton.styleFrom(
                backgroundColor: _kPrimaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: auth.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(context.l10n.signIn),
            ),
          ),
          const SizedBox(height: 6),
          TextButton(
            onPressed: () => _openRegister(auth),
            child: Text(
              context.l10n.registerQuestion,
              style: TextStyle(color: _kPrimaryGreen),
            ),
          ),
          const SizedBox(height: 6),
          TextButton(
            onPressed: _forgotPassword,
            child: Text(
              context.l10n.forgotPassword,
              style: TextStyle(color: _kPrimaryGreen),
            ),
          ),
          if (compact)
            TextButton(
              onPressed: auth.isLoading ? null : () => _openRegister(auth),
              child: Text(context.l10n.noAccountCreate),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isWide = MediaQuery.sizeOf(context).width >= _kWideBreakpoint;

    if (isWide) {
      return _WideLoginLayout(
        buildForm: () => _buildForm(compact: false),
        onRegister: () => _openRegister(auth),
      );
    }

    if (!_showMobileForm) {
      return _MobileWelcomeLayout(
        onLogin: () => setState(() => _showMobileForm = true),
        onRegister: () => _openRegister(auth),
      );
    }

    return _MobileFormLayout(
      onBack: () => setState(() => _showMobileForm = false),
      buildForm: () => _buildForm(compact: true),
    );
  }
}

class _WideLoginLayout extends StatelessWidget {
  final Widget Function() buildForm;
  final VoidCallback onRegister;

  const _WideLoginLayout({required this.buildForm, required this.onRegister});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F4),
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_kDarkGreen, _kPrimaryGreen],
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const GsrLogoBadge(
                        size: 96,
                        background: Colors.white,
                        iconColor: _kPrimaryGreen,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        context.l10n.dgiName,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.roomsManagementTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 32,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.groups_rounded,
                        size: 48,
                        color: _kPrimaryGreen,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.l10n.roomsAndReservationsTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.loginWelcome,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600], fontSize: 15),
                      ),
                      const SizedBox(height: 32),
                      buildForm(),
                      const SizedBox(height: 24),
                      Text(
                        '© Copyright 2026 - DGI v0',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileWelcomeLayout extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onRegister;

  const _MobileWelcomeLayout({required this.onLogin, required this.onRegister});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_kPrimaryGreen, _kDarkGreen],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  const GsrLogoBadge(size: 76),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.roomsManagementTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.loginTagline,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Semantics(
                      label: context.l10n.loginButtonLabel,
                      button: true,
                      child: ElevatedButton(
                        onPressed: onLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kPrimaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(context.l10n.signIn),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Semantics(
                      label: context.l10n.createAccountButtonLabel,
                      button: true,
                      child: OutlinedButton(
                        onPressed: onRegister,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _kPrimaryGreen,
                          side: const BorderSide(color: _kPrimaryGreen),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(context.l10n.createAccount),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 140,
                        color: const Color(0xFFEDEFEE),
                        child: const Icon(
                          Icons.apartment_rounded,
                          size: 56,
                          color: Color(0xFFB9C0BD),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                context.l10n.footerInstitution(DateTime.now().year),
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileFormLayout extends StatelessWidget {
  final VoidCallback onBack;
  final Widget Function() buildForm;

  const _MobileFormLayout({required this.onBack, required this.buildForm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const GsrLogoBadge(size: 72, background: Color(0xFFEAF5EF)),
              const SizedBox(height: 20),
              Text(
                context.l10n.signIn,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              buildForm(),
            ],
          ),
        ),
      ),
    );
  }
}
