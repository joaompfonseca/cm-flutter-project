import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_x/cubit/profile.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateProfileForm extends StatefulWidget {
  const UpdateProfileForm({super.key});

  @override
  State<UpdateProfileForm> createState() => _UpdateProfileFormState();
}

class _UpdateProfileFormState extends State<UpdateProfileForm> {
  final picker = ImagePicker();
  File? image;
  late TextEditingController usernameController;

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProfileCubit profileCubit = context.read<ProfileCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 48),
              const Icon(
                size: 128,
                Icons.person_rounded,
              ),
              const SizedBox(height: 8),
              const Text(
                "Update your profile",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "You can change your username and picture here",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
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
                  hintText: "Enter a new username",
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
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "Picture",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: image == null
                    ? Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              minimumSize: const Size(128, 48),
                              maximumSize: const Size(128, 48),
                              padding: const EdgeInsets.all(0),
                              foregroundColor:
                                  Theme.of(context).colorScheme.onTertiary,
                              backgroundColor:
                                  Theme.of(context).colorScheme.tertiary,
                            ),
                            onPressed: getImageFromCamera,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.camera_alt_rounded,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  style: TextStyle(fontSize: 12),
                                  "Take a picture",
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.file(image!),
                          ),
                          Positioned.fromRelativeRect(
                            rect: RelativeRect.fill,
                            child: Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  minimumSize: const Size(128, 48),
                                  maximumSize: const Size(128, 48),
                                  padding: const EdgeInsets.all(0),
                                  foregroundColor:
                                      Theme.of(context).colorScheme.onTertiary,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.tertiary,
                                ),
                                onPressed: getImageFromCamera,
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.camera_alt_rounded,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      style: TextStyle(fontSize: 12),
                                      "Change picture",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 16),
              // Update Profile Button
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
                  profileCubit.updateProfile(usernameController.text, image);
                  Navigator.pop(context);
                },
                child: const Text(
                  style: TextStyle(fontSize: 12),
                  "Update Profile",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
