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

  Poi.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        type = json['type'],
        description = json['description'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        pictureUrl = json['picture_url'],
        ratingPositive = json['rating_positive'],
        ratingNegative = json['rating_negative'],
        addedBy = json['added_by'];
}
