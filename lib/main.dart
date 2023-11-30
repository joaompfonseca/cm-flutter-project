import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_map/app.dart';
import 'package:hw_map/cubit/map.dart';
import 'package:hw_map/cubit/poi.dart';
import 'package:hw_map/cubit/route.dart';
import 'package:hw_map/map/config.dart';
import 'package:hw_map/mock/poi.dart';
import 'package:hw_map/mock/route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project X App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<MapCubit>(
            create: (context) => MapCubit(
              MapState(
                mapController,
                osmOption,
              ),
            ),
          ),
          BlocProvider<PoiCubit>(
            create: (context) => PoiCubit(mockPoiList),
          ),
          BlocProvider<RouteCubit>(
            create: (context) => RouteCubit(mockRouteList),
          ),
        ],
        child: const App(),
      ),
    );
  }
}
