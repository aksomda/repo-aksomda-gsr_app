import 'package:flutter/material.dart';
import '../../l10n/l10n_extensions.dart';

class SelectOption<T> {
  final T value;
  final String label;

  const SelectOption(this.value, this.label);
}

/// Ouvre la liste filtrable ; renvoie l'option choisie, ou null si annulé.
Future<SelectOption<T>?> pickOption<T>(
  BuildContext context, {
  required String title,
  required List<SelectOption<T>> options,
  T? selected,
}) {
  return showDialog<SelectOption<T>>(
    context: context,
    builder: (_) =>
        _PickerDialog<T>(title: title, options: options, selected: selected),
  );
}

/// Champ de sélection ouvrant une liste filtrable par saisie.
class SearchableSelectField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<SelectOption<T>> options;
  final ValueChanged<T?> onChanged;
  final String? errorText;

  /// Affiche le bouton d'effacement (champs facultatifs).
  final bool clearable;

  const SearchableSelectField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.errorText,
    this.clearable = true,
  });

  SelectOption<T>? get _selected {
    for (final option in options) {
      if (option.value == value) return option;
    }
    return null;
  }

  Future<void> _open(BuildContext context) async {
    final picked = await pickOption<T>(
      context,
      title: label,
      options: options,
      selected: value,
    );
    if (picked != null) onChanged(picked.value);
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected;

    return InkWell(
      onTap: () => _open(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          suffixIcon: selected == null || !clearable
              ? const Icon(Icons.arrow_drop_down)
              : IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: context.l10n.clear,
                  onPressed: () => onChanged(null),
                ),
        ),
        isEmpty: selected == null,
        child: Text(selected?.label ?? '', overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

class _PickerDialog<T> extends StatefulWidget {
  final String title;
  final List<SelectOption<T>> options;
  final T? selected;

  const _PickerDialog({
    required this.title,
    required this.options,
    required this.selected,
  });

  @override
  State<_PickerDialog<T>> createState() => _PickerDialogState<T>();
}

class _PickerDialogState<T> extends State<_PickerDialog<T>> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final filtered = query.isEmpty
        ? widget.options
        : widget.options
              .where((o) => o.label.toLowerCase().contains(query))
              .toList();

    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 420,
        height: 360,
        child: Column(
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: context.l10n.searchHint,
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        widget.options.isEmpty
                            ? context.l10n.noOptions
                            : context.l10n.noResults,
                      ),
                    )
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final option = filtered[index];
                        return ListTile(
                          title: Text(option.label),
                          selected: option.value == widget.selected,
                          trailing: option.value == widget.selected
                              ? const Icon(Icons.check)
                              : null,
                          onTap: () => Navigator.of(context).pop(option),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.cancel),
        ),
      ],
    );
  }
}
