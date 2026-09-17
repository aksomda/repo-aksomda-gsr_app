import 'package:gsr_app/features/rooms/domain/entities/room.dart';
import 'package:gsr_app/features/rooms/domain/repositories/room_repository.dart';
import 'package:gsr_app/features/categories_rooms/domain/entities/category_room.dart';
import 'package:gsr_app/features/categories_rooms/domain/repositories/category_room_repository.dart';
import 'package:gsr_app/features/reservations_rooms/domain/entities/reservation_room.dart';
import 'package:gsr_app/features/reservations_rooms/domain/repositories/reservation_room_repository.dart';

/// Fausse implémentation en mémoire de [RoomRepository], utilisée pour isoler
/// les tests des appels réseau réels.
class FakeRoomRepository implements RoomRepository {
  List<Room> rooms;

  FakeRoomRepository({List<Room>? initialRooms}) : rooms = initialRooms ?? _defaultRooms();

  static List<Room> _defaultRooms() => [
        Room(
          id: 1,
          name: 'Salle Panafricaine',
          region: 'Centre',
          province: 'Kadiogo',
          city: 'Ouagadougou',
          location: 'Bloc A',
          hasComputer: true,
          computerCount: 10,
          category: 'gratuit',
          rentalAmount: 0,
          status: 'disponible',
        ),
        Room(
          id: 2,
          name: 'Salle Nazi Boni',
          region: 'Hauts-Bassins',
          province: 'Houet',
          city: 'Bobo-Dioulasso',
          location: 'Bloc B',
          hasComputer: false,
          computerCount: 0,
          category: 'location',
          rentalAmount: 25000,
          status: 'reservé',
        ),
      ];

  @override
  Future<List<Room>> getRooms() async => rooms;

  @override
  Future<bool> saveRoom(Room room) async {
    rooms = [...rooms, room];
    return true;
  }

  @override
  Future<bool> deleteRoom(int id) async {
    rooms = rooms.where((r) => r.id != id).toList();
    return true;
  }
}

/// Fausse implémentation en mémoire de [CategoryRoomRepository].
class FakeCategoryRoomRepository implements CategoryRoomRepository {
  List<CategoryRoom> categoryRooms;

  FakeCategoryRoomRepository({List<CategoryRoom>? initial})
      : categoryRooms = initial ?? _defaultCategories();

  static List<CategoryRoom> _defaultCategories() => [
        CategoryRoom(id: 1, libelleCat: 'GRATUIT', montantLocation: 0, actif: 1),
        CategoryRoom(id: 2, libelleCat: 'LOCATION', montantLocation: 15000, actif: 1),
      ];

  @override
  Future<List<CategoryRoom>> getCategoryRooms() async => categoryRooms;

  @override
  Future<bool> saveCategoryRoom(CategoryRoom room) async {
    categoryRooms = [...categoryRooms, room];
    return true;
  }

  @override
  Future<bool> deleteCategoryRoom(int id) async {
    categoryRooms = categoryRooms.where((c) => c.id != id).toList();
    return true;
  }
}

/// Fausse implémentation en mémoire de [ReservationRoomRepository].
class FakeReservationRoomRepository implements ReservationRoomRepository {
  List<ReservationRoom> reservations;

  FakeReservationRoomRepository({List<ReservationRoom>? initial})
      : reservations = initial ?? _defaultReservations();

  static List<ReservationRoom> _defaultReservations() => [
        ReservationRoom(
          id: 1,
          meetingSubject: 'Revue budgétaire',
          organizingStructure: 'DGB',
          date: '2026-09-10',
          startTime: '09:00',
          endTime: '11:00',
          state: 'en cours',
          status: 'disponible',
        ),
        ReservationRoom(
          id: 2,
          meetingSubject: 'Comité de pilotage',
          organizingStructure: 'DGI',
          date: '2026-09-11',
          startTime: '14:00',
          endTime: '16:00',
          state: 'traitée',
          status: 'reservé',
        ),
      ];

  @override
  Future<List<ReservationRoom>> getReservationRooms() async => reservations;

  @override
  Future<bool> saveReservationRoom(ReservationRoom reservation) async {
    reservations = [...reservations, reservation];
    return true;
  }

  @override
  Future<bool> deleteReservationRoom(int id) async {
    reservations = reservations.where((r) => r.id != id).toList();
    return true;
  }
}
