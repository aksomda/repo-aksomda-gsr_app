import 'package:flutter/material.dart';
import '../../../domain/entities/category_room.dart';
import '../../../domain/usecases/get_category_rooms.dart';
import '../../../domain/usecases/save_category_room.dart';

class CategoryRoomProvider with ChangeNotifier {
  final GetCategoryRooms getCategoryRoomsUseCase;
  final SaveCategoryRoom saveCategoryRoomUseCase;

  // ignore: non_constant_identifier_names
  List<CategoryRoom> _categoryRooms = [];
  bool _isLoading = false;

  List<CategoryRoom> get categoryRoom => _categoryRooms;
  bool get isLoading => _isLoading;

  CategoryRoomProvider({
    required this.getCategoryRoomsUseCase,
    required this.saveCategoryRoomUseCase,
  });

  Future<void> fetchRooms() async {
    _isLoading = true;
    notifyListeners();
    _categoryRooms = await getCategoryRoomsUseCase();
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

  List<CategoryRoom> getCategoryRoomsByLibelleCat(String libelleCat) {
    return _categoryRooms
        .where((r) => r.libelleCat.toLowerCase() == libelleCat.toLowerCase())
        .toList();
  }
}
