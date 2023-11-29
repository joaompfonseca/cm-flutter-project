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
    Poi(
      id: "poi1",
      name: "Public Bathroom",
      type: "toilets",
      description: "Free to use, in UA catacumbas.",
      latitude: 40.63071,
      longitude: -8.65875,
      pictureUrl:
          "https://www.jpn.up.pt/wp-content/uploads/2018/02/wc_p%C3%BAblica_3_06-de-fevereiro-de-2018.jpg",
      ratingPositive: 2,
      ratingNegative: 1,
      addedBy: "user1",
    ),
    Poi(
      id: "poi2",
      name: "Bycicle Parking",
      type: "bicycle-parking",
      description: "Old yellow racks that require a lock.",
      latitude: 40.63438,
      longitude: -8.65754,
      pictureUrl:
          "https://stplattaprod.blob.core.windows.net/liikenneprod/styles/og_image/azure/pyorapysakointi-jenni-huovinen.jpg?h=c176692e&itok=4KvwzNO_",
      ratingPositive: 3,
      ratingNegative: 1,
      addedBy: "user2",
    )
  ];

  List<CreatedRoute> routeList = [
    CreatedRoute(
      origin: "Aveiro",
      destination: "Porto",
      points: [
        const RoutePoint(
          label: "Aveiro",
          latitude: 40.6405,
          longitude: -8.6538,
        ),
        const RoutePoint(
          label: "Espinho",
          latitude: 41.0075,
          longitude: -8.6427,
        ),
        const RoutePoint(
          label: "Porto",
          latitude: 41.1579,
          longitude: -8.6291,
        ),
      ],
    ),
    CreatedRoute(
      origin: "Aveiro",
      destination: "Lisboa",
      points: [
        const RoutePoint(
          label: "Aveiro",
          latitude: 40.6405,
          longitude: -8.6538,
        ),
        const RoutePoint(
          label: "Lisboa",
          latitude: 38.7223,
          longitude: -9.1393,
        ),
      ],
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
