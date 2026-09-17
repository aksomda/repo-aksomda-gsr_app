import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/rooms/data/datasources/room_remote_data_source.dart';
import 'features/rooms/data/repositories/room_repository_impl.dart';
import 'features/rooms/domain/usecases/get_rooms.dart';
import 'features/rooms/domain/usecases/save_room.dart';
import 'features/rooms/presentation/bloc/providers/room_provider.dart';

import 'features/categories_rooms/data/datasources/category_room_remote_data_source.dart';
import 'features/categories_rooms/data/repositories/category_room_repository_impl.dart';
import 'features/categories_rooms/domain/usecases/get_category_rooms.dart';
import 'features/categories_rooms/domain/usecases/save_category_room.dart';
import 'features/categories_rooms/presentation/bloc/providers/category_room_provider.dart';

import 'features/reservations_rooms/data/datasources/reservation_room_remote_data_source.dart';
import 'features/reservations_rooms/data/repositories/reservation_room_repository_impl.dart';
import 'features/reservations_rooms/domain/usecases/get_reservation_rooms.dart';
import 'features/reservations_rooms/domain/usecases/save_reservation_room.dart';
import 'features/reservations_rooms/presentation/providers/reservation_room_provider.dart';

import 'l10n/app_localizations.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  final roomRemoteDataSource = RoomRemoteDataSource();
  final roomRepository = RoomRepositoryImpl(roomRemoteDataSource);
  final getRooms = GetRooms(roomRepository);
  final saveRoom = SaveRoom(roomRepository);

  final categoryRemoteDataSource = CategoryRoomRemoteDataSource();
  final categoryRepository = CategoryRoomRepositoryImpl(categoryRemoteDataSource);
  final getCategoryRooms = GetCategoryRooms(categoryRepository);
  final saveCategoryRoom = SaveCategoryRoom(categoryRepository);

  final reservationRemoteDataSource = ReservationRoomRemoteDataSource();
  final reservationRepository = ReservationRoomRepositoryImpl(reservationRemoteDataSource);
  final getReservationRooms = GetReservationRooms(reservationRepository);
  final saveReservationRoom = SaveReservationRoom(reservationRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RoomProvider(
            getRoomsUseCase: getRooms,
            saveRoomUseCase: saveRoom,
          )..fetchRooms(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryRoomProvider(
            getCategoryRoomsUseCase: getCategoryRooms,
            saveCategoryRoomUseCase: saveCategoryRoom,
          )..fetchRooms(),
        ),
        ChangeNotifierProvider(
          create: (_) => ReservationRoomProvider(
            getReservationRoomsUseCase: getReservationRooms,
            saveReservationRoomUseCase: saveReservationRoom,
          )..fetchReservations(),
        ),
      ],
      child: const GsrApp(),
    ),
  );
}

class GsrApp extends StatelessWidget {
  const GsrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GsrApp',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MainNavigationScreen(),
    );
  }
}
