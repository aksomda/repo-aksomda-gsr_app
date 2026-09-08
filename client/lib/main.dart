import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/rooms/data/datasources/room_remote_data_source.dart';
import 'features/rooms/data/repositories/room_repository_impl.dart';
import 'features/rooms/domain/usecases/get_rooms.dart';
import 'features/rooms/domain/usecases/save_room.dart';
import 'features/rooms/presentation/providers/room_provider.dart';
import 'features/rooms/presentation/screens/rooms_screen.dart';

void main() {
  final remoteDataSource = RoomRemoteDataSource();
  final repository = RoomRepositoryImpl(remoteDataSource);
  final getRooms = GetRooms(repository);
  final saveRoom = SaveRoom(repository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              RoomProvider(getRoomsUseCase: getRooms, saveRoomUseCase: saveRoom)
                ..fetchRooms(),
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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RoomsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
