import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_x/cubit/profile.dart';
import 'package:project_x/login/login.dart';
import 'package:project_x/profile/update.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileCubit profileCubit = context.read<ProfileCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 256,
                    width: 192,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Image.network(
                            profileCubit.state.profile.pictureUrl),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${profileCubit.state.profile.firstName} ${profileCubit.state.profile.lastName}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      Text(
                        profileCubit.state.profile.username,
                      ),
                      Text(
                        profileCubit.state.profile.email,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UpdateProfileForm(),
                            ),
                          );
                        },
                        child: const Row(children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text("Edit Profile"),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          foregroundColor: const Color(0xFFFFFFFF),
                          backgroundColor: const Color(0xFFEF4444),
                          padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
                        ),
                        onPressed: () {
                          signOutCurrentUser(context);
                        },
                        child: const Row(children: [
                          Icon(Icons.logout),
                          SizedBox(width: 8),
                          Text("Logout"),
                        ]),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ProfileStatisticCard(
                      label: "Total XP",
                      value: profileCubit.state.profile.totalXp.toString(),
                      foregroundColor:
                          Theme.of(context).colorScheme.onSecondary,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ProfileStatisticCard(
                      label: "Created POIs",
                      value:
                          profileCubit.state.profile.addedPoisCount.toString(),
                      foregroundColor: Theme.of(context).colorScheme.onTertiary,
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ProfileStatisticCard(
                      label: "Given Ratings",
                      value: profileCubit.state.profile.givenRatingsCount
                          .toString(),
                      foregroundColor: Theme.of(context).colorScheme.onTertiary,
                      backgroundColor:
                          Theme.of(context).colorScheme.tertiary.withAlpha(192),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ProfileStatisticCard(
                      label: "Received Ratings",
                      value: profileCubit.state.profile.receivedRatingsCount
                          .toString(),
                      foregroundColor: Theme.of(context).colorScheme.onTertiary,
                      backgroundColor:
                          Theme.of(context).colorScheme.tertiary.withAlpha(128),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> signOutCurrentUser(BuildContext context) async {
  final result = await Amplify.Auth.signOut();
  if (result is CognitoCompleteSignOut) {
    safePrint('Sign out completed successfully');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  } else if (result is CognitoFailedSignOut) {
    safePrint('Error signing user out: ${result.exception.message}');
  }
}

class ProfileStatisticCard extends StatelessWidget {
  final String label;
  final String value;
  final Color foregroundColor;
  final Color backgroundColor;

  const ProfileStatisticCard(
      {super.key,
      required this.label,
      required this.value,
      required this.foregroundColor,
      required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: foregroundColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: foregroundColor,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
