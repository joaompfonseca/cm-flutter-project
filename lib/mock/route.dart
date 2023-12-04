import 'package:project_x/route/route.dart';

List<CustomRoute> mockRouteList = [
  CustomRoute(
    id: "route1",
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
  CustomRoute(
    id: "route2",
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

CustomRoute mockRoute(int i) => CustomRoute(
      id: "route$i",
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
