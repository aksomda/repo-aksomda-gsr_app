import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/gsr_colors.dart';
import '../../../ref_structure/presentation/providers/structure_provider.dart';
import '../../../ref_structure/presentation/widgets/structure_picker_field.dart';
import '../../../../l10n/l10n_extensions.dart';

class NewUserData {
  final String nom,
      prenom,
      matricule,
      telephone,
      numeroFlotte,
      email,
      password,
      structureCode,
      role;

  NewUserData({
    required this.nom,
    required this.prenom,
    required this.matricule,
    required this.telephone,
    required this.numeroFlotte,
    required this.email,
    required this.password,
    required this.structureCode,
    required this.role,
  });
}

Future<NewUserData?> showCreateUserFormDialog(BuildContext context) {
  return showDialog<NewUserData>(
    context: context,
    builder: (_) => const _CreateUserFormDialog(),
  );
}

class _CreateUserFormDialog extends StatefulWidget {
  const _CreateUserFormDialog();

  @override
  State<_CreateUserFormDialog> createState() => _CreateUserFormDialogState();
}

class _CreateUserFormDialogState extends State<_CreateUserFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nom = TextEditingController();
  final _prenom = TextEditingController();
  final _matricule = TextEditingController();
  final _telephone = TextEditingController();
  final _numeroFlotte = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String _role = 'agent';
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
    for (final c in [
      _nom,
      _prenom,
      _matricule,
      _telephone,
      _numeroFlotte,
      _email,
      _password,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? context.l10n.fieldRequired : null;

  void _submit() {
    if (!_formKey.currentState!.validate() || _structureCode == null) {
      setState(() {});
      return;
    }
    Navigator.of(context).pop(
      NewUserData(
        nom: _nom.text.trim(),
        prenom: _prenom.text.trim(),
        matricule: _matricule.text.trim(),
        telephone: _telephone.text.trim(),
        numeroFlotte: _numeroFlotte.text.trim(),
        email: _email.text.trim(),
        password: _password.text,
        structureCode: _structureCode!,
        role: _role,
      ),
    );
  }

  /// Deux champs côte à côte quand la place le permet, empilés sinon.
  Widget _pair(Widget left, Widget right) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 480) {
          return Column(children: [left, const SizedBox(height: 8), right]);
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: left),
            const SizedBox(width: 16),
            Expanded(child: right),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.createAccount),
      content: SizedBox(
        width: 640,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _pair(
                  TextFormField(
                    controller: _nom,
                    decoration: InputDecoration(
                      labelText: context.l10n.lastName,
                    ),
                    validator: _required,
                  ),
                  TextFormField(
                    controller: _prenom,
                    decoration: InputDecoration(
                      labelText: context.l10n.firstName,
                    ),
                    validator: _required,
                  ),
                ),
                const SizedBox(height: 8),
                _pair(
                  TextFormField(
                    controller: _matricule,
                    decoration: InputDecoration(
                      labelText: context.l10n.matricule,
                    ),
                    validator: _required,
                  ),
                  TextFormField(
                    controller: _telephone,
                    decoration: InputDecoration(
                      labelText: context.l10n.phoneWhatsapp,
                    ),
                    validator: _required,
                  ),
                ),
                const SizedBox(height: 8),
                _pair(
                  TextFormField(
                    controller: _numeroFlotte,
                    decoration: InputDecoration(
                      labelText: context.l10n.fleetNumber,
                    ),
                  ),
                  TextFormField(
                    controller: _email,
                    decoration: InputDecoration(labelText: context.l10n.email),
                    validator: _required,
                  ),
                ),
                const SizedBox(height: 8),
                _pair(
                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: context.l10n.temporaryPassword,
                    ),
                    validator: (v) => (v == null || v.length < 8)
                        ? context.l10n.atLeast6Chars
                        : null,
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: _role,
                    decoration: InputDecoration(labelText: context.l10n.role),
                    items: [
                      DropdownMenuItem(
                        value: 'agent',
                        child: Text(context.l10n.roleAgent),
                      ),
                      DropdownMenuItem(
                        value: 'admin',
                        child: Text(context.l10n.roleAdmin),
                      ),
                    ],
                    onChanged: (value) =>
                        setState(() => _role = value ?? 'agent'),
                  ),
                ),
                const SizedBox(height: 8),
                StructurePickerField(
                  value: _structureCode,
                  onChanged: (value) => setState(() => _structureCode = value),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: GsrColors.primary,
            foregroundColor: Colors.white,
          ),
          child: Text(context.l10n.create),
        ),
      ],
    );
  }
}
