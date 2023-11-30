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
      theme: ThemeData(
        // Daisy UI Light
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF491EFF), // primary
          onPrimary: Color(0xFFFFFFFF), // base 100
          secondary: Color(0xFFFF41C7), // secondary
          onSecondary: Color(0xFFFFFFFF), // base 100
          tertiary: Color(0xFF00CFBD), // accent
          onTertiary: Color(0xFFFFFFFF), // base 100
          error: Color(0xFFEF4444), // CUSTOM
          onError: Color(0xFFFFFFFF), // base 100
          background: Color(0xFFFFFFFF), // base 100
          onBackground: Color(0xFF1F2937), // base content
          surface: Color(0xFFFFFFFF), // base 100
          onSurface: Color(0xFF1F2937), // base content
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2B3440), // neutral
          foregroundColor: Color(0xFFD7DDE4), // neutral content
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF1F2937), // base content
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        // Daisy UI Dark
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF7582FF), // primary
          onPrimary: Color(0xFF1D232A), // base 100
          secondary: Color(0xFFFF71CF), // secondary
          onSecondary: Color(0xFF1D232A), // base 100
          tertiary: Color(0xFF00C7B5), // accent
          onTertiary: Color(0xFF1D232A), // base 100
          error: Color(0xFFEF4444), // CUSTOM
          onError: Color(0xFF1D232A), // base 100
          background: Color(0xFF1D232A), // base 100
          onBackground: Color(0xFFA6ADBB), // base content
          surface: Color(0xFF1D232A), // base 100
          onSurface: Color(0xFFA6ADBB), // base content
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2A323C), // neutral
          foregroundColor: Color(0xFFA6ADBB), // neutral content
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFA6ADBB), // base content
        ),
        useMaterial3: true,
      ),
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
