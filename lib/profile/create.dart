import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_x/app.dart';
import 'package:project_x/cubit/profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class createProfileForm extends StatefulWidget {
  const createProfileForm({super.key});

  @override
  State<createProfileForm> createState() => _createProfileFormState();
}

class _createProfileFormState extends State<createProfileForm> {
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
    ProfileCubit profileCubit = context.read<ProfileCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create your profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Icon(Icons.security, size: 120, color: Colors.orange),
            const SizedBox(height: 32),
            Row(
              children: [
                // Input for First Name and Last Name
                Expanded(
                  child: TextField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'First Name',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Last Name',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: dateController, //editing controller of this TextField
              decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today), //icon of text field
                  labelText: "Enter Date", //label text of field
                  border: OutlineInputBorder()),
              readOnly: true, // when true user cannot edit text
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(), //get today's date
                    firstDate: DateTime(
                        2000), //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2101));

                if (pickedDate != null) {
                  print(
                      pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                  String formattedDate = DateFormat('yyyy-MM-dd').format(
                      pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                  print(
                      formattedDate); //formatted date output using intl package =>  2022-07-04
                  //You can format date as per your need

                  setState(() {
                    dateController.text =
                        formattedDate; //set foratted date to TextField value.
                  });
                } else {
                  print("Date is not selected");
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                profileCubit.createProfile(
                  emailController.text,
                  usernameController.text,
                  firstNameController.text,
                  lastNameController.text,
                  dateController.text,
                );
              },
              child: const Text('Create Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> createProfile(String email, String username, String firstName,
    String lastName, String birthDate, BuildContext context) async {
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
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const App(),
    ),
  );
}
