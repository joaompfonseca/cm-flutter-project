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
}
