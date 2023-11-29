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

class CreatedRoute {
  String origin;
  String destination;
  List<RoutePoint> points;

  CreatedRoute({
    required this.origin,
    required this.destination,
    required this.points,
  });

  get name => "$origin - $destination";
}
