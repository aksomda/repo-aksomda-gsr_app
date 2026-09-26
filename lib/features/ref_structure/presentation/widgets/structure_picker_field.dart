import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/structure.dart';
import '../providers/structure_provider.dart';
import '../../../../l10n/l10n_extensions.dart';

/// Champ de formulaire « Structure » avec recherche rapide : un tap ouvre une
/// boîte de dialogue contenant un champ de recherche qui filtre la liste
/// (par libellé ou par code) au fil de la frappe.
class StructurePickerField extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool required;

  const StructurePickerField({
    super.key,
    required this.value,
    required this.onChanged,
    this.required = true,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StructureProvider>();
    Structure? selected;
    for (final s in provider.structures) {
      if (s.codeCdi == value) selected = s;
    }

    return FormField<String>(
      initialValue: value,
      validator: (_) =>
          required && value == null ? context.l10n.structureRequired : null,
      builder: (state) {
        final hint = provider.isLoading
            ? context.l10n.loadingStructures
            : provider.errorMessage;

        return InkWell(
          onTap: provider.isLoading
              ? null
              : provider.errorMessage != null
              ? () => context.read<StructureProvider>().fetchStructures()
              : () async {
                  final picked = await showDialog<Structure>(
                    context: context,
                    builder: (_) => _StructureSearchDialog(
                      structures: provider.structures,
                      selectedCode: value,
                    ),
                  );
                  if (picked != null) {
                    onChanged(picked.codeCdi);
                    state.didChange(picked.codeCdi);
                  }
                },
          child: InputDecorator(
            isEmpty: selected == null,
            decoration: InputDecoration(
              labelText: context.l10n.structure,
              prefixIcon: const Icon(Icons.account_tree_outlined),
              border: const OutlineInputBorder(),
              errorText: state.errorText,
              helperText: hint,
              helperMaxLines: 2,
              helperStyle: provider.errorMessage != null
                  ? const TextStyle(color: Colors.red)
                  : null,
              suffixIcon: provider.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : provider.errorMessage != null
                  ? const Icon(Icons.refresh)
                  : const Icon(Icons.arrow_drop_down),
            ),
            child: selected == null
                ? null
                : Text(
                    selected.libelleLongCdi,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
          ),
        );
      },
    );
  }
}

class _StructureSearchDialog extends StatefulWidget {
  final List<Structure> structures;
  final String? selectedCode;

  const _StructureSearchDialog({required this.structures, this.selectedCode});

  @override
  State<_StructureSearchDialog> createState() => _StructureSearchDialogState();
}

class _StructureSearchDialogState extends State<_StructureSearchDialog> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? widget.structures
        : widget.structures
              .where(
                (s) =>
                    s.libelleLongCdi.toLowerCase().contains(q) ||
                    s.codeCdi.toLowerCase().contains(q),
              )
              .toList();

    return AlertDialog(
      title: Text(context.l10n.chooseStructure),
      contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      content: SizedBox(
        width: 480,
        height: 420,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: context.l10n.searchStructure,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filtered.isEmpty
                  ? Center(child: Text(context.l10n.noStructureFound))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final s = filtered[i];
                        return ListTile(
                          dense: true,
                          selected: s.codeCdi == widget.selectedCode,
                          title: Text(s.libelleLongCdi),
                          subtitle: Text(s.codeCdi),
                          onTap: () => Navigator.of(context).pop(s),
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
