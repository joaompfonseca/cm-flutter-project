class Profile {
  String id;
  String email;
  String username;
  String cognitoId;
  String firstName;
  String lastName;
  String pictureUrl;
  DateTime createdAt;
  DateTime birthDate;
  int totalXp;
  int addedPoisCount;
  int givenRatingsCount;
  int receivedRatingsCount;

  Profile({
    required this.id,
    required this.email,
    required this.username,
    required this.cognitoId,
    required this.firstName,
    required this.lastName,
    required this.pictureUrl,
    required this.createdAt,
    required this.birthDate,
    required this.totalXp,
    required this.addedPoisCount,
    required this.givenRatingsCount,
    required this.receivedRatingsCount,
  });

  Profile.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        username = json['username'],
        cognitoId = json['cognito_id'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        pictureUrl = json['image_url'],
        createdAt = DateTime.parse(json['created_at']),
        birthDate = DateTime.parse(json['birth_date']),
        totalXp = json['total_xp'],
        addedPoisCount = json['added_pois_count'],
        givenRatingsCount = json['given_ratings_count'],
        receivedRatingsCount = json['received_ratings_count'];
}
