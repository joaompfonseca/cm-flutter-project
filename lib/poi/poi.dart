class Poi {
  String id;
  String name;
  String type;
  String description;
  double latitude;
  double longitude;
  String pictureUrl;
  int ratingPositive;
  int ratingNegative;
  String addedBy;

  Poi({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.pictureUrl,
    required this.ratingPositive,
    required this.ratingNegative,
    required this.addedBy,
  });
}
