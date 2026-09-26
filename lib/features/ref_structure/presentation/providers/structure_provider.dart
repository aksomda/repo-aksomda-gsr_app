import 'package:flutter/material.dart';
import '../../domain/entities/structure.dart';
import '../../domain/usecases/delete_structure.dart';
import '../../domain/usecases/get_structures.dart';
import '../../domain/usecases/save_structure.dart';
import '../../../../l10n/l10n_extensions.dart';

class StructureProvider with ChangeNotifier {
  final GetStructures getStructuresUseCase;
  final SaveStructure saveStructureUseCase;
  final DeleteStructure? deleteStructureUseCase;

  List<Structure> _structures = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Structure> get structures => _structures;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  StructureProvider({
    required this.getStructuresUseCase,
    required this.saveStructureUseCase,
    this.deleteStructureUseCase,
  });

  Future<void> fetchStructures() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _structures = await getStructuresUseCase();
    } catch (_) {
      _errorMessage = AppLocale.l10n.structuresLoadError;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addOrUpdateStructure(Structure structure) async {
    final success = await saveStructureUseCase(structure);
    if (success) await fetchStructures();
    return success;
  }

  Future<bool> deleteStructure(String codeCdi) async {
    if (deleteStructureUseCase == null) return false;
    final success = await deleteStructureUseCase!(codeCdi);
    if (success) await fetchStructures();
    return success;
  }
}
