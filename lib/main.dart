import 'package:flutter/material.dart';
import 'package:hw_map/app.dart';
import 'package:hw_map/poi.dart';
import 'package:hw_map/route.dart';

void main() {
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  List<Poi> poiList = [
    const Poi(
      name: "Public Bathroom",
      description: "Free to use, in UA catacumbas.",
      latitude: 40.63071,
      longitude: -8.65875,
    ),
    const Poi(
      name: "Bycicle Parking",
      description: "Old yellow racks that require a lock.",
      latitude: 40.63438,
      longitude: -8.65754,
    )
  ];

  List<RecordedRoute> routeList = [
    const RecordedRoute(
      origin: "Aveiro Train Station",
      destination: "Glicínias Plaza",
    ),
    const RecordedRoute(
      origin: "Aveiro Lourenço Peixinho Avenue",
      destination: "University of Aveiro",
    ),
  ];

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project X App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.orangeAccent,
          foregroundColor: Colors.black,
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.black,
          indicatorColor: Colors.black,
          unselectedLabelColor: Colors.black45,
        ),
        listTileTheme: const ListTileThemeData(
          tileColor: Color.fromRGBO(255, 243, 224, 1),
          selectedTileColor: Colors.orange,
          iconColor: Colors.black,
          textColor: Colors.black,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.orangeAccent,
          foregroundColor: Colors.black,
        ),
        useMaterial3: true,
      ),
      home: App(
        poiList: poiList,
        routeList: routeList,
      ),
    );
  }
}
