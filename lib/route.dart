class RecordedRoute {
  final String origin;
  final String destination;

  const RecordedRoute({
    required this.origin,
    required this.destination,
  });

  get name => "$origin - $destination";
}
