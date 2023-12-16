import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_x/cubit/map.dart';
import 'package:project_x/cubit/poi.dart';
import 'package:project_x/util/assets.dart';
import 'package:project_x/util/message.dart';
import 'package:image_picker/image_picker.dart';

class CreatePoiForm extends StatefulWidget {
  final double latitude;
  final double longitude;
  final VoidCallback onClose;

  const CreatePoiForm({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.onClose,
  });

  @override
  State<CreatePoiForm> createState() => _CreatePoiFormState();
}

class _CreatePoiFormState extends State<CreatePoiForm> {
  late double latitude;
  late double longitude;
  late VoidCallback onClose;

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final typeController = TextEditingController();
  final picker = ImagePicker();

  final poiTypes = [
    {"label": "Bench", "value": "bench"},
    {"label": "Bicycle Parking", "value": "bicycle-parking"},
    {"label": "Bicycle Shop", "value": "bicycle-shop"},
    {"label": "Drinking Water", "value": "drinking-water"},
    {"label": "Toilets", "value": "toilets"},
  ];

  File? image;

  @override
  void initState() {
    super.initState();
    latitude = widget.latitude;
    longitude = widget.longitude;
    onClose = widget.onClose;
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      }
    });
  }

  bool isFormValid() {
    return _formKey.currentState!.validate() && image != null;
  }

  @override
  Widget build(BuildContext context) {
    PoiCubit poiCubit = context.read<PoiCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Creating a POI",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(
                  size: 128,
                  Icons.location_on_rounded,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Let's create a POI!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Follow the steps to create a POI",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "What's the name of the POI?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Give it meaningful name, like \"city park toilets\"",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 8),
                // Name
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    labelText: "Name",
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.normal,
                    ),
                    hintText: "Write a name for the POI",
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "You must write a name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  "How can you describe the POI?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Provide useful information, like \"the toilets are located in the back of the park\"",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 8),
                // Description
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    labelText: "Description",
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.normal,
                    ),
                    hintText: "Write a description for the POI",
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "You must write a description";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  "What's the type of the POI?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "From the previous examples, the type would be \"toilets\"",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 8),
                // Type
                DropdownButtonFormField(
                  items: poiTypes
                      .map((poiType) => DropdownMenuItem(
                            value: poiType["value"],
                            child: Row(
                              children: [
                                const SizedBox(width: 8),
                                getMarkerImage(poiType["value"]!),
                                const SizedBox(width: 16),
                                Text(poiType["label"]!),
                              ],
                            ),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    labelText: "Type",
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.normal,
                    ),
                    hintText: "Choose a type for the POI",
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
                  onChanged: (value) {
                    typeController.text = value.toString();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "You must choose a type";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  "How does the POI look like?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Take a picture of the POI that can help other users to find it",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
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
                            const SizedBox(height: 8),
                            Text(
                              "You must take a picture",
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            )
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
                                    foregroundColor: Theme.of(context)
                                        .colorScheme
                                        .onTertiary,
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
                // Create POI Button
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
                    if (isFormValid()) {
                      poiCubit.createPoi(
                        nameController.text,
                        descriptionController.text,
                        typeController.text,
                        latitude,
                        longitude,
                        image!,
                      );
                      showSnackBar(context, "Created ${nameController.text}");
                      onClose();
                    }
                  },
                  child: const Text(
                    style: TextStyle(fontSize: 12),
                    "Create POI",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OpenCreatePoiFormButton extends StatelessWidget {
  const OpenCreatePoiFormButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(
      builder: (context, mapState) {
        if (mapState.userPosition != null) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              minimumSize: const Size(96, 48),
              maximumSize: const Size(96, 48),
              padding: const EdgeInsets.all(0),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CreatePoiForm(
                    latitude: mapState.userPosition!.latitude,
                    longitude: mapState.userPosition!.longitude,
                    onClose: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              );
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  size: 16,
                  Icons.add,
                ),
                Text(
                  style: TextStyle(fontSize: 12),
                  "Create POI",
                ),
              ],
            ),
          );
        } else {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              minimumSize: const Size(96, 48),
              maximumSize: const Size(96, 48),
              padding: const EdgeInsets.all(0),
            ),
            onPressed: () {
              showSnackBar(
                context,
                "Cannot create POI without location enabled",
              );
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  size: 16,
                  Icons.add,
                ),
                Text(
                  style: TextStyle(fontSize: 12),
                  "Create POI",
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
