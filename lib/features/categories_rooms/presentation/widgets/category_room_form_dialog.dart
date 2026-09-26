import 'package:flutter/material.dart';
import '../../../../core/theme/gsr_colors.dart';
import '../../domain/entities/category_room.dart';
import '../../../../l10n/l10n_extensions.dart';

/// Formulaire de création/modification d'une catégorie de salle (admin).
/// Renvoie la [CategoryRoom] saisie via Navigator.pop, ou null si annulé.
Future<CategoryRoom?> showCategoryRoomFormDialog(
  BuildContext context, {
  CategoryRoom? initial,
}) {
  return showDialog<CategoryRoom>(
    context: context,
    builder: (_) => _CategoryRoomFormDialog(initial: initial),
  );
}

class _CategoryRoomFormDialog extends StatefulWidget {
  final CategoryRoom? initial;

  const _CategoryRoomFormDialog({this.initial});

  @override
  State<_CategoryRoomFormDialog> createState() =>
      _CategoryRoomFormDialogState();
}

class _CategoryRoomFormDialogState extends State<_CategoryRoomFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _libelleController;
  late final TextEditingController _montantController;
  late String _type;
  late bool _actif;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _libelleController = TextEditingController(text: initial?.libelleCat ?? '');
    _montantController = TextEditingController(
      text: initial != null && initial.montantLocation > 0
          ? initial.montantLocation.toStringAsFixed(0)
          : '',
    );
    _type = initial?.type ?? 'gratuite';
    _actif = initial == null || initial.actif == 1;
  }

  @override
  void dispose() {
    _libelleController.dispose();
    _montantController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      CategoryRoom(
        id: widget.initial?.id,
        libelleCat: _libelleController.text.trim(),
        type: _type,
        montantLocation: _type == 'location'
            ? double.tryParse(_montantController.text) ?? 0
            : 0,
        actif: _actif ? 1 : 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initial != null;

    return AlertDialog(
      title: Text(
        isEditing ? context.l10n.editCategory : context.l10n.newCategory,
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _libelleController,
                decoration: InputDecoration(labelText: context.l10n.label),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? context.l10n.labelRequired
                    : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _type,
                decoration: InputDecoration(labelText: context.l10n.type),
                items: [
                  DropdownMenuItem(
                    value: 'gratuite',
                    child: Text(context.l10n.categoryFree),
                  ),
                  DropdownMenuItem(
                    value: 'location',
                    child: Text(context.l10n.tabRental),
                  ),
                ],
                onChanged: (value) =>
                    setState(() => _type = value ?? 'gratuite'),
              ),
              if (_type == 'location') ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _montantController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: context.l10n.rentalAmountFcfa,
                  ),
                  validator: (v) {
                    if (_type != 'location') return null;
                    final amount = double.tryParse(v ?? '');
                    if (amount == null || amount <= 0) {
                      return context.l10n.invalidAmount;
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 4),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(context.l10n.active),
                value: _actif,
                onChanged: (value) => setState(() => _actif = value),
              ),
            ],
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
          child: Text(context.l10n.save),
        ),
      ],
    );
  }
}
