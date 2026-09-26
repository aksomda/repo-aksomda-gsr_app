import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ref_structure/presentation/providers/structure_provider.dart';
import '../../../ref_structure/presentation/widgets/structure_picker_field.dart';
import '../providers/auth_provider.dart';
import '../../../../l10n/l10n_extensions.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _matriculeController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _numeroFlotteController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _structureCode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<StructureProvider>().fetchStructures();
    });
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _matriculeController.dispose();
    _telephoneController.dispose();
    _numeroFlotteController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.fieldRequiredNamed(label);
    }
    return null;
  }

  Future<void> _submit(AuthProvider auth) async {
    if (!_formKey.currentState!.validate()) return;
    if (_structureCode == null) {
      setState(() {}); // force re-validation display via dropdown validator
      return;
    }

    final success = await auth.register(
      nom: _nomController.text.trim(),
      prenom: _prenomController.text.trim(),
      matricule: _matriculeController.text.trim(),
      telephone: _telephoneController.text.trim(),
      numeroFlotte: _numeroFlotteController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      structureCode: _structureCode!,
    );

    if (success && mounted) {
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(context.l10n.registrationSent),
          content: Text(auth.infoMessage ?? context.l10n.accountCreatedSuccess),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      auth.clearInfo();
      if (mounted) Navigator.of(context).pop();
    }
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Semantics(
        label: context.l10n.fieldSemantics(label),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscure,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            suffixIcon: suffixIcon,
            border: const OutlineInputBorder(),
          ),
          validator: validator ?? (value) => _required(value, label),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.createAccount)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _field(
                  controller: _nomController,
                  label: context.l10n.lastName,
                  icon: Icons.badge_outlined,
                ),
                _field(
                  controller: _prenomController,
                  label: context.l10n.firstName,
                  icon: Icons.person_outline,
                ),
                _field(
                  controller: _matriculeController,
                  label: context.l10n.matricule,
                  icon: Icons.numbers,
                ),
                _field(
                  controller: _telephoneController,
                  label: context.l10n.phoneWhatsapp,
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                _field(
                  controller: _numeroFlotteController,
                  label: context.l10n.fleetNumber,
                  icon: Icons.smartphone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                _field(
                  controller: _emailController,
                  label: context.l10n.emailAddress,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.l10n.emailRequired;
                    }
                    if (!value.contains('@')) {
                      return context.l10n.emailInvalid;
                    }
                    return null;
                  },
                ),
                _field(
                  controller: _passwordController,
                  label: context.l10n.password,
                  icon: Icons.lock_outline,
                  obscure: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
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
                    if (value.length < 8) {
                      return context.l10n.passwordMin6;
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Semantics(
                    label: context.l10n.structureFieldLabel,
                    child: StructurePickerField(
                      value: _structureCode,
                      onChanged: (value) =>
                          setState(() => _structureCode = value),
                    ),
                  ),
                ),
                if (auth.errorMessage != null) ...[
                  Semantics(
                    label: context.l10n.errorMessageLabel,
                    child: Text(
                      auth.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: 8),
                Semantics(
                  label: context.l10n.createAccountSubmitLabel,
                  button: true,
                  child: ElevatedButton(
                    onPressed: auth.isLoading ? null : () => _submit(auth),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
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
                        : Text(context.l10n.createTheAccount),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
