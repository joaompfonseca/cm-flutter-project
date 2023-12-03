class Point {
  final double longitude;
  final double latitude;

  const Point({
    required this.longitude,
    required this.latitude,
  });
}

class RoutePoint extends Point {
  final String label;

  const RoutePoint({
    required this.label,
    required double longitude,
    required double latitude,
  }) : super(longitude: longitude, latitude: latitude);
}

class CustomRoute {
  String id;
  List<RoutePoint> points;

  CustomRoute({
    required this.id,
    required this.points,
  });

  get name => "${points.first.label} - ${points.last.label}";
}
