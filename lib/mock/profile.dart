import 'package:project_x/profile/profile.dart';

Profile mockProfile = Profile(
  id: "testUser",
  email: "test@ua.pt",
  username: "testUser",
  cognitoId: "testUser",
  firstName: "Test",
  lastName: "User",
  pictureUrl:
      "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cmFuZG9tJTIwcGVyc29ufGVufDB8fDB8fHww",
  createdAt: DateTime.now(),
  birthDate: DateTime.now(),
  totalXp: 1337,
  addedPoisCount: 10,
  givenRatingsCount: 5,
  receivedRatingsCount: 3,
);
