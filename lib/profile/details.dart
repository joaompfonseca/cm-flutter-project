import 'package:flutter/material.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
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
                    width: 128,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.network("https://picsum.photos/seed/1/600"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "John Doe",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      Text(
                        "Username",
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
                      value: "1337",
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
                      value: "5",
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
                      value: "15",
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
                      value: "3",
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
