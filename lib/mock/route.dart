import 'package:hw_map/route/route.dart';

List<CreatedRoute> mockCreatedRouteList = [
  CreatedRoute(
    id: "route1",
    points: [
      const CreatedRoutePoint(
        label: "Aveiro",
        latitude: 40.6405,
        longitude: -8.6538,
      ),
      const CreatedRoutePoint(
        label: "Espinho",
        latitude: 41.0075,
        longitude: -8.6427,
      ),
      const CreatedRoutePoint(
        label: "Porto",
        latitude: 41.1579,
        longitude: -8.6291,
      ),
    ],
  ),
  CreatedRoute(
    id: "route2",
    points: [
      const CreatedRoutePoint(
        label: "Aveiro",
        latitude: 40.6405,
        longitude: -8.6538,
      ),
      const CreatedRoutePoint(
        label: "Lisboa",
        latitude: 38.7223,
        longitude: -9.1393,
      ),
    ],
  ),
];

CreatedRoute mockCreatedRoute(int i) => CreatedRoute(
      id: "route$i",
      points: [
        CreatedRoutePoint(
          label: "route$i origin",
          latitude: 40.63398,
          longitude: -8.65812,
        ),
        CreatedRoutePoint(
          label: "route$i destination",
          latitude: 40.63511,
          longitude: -8.65658,
        ),
      ],
    );
