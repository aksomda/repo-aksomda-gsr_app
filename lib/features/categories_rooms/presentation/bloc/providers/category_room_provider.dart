import 'package:flutter/material.dart';
import '../../../domain/entities/category_room.dart';
import '../../../domain/usecases/delete_category_room.dart';
import '../../../domain/usecases/get_category_rooms.dart';
import '../../../domain/usecases/save_category_room.dart';
import '../../../../../core/network/api_client.dart';

class CategoryRoomProvider with ChangeNotifier {
  final GetCategoryRooms getCategoryRoomsUseCase;
  final SaveCategoryRoom saveCategoryRoomUseCase;
  final DeleteCategoryRoom? deleteCategoryRoomUseCase;

  List<CategoryRoom> _categoryRooms = [];
  bool _isLoading = false;
  String? _error;

  /// Message de la dernière erreur de chargement, null si tout va bien.
  String? get error => _error;

  List<CategoryRoom> get categoryRoom => _categoryRooms;
  bool get isLoading => _isLoading;

  CategoryRoomProvider({
    required this.getCategoryRoomsUseCase,
    required this.saveCategoryRoomUseCase,
    this.deleteCategoryRoomUseCase,
  });

  Future<void> fetchRooms() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _categoryRooms = await getCategoryRoomsUseCase();
    } catch (e) {
      _error = errorMessageOf(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addOrUpdateCategoryRoom(CategoryRoom categoryRoom) async {
    bool success = await saveCategoryRoomUseCase(categoryRoom);
    if (success) {
      await fetchRooms();
    }
    return success;
  }

  Future<bool> deleteCategoryRoom(int id) async {
    if (deleteCategoryRoomUseCase == null) return false;
    final success = await deleteCategoryRoomUseCase!(id);
    if (success) {
      await fetchRooms();
    }
    return success;
  }

  List<CategoryRoom> getCategoryRoomsByType(String type) {
    return _categoryRooms.where((r) => r.type == type).toList();
  }
}
