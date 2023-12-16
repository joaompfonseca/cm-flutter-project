import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_x/cubit/profile.dart';
import 'package:project_x/login/login.dart';
import 'package:project_x/profile/update.dart';

class StatsXp {
  final int currentLevel;
  final int xpToNextLevel;
  final int xpForCurrentLevel;
  final double progressPercentage;

  StatsXp({
    required this.currentLevel,
    required this.xpToNextLevel,
    required this.xpForCurrentLevel,
    required this.progressPercentage,
  });
}

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key});

  StatsXp getStatsXp(int totalXp) {
    const baseXp = 500;

    final level = (totalXp / baseXp).floor() + 1;
    final xpToNextLevel = baseXp * level;
    final xpForCurrentLevel = xpToNextLevel - totalXp;
    final progress = (baseXp - xpForCurrentLevel) / baseXp;

    return StatsXp(
      currentLevel: level,
      xpToNextLevel: xpToNextLevel,
      xpForCurrentLevel: xpForCurrentLevel,
      progressPercentage: progress,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, profileState) {
          final statsXp = getStatsXp(profileState.profile.totalXp);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                            child:
                                Image.network(profileState.profile.pictureUrl),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${profileState.profile.firstName} ${profileState.profile.lastName}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              profileState.profile.username,
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              profileState.profile.email,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                minimumSize: const Size(96, 32),
                                maximumSize: const Size(96, 32),
                                padding: const EdgeInsets.all(0),
                                foregroundColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const UpdateProfileForm(),
                                  ),
                                );
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    size: 16,
                                    Icons.edit,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    style: TextStyle(fontSize: 12),
                                    "Edit Profile",
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                minimumSize: const Size(96, 32),
                                maximumSize: const Size(96, 32),
                                padding: const EdgeInsets.all(0),
                                foregroundColor: const Color(0xFFFFFFFF),
                                backgroundColor: const Color(0xFFEF4444),
                              ),
                              onPressed: () {
                                signOutCurrentUser(context);
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    size: 16,
                                    Icons.logout_rounded,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    style: TextStyle(fontSize: 12),
                                    "Logout",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "This is your current level and XP",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "You gain XP for being active in the community",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ProfileXpCard(
                    currentLevel: statsXp.currentLevel,
                    totalXp: profileState.profile.totalXp,
                    xpForCurrentLevel: statsXp.xpForCurrentLevel,
                    xpToNextLevel: statsXp.xpToNextLevel,
                    progressPercentage: statsXp.progressPercentage,
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "These are your statistics",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "You can see how many POIs you have added and how many ratings you have received and given",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ProfileStatisticCard(
                    label: "Total Added POIs",
                    value: profileState.profile.addedPoisCount.toString(),
                    icon: const Icon(Icons.location_on_rounded),
                    foregroundColor: Theme.of(context).colorScheme.onTertiary,
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                  ),
                  ProfileStatisticCard(
                    label: "Total Received Ratings",
                    value: profileState.profile.receivedRatingsCount.toString(),
                    icon: const Icon(Icons.star_rounded),
                    foregroundColor: Theme.of(context).colorScheme.onTertiary,
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                  ),
                  ProfileStatisticCard(
                    label: "Total Given Ratings",
                    value: profileState.profile.givenRatingsCount.toString(),
                    icon: const Icon(Icons.auto_awesome_rounded),
                    foregroundColor: Theme.of(context).colorScheme.onTertiary,
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<void> signOutCurrentUser(BuildContext context) async {
  final result = await Amplify.Auth.signOut();
  if (result is CognitoCompleteSignOut) {
    safePrint('Sign out completed successfully');
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  } else if (result is CognitoFailedSignOut) {
    safePrint('Error signing user out: ${result.exception.message}');
  }
}

class ProfileXpCard extends StatelessWidget {
  final int currentLevel;
  final int totalXp;
  final int xpForCurrentLevel;
  final int xpToNextLevel;
  final double progressPercentage;
  final Color foregroundColor;
  final Color backgroundColor;

  const ProfileXpCard({
    super.key,
    required this.currentLevel,
    required this.totalXp,
    required this.xpForCurrentLevel,
    required this.xpToNextLevel,
    required this.progressPercentage,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Text(
              "Level $currentLevel",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: foregroundColor,
              ),
            ),
            Text(
              "$totalXp/$xpToNextLevel XP",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: foregroundColor,
                fontSize: 24,
              ),
            ),
            LinearProgressIndicator(
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
              value: progressPercentage,
              valueColor: AlwaysStoppedAnimation<Color>(
                foregroundColor,
              ),
              backgroundColor: foregroundColor.withOpacity(0.25),
            ),
            Text(
              "$xpForCurrentLevel XP to next level",
              style: TextStyle(
                color: foregroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileStatisticCard extends StatelessWidget {
  final String label;
  final String value;
  final Icon icon;
  final Color foregroundColor;
  final Color backgroundColor;

  const ProfileStatisticCard(
      {super.key,
      required this.label,
      required this.value,
      required this.icon,
      required this.foregroundColor,
      required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: SizedBox(
          height: 64,
          width: 192,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon.icon,
                    color: foregroundColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: foregroundColor,
                    ),
                  ),
                ],
              ),
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
      ),
    );
  }
}
