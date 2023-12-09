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

class PoiInd {
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
  bool status;
  String rate;

  PoiInd({
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
    required this.status,
    required this.rate,
  });

  PoiInd.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        type = json['type'],
        description = json['description'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        pictureUrl = json['picture_url'],
        ratingPositive = json['rating_positive'],
        ratingNegative = json['rating_negative'],
        addedBy = json['added_by'],
        status = json['status'],
        rate = json['rate'].toString();

  toPoi() {
    return Poi(
      id: id,
      name: name,
      type: type,
      description: description,
      latitude: latitude,
      longitude: longitude,
      pictureUrl: pictureUrl,
      ratingPositive: ratingPositive,
      ratingNegative: ratingNegative,
      addedBy: addedBy,
    );
  }
}
