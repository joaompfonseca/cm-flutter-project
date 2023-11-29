import 'package:hw_map/route/route.dart';

List<CreatedRoute> mockRouteList = [
  CreatedRoute(
    id: "route1",
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
    id: "route2",
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

CreatedRoute mockRoute(int i) => CreatedRoute(
      id: "route$i",
      origin: "route$i origin",
      destination: "route$i destination",
      points: [
        RoutePoint(
          label: "route$i origin",
          latitude: 40.63398,
          longitude: -8.65812,
        ),
        RoutePoint(
          label: "route$i destination",
          latitude: 40.63511,
          longitude: -8.65658,
        ),
      ],
    );
