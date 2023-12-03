import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_map/cubit/map.dart';
import 'package:hw_map/cubit/poi.dart';
import 'package:hw_map/poi/poi.dart';
import 'package:hw_map/util/assets.dart';
import 'package:hw_map/util/message.dart';
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
        title: const Text("Creating a POI"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Write a name for the POI",
                    hintStyle: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.5),
                    ),
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
                  "Description",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Write a description for the POI",
                    hintStyle: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.5),
                    ),
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
                  "Type",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
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
                    border: const OutlineInputBorder(),
                    hintText: "Choose a type for the POI",
                    hintStyle: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.5),
                    ),
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
                                      BorderRadius.all(Radius.circular(16)),
                                ),
                                padding:
                                    const EdgeInsets.fromLTRB(16, 20, 16, 20),
                                foregroundColor:
                                    Theme.of(context).colorScheme.onTertiary,
                                backgroundColor:
                                    Theme.of(context).colorScheme.tertiary,
                              ),
                              onPressed: getImageFromCamera,
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.camera_alt_rounded),
                                  SizedBox(width: 8),
                                  Text("Take a picture"),
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
                                          BorderRadius.all(Radius.circular(16)),
                                    ),
                                    padding: const EdgeInsets.fromLTRB(
                                        32, 20, 32, 20),
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
                                      Icon(Icons.camera_alt_rounded),
                                      SizedBox(width: 8),
                                      Text("Change picture"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      if (isFormValid()) {
                        Poi poi = Poi(
                          id: "poi${DateTime.timestamp()}", // TODO: remove
                          name: nameController.text,
                          type: typeController.text,
                          description: descriptionController.text,
                          latitude: latitude,
                          longitude: longitude,
                          pictureUrl:
                              image!.path.toString(), // TODO: change to S3
                          ratingPositive: 0, // TODO: remove
                          ratingNegative: 0, // TODO: remove
                          addedBy: "testUser", // TODO: change to user
                        );
                        poiCubit.createPoi(poi);
                        showSnackBar(context, "Created ${poi.name}");
                        onClose();
                      }
                    },
                    child: const Text(
                      'Create',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
    MapCubit mapCubit = context.read<MapCubit>();

    return BlocBuilder<MapCubit, MapState>(
      builder: (context, mapState) {
        if (mapState.userPosition != null) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              backgroundColor: Theme.of(context).colorScheme.secondary,
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
            child: const Icon(Icons.add),
          );
        } else {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              showSnackBar(
                context,
                "Cannot create POI without location enabled",
              );
            },
            child: const Icon(Icons.add),
          );
        }
      },
    );
  }
}
