# GsrApp - Gestion des salles de réunions et des réservations

Application Flutter production-ready connectée à une base de données MySQL (`dbgsr`) via l'API `api_GsrApp`.

## Architecture & Setup
- **Architecture**: Presentation,
- **Setup**: `flutter pub get` puis `flutter run`.
- **CI/CD**: GitHub Actions configuré pour analyse statique et tests unitaires/widgets.

## STRUCTURE DU CODE SOURCE
├──client
│	├──assets
│	│	├──images/
│	├──lib
│	│   ├──core/
│	│   │   ├── network/
│	│   ├── errors/
│	│   ├── features/
│	│   │   ├── categories_rooms/
│	│   │   │   ├── data/
│	│   │   │   │   ├── datasources/
│	│   │   │   │   │   └── category_room_remote_data_source.dart
│	│   │   │   │   ├── models/
│	│   │   │   │   │   └── category_room_model.dart
│	│   │   │   │   └── repositories/
│	│   │   │   │       └── category_room_repository_impl.dart
│	│   │   │   ├── domain/
│	│   │   │   │   ├── entities/
│	│   │   │   │   │    └── category_room.dart
│	│   │   │   │   ├── repositories/
│	│   │   │   │   │   └── category_room_repository.dart
│	│   │   │   │   └── usecases/
│	│   │   │   │        ├── get_category_rooms.dart
│	│   │   │   │        └── save_category_room.dart
│	│   │   │   ├── presentation/
│	│   │   │   │   ├── bloc/
│	│   │   │   │   ├──providers/
│	│   │   │   │   │   └── category_room_provider.dart
│	│   │   │   ├── screens/
│	│   │   │   │   └── category_rooms_screen.dart
│	│   │   │   └── widgets/
│	│   │   │       └── category_room_card.dart
│	│   │   ├── rooms/
│	│   │   │   ├── data/
│	│   │   │   │   ├── datasources/
│	│   │   │   │   │   └── room_remote_data_source.dart
│	│   │   │   │   ├── models/
│	│   │   │   │   │   └── room_model.dart
│	│   │   │   │   └── repositories/
│	│   │   │   │       └── room_repository_impl.dart
│	│   │   │   ├── domain/
│	│   │   │   │   ├── entities/
│	│   │   │   │   │    └── room.dart
│	│   │   │   │   ├── repositories/
│	│   │   │   │   │   └── room_repository.dart
│	│   │   │   ├── usecases/
│	│   │   │   │    ├── get_rooms.dart
│	│   │   │   │    └── save_room.dart
│	│   │   │   ├── presentation/
│	│   │   │   │    ├── bloc/
│	│   │   │   │    │   ├──providers/
│	│   │   │   │    │   │   └── room_provider.dart
│	│   │   │   │    ├── screens/
│	│   │   │   │    │   └── rooms_screen.dart
│	│   │   │   │    ├──  widgets/
│	│   │   │   │    │     └── room_card.dart
│	│   │   ├── reservations_rooms/
│	│   │   │   ├── data/
│	│   │   │   │   ├── datasources/
│	│   │   │   │   │   └── reservation_room_remote_data_source.dart
│	│   │   │   │   ├── models/
│	│   │   │   │   │   └── reservation_room_model.dart
│	│   │   │   │   └── repositories/
│	│   │   │   │       └── reservation_room_repository_impl.dart
│	│   │   │   ├── domain/
│	│   │   │   │   ├── entities/
│	│   │   │   │   │    └── reservation_room.dart
│	│   │   │   │   ├── repositories/
│	│   │   │   │   │   └── reservation_room_repository.dart
│	│   │   │   │   └── usecases/
│	│   │   │   │        ├── get_reservation_rooms.dart
│	│   │   │   │        └── save_reservation_room.dart
│	│   │   │   ├── presentation/
│	│   │   │   │   ├── bloc/
│	│   │   │   │   │   ├──providers/
│	│   │   │   │   │   │    └── reservation_room_provider.dart
│	│   │   │   │   ├── screens/
│	│   │   │   │   │    └── reservation_rooms_screen.dart
│	│   │   │   └── widgets/
│	│   │   │       └── reservation_room_card.dart
│	│   │   ├── statistics/
│	│   │   │   ├── data/
│	│   │   │   │   ├── datasources/
│	│   │   │   │   │   └── statistic_room_remote_data_source.dart
│	│   │   │   │   ├── models/
│	│   │   │   │   │   └── statistic_room_model.dart
│	│   │   │   │   └── repositories/
│	│   │   │   │       └── statistic_room_repository_impl.dart
│	│   │   │   ├── domain/
│	│   │   │   │   ├── entities/
│	│   │   │   │   │    └── statistic_room.dart
│	│   │   │   │   ├── repositories/
│	│   │   │   │   │   └── statistic_room_repository.dart
│	│   │   │   │   └── usecases/
│	│   │   │   │        ├── statistic_rooms.dart
│	│   │   │   ├── presentation/
│	│   │   │   │   ├── bloc/
│	│   │   │   │   │   ├──providers/
│	│   │   │   │   │   │    └── statistic_room_provider.dart
│	│   │   │   │   ├── screens/
│	│   │   │   │   │    └── statistic_rooms_screen.dart
│	│   │   │   └── widgets/
│	│   │   │       └── statistic_room_card.dart
├──server
│	├──config
│	│   ├──db.js
│	├──controllers
│	│   ├──roomControllers.js
│	├──routes
│	│   ├──roomRoutes.js
│	├──package.json
│	├──server.js
├──test
│	├──unit_test.dart
│	├──widget_test.dart