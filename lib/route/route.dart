/// Created routes are routes where the user specifies the points, and the path
/// is calculated using the routing engine to display on the map.

class CreatedRoutePoint {
  final String label;
  final double longitude;
  final double latitude;

  const CreatedRoutePoint({
    required this.label,
    required this.longitude,
    required this.latitude,
  });
}

class CreatedRoute {
  String id;
  List<CreatedRoutePoint> points;

  CreatedRoute({
    required this.id,
    required this.points,
  });

  get name => "${points.first.label} - ${points.last.label}";
}

/// Tracked routes are routes recorded using the user's location, and the path
/// of points is displayed directly on the map.

class TrackedRoutePoint {
  final String label;
  final double longitude;
  final double latitude;

  const TrackedRoutePoint({
    required this.label,
    required this.longitude,
    required this.latitude,
  });
}

class TrackedRoute {
  String id;
  String origin;
  String destination;
  List<TrackedRoutePoint> points;

  TrackedRoute({
    required this.id,
    required this.origin,
    required this.destination,
    required this.points,
  });
}
