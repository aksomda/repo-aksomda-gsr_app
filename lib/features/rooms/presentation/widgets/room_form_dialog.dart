import 'package:flutter/material.dart';
import '../../../../core/theme/gsr_colors.dart';
import '../../../categories_rooms/domain/entities/category_room.dart';
import '../../../directions_regionales/domain/entities/direction_regionale.dart';
import '../../domain/entities/room.dart';
import '../../../../core/widgets/searchable_select_field.dart';
import '../../../../l10n/l10n_extensions.dart';

const _statuses = [
  'disponible',
  'reservé',
  'en refection',
  'dégradé',
  'en construction',
];

/// Formulaire de création/modification d'une salle (admin).
Future<Room?> showRoomFormDialog(
  BuildContext context, {
  Room? initial,
  required List<CategoryRoom> categories,
  required List<DirectionRegionale> directions,
}) {
  return showDialog<Room>(
    context: context,
    builder: (_) => _RoomFormDialog(
      initial: initial,
      categories: categories,
      directions: directions,
    ),
  );
}

class _RoomFormDialog extends StatefulWidget {
  final Room? initial;
  final List<CategoryRoom> categories;
  final List<DirectionRegionale> directions;

  const _RoomFormDialog({
    this.initial,
    required this.categories,
    required this.directions,
  });

  @override
  State<_RoomFormDialog> createState() => _RoomFormDialogState();
}

class _RoomFormDialogState extends State<_RoomFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _regionController;
  late final TextEditingController _provinceController;
  late final TextEditingController _cityController;
  late final TextEditingController _locationController;
  late final TextEditingController _computerCountController;
  late final TextEditingController _rentalAmountController;
  late bool _hasComputer;
  int? _categoryId;
  String? _directionRegionaleId;
  bool _categoryMissing = false;
  late String _status;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _nameController = TextEditingController(text: initial?.name ?? '');
    _regionController = TextEditingController(text: initial?.region ?? '');
    _provinceController = TextEditingController(text: initial?.province ?? '');
    _cityController = TextEditingController(text: initial?.city ?? '');
    _locationController = TextEditingController(text: initial?.location ?? '');
    _computerCountController = TextEditingController(
      text: (initial?.computerCount ?? 0).toString(),
    );
    _rentalAmountController = TextEditingController(
      text: (initial?.rentalAmount ?? 0).toStringAsFixed(0),
    );
    _hasComputer = initial?.hasComputer ?? false;
    _categoryId = initial?.categoryId;
    _directionRegionaleId = initial?.directionRegionaleId;
    _status = initial?.status ?? _statuses.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _regionController.dispose();
    _provinceController.dispose();
    _cityController.dispose();
    _locationController.dispose();
    _computerCountController.dispose();
    _rentalAmountController.dispose();
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? context.l10n.fieldRequired : null;

  void _submit() {
    final formValid = _formKey.currentState!.validate();
    // category_room_id est NOT NULL en base.
    setState(() => _categoryMissing = _categoryId == null);
    if (!formValid || _categoryId == null) return;

    Navigator.of(context).pop(
      Room(
        id: widget.initial?.id,
        name: _nameController.text.trim(),
        region: _regionController.text.trim(),
        province: _provinceController.text.trim(),
        city: _cityController.text.trim(),
        location: _locationController.text.trim(),
        hasComputer: _hasComputer,
        computerCount: int.tryParse(_computerCountController.text) ?? 0,
        categoryId: _categoryId,
        directionRegionaleId: _directionRegionaleId,
        rentalAmount: double.tryParse(_rentalAmountController.text) ?? 0,
        status: _status,
      ),
    );
  }

  /// Deux champs côte à côte quand la place le permet, empilés sinon.
  Widget _pair(Widget left, Widget right) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 480) {
          return Column(children: [left, const SizedBox(height: 12), right]);
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
    final isEditing = widget.initial != null;

    return AlertDialog(
      title: Text(isEditing ? context.l10n.editRoom : context.l10n.newRoom),
      content: SizedBox(
        width: 640,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: context.l10n.roomName),
                  validator: _required,
                ),
                const SizedBox(height: 12),
                _pair(
                  TextFormField(
                    controller: _regionController,
                    decoration: InputDecoration(labelText: context.l10n.region),
                    validator: _required,
                  ),
                  TextFormField(
                    controller: _provinceController,
                    decoration: InputDecoration(
                      labelText: context.l10n.province,
                    ),
                    validator: _required,
                  ),
                ),
                const SizedBox(height: 12),
                _pair(
                  TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(labelText: context.l10n.city),
                    validator: _required,
                  ),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: context.l10n.location,
                    ),
                    validator: _required,
                  ),
                ),
                const SizedBox(height: 12),
                _pair(
                  SearchableSelectField<int>(
                    label: context.l10n.category,
                    value: _categoryId,
                    options: widget.categories
                        .where((c) => c.id != null)
                        .map((c) => SelectOption(c.id!, c.libelleCat))
                        .toList(),
                    clearable: false,
                    errorText: _categoryMissing
                        ? context.l10n.fieldRequired
                        : null,
                    onChanged: (value) => setState(() {
                      _categoryId = value;
                      _categoryMissing = false;
                    }),
                  ),
                  SearchableSelectField<String>(
                    label: context.l10n.regionalDirection,
                    value: _directionRegionaleId,
                    options: widget.directions
                        .where((d) => d.id != null)
                        .map((d) => SelectOption(d.id!, d.nom))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _directionRegionaleId = value),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _status,
                  decoration: InputDecoration(labelText: context.l10n.status),
                  items: _statuses
                      .map(
                        (s) => DropdownMenuItem(
                          value: s,
                          child: Text(context.l10n.roomStatusName(s)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _status = value ?? _statuses.first),
                ),
                const SizedBox(height: 12),
                _pair(
                  TextFormField(
                    controller: _rentalAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: context.l10n.rentalAmountFree,
                    ),
                  ),
                  TextFormField(
                    controller: _computerCountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: context.l10n.computerCount,
                    ),
                  ),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(context.l10n.equippedComputers),
                  value: _hasComputer,
                  onChanged: (value) => setState(() => _hasComputer = value),
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
          child: Text(context.l10n.save),
        ),
      ],
    );
  }
}
