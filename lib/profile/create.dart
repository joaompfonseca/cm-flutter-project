import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_x/app.dart';
import 'package:project_x/cubit/profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateProfileForm extends StatefulWidget {
  const CreateProfileForm({super.key});

  @override
  State<CreateProfileForm> createState() => _CreateProfileFormState();
}

class _CreateProfileFormState extends State<CreateProfileForm> {
  late TextEditingController emailController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController usernameController;
  late TextEditingController dateController;

  @override
  void initState() {
    emailController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    usernameController = TextEditingController();
    dateController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const SizedBox(height: 48),
            const Icon(
              size: 128,
              Icons.person_add_alt_1_rounded,
            ),
            const SizedBox(height: 8),
            const Text(
              "Almost there!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Let's configure your profile",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "What's your name? How can we contact you?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "The information you provided on sign up is only used in the authentication process, not the app itself",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 8),
            // First Name and Last Name
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      labelText: "First Name",
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.normal,
                      ),
                      hintText: "Type your first name",
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      labelText: "Last Name",
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.normal,
                      ),
                      hintText: "Type your last name",
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Email
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                labelText: "Email",
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.normal,
                ),
                hintText: "Type your email",
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.normal,
                ),
              ),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Your username will be visible to other users",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "You can change it later",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 8),
            // Username
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                labelText: "Username",
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.normal,
                ),
                hintText: "Type your username",
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.normal,
                ),
              ),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "We want to know your birthday!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Disclaimer: no cakes will be sent to you",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 8),
            // Birth Date
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                labelText: "Birth Date",
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.normal,
                ),
                hintText: "Choose your birth date",
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.normal,
                ),
                icon: const Icon(Icons.calendar_month_rounded),
              ),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.normal,
              ),
              readOnly: true, // when true user cannot edit text
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(), //get today's date
                    firstDate: DateTime(
                        2000), //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2101));

                if (pickedDate != null) {
                  safePrint(
                      pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                  String formattedDate = DateFormat('yyyy-MM-dd').format(
                      pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                  safePrint(
                      formattedDate); //formatted date output using intl package =>  2022-07-04
                  //You can format date as per your need

                  setState(() {
                    dateController.text =
                        formattedDate; //set foratted date to TextField value.
                  });
                } else {
                  safePrint("Date is not selected");
                }
              },
            ),
            const SizedBox(height: 16),
            // Create Profile Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                minimumSize: const Size(96, 48),
                maximumSize: const Size(96, 48),
                padding: const EdgeInsets.all(0),
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                createProfile(
                  emailController.text,
                  usernameController.text,
                  firstNameController.text,
                  lastNameController.text,
                  dateController.text,
                  context,
                );
              },
              child: const Text(
                style: TextStyle(fontSize: 12),
                "Create Profile",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> createProfile(
  String email,
  String username,
  String firstName,
  String lastName,
  String birthDate,
  BuildContext context,
) async {
  ProfileCubit profileCubit = context.read<ProfileCubit>();
  // Create Profile
  await profileCubit.createProfile(
    email,
    username,
    firstName,
    lastName,
    birthDate,
  );

  // Go to App
  // ignore: use_build_context_synchronously
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const App(),
    ),
  );
}
