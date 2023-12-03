class RoutePoint {
  final String label;
  final double longitude;
  final double latitude;

  const RoutePoint({
    required this.label,
    required this.longitude,
    required this.latitude,
  });
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
