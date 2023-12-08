import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_x/cubit/geocoding.dart';
import 'package:project_x/cubit/graphhopper.dart';
import 'package:project_x/cubit/map.dart';
import 'package:project_x/cubit/route.dart';
import 'package:project_x/map/picker.dart';
import 'package:project_x/route/route.dart';
import 'package:project_x/util/message.dart';

class CreateRouteForm extends StatelessWidget {
  const CreateRouteForm({super.key});

  bool isFormValid(BuildContext context) {
    RouteCubit routeCubit = context.read<RouteCubit>();
    for (final location in routeCubit.state.createdRouteLocationList) {
      if (location.text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  Future<CustomRoute> getRoute(BuildContext context) async {
    RouteCubit routeCubit = context.read<RouteCubit>();
    GeocodingCubit geocodingCubit = context.read<GeocodingCubit>();
    List<RoutePoint> points = [];

    for (final location in routeCubit.state.createdRouteLocationList) {
      GeocodingState? geocoding =
          await geocodingCubit.coordinatesFromLocation(location.text);
      if (geocoding != null) {
        points.add(RoutePoint(
          label: geocoding.location!,
          latitude: geocoding.coordinates!.latitude,
          longitude: geocoding.coordinates!.longitude,
        ));
      }
    }

    return CustomRoute(
      id: "poi${DateTime.timestamp()}", // TODO: remove
      points: points,
    );
  }

  void onSave(BuildContext context) async {
    if (isFormValid(context)) {
      RouteCubit routeCubit = context.read<RouteCubit>();
      // Create the route
      CustomRoute route = await getRoute(context);
      routeCubit.saveCreatedRoute(route);
      // ignore: use_build_context_synchronously
      showSnackBar(context, "Saved route");
    }
  }

  void onSubmit(BuildContext context) async {
    if (isFormValid(context)) {
      RouteCubit routeCubit = context.read<RouteCubit>();
      MapCubit mapCubit = context.read<MapCubit>();
      GraphhopperCubit graphhopperCubit = context.read<GraphhopperCubit>();
      // Create the route
      CustomRoute route = await getRoute(context);
      // ignore: use_build_context_synchronously
      showSnackBar(context, "Displaying route");
      routeCubit.setIsCreatingRoute(false);
      // Display the route on the map
      routeCubit.setDisplayedRoute(route);
      graphhopperCubit.fetchPoints(route);
      RoutePoint start = route.points[0];
      mapCubit.flyTo(
        latitude: start.latitude,
        longitude: start.longitude,
        zoom: 14.0,
      );
    } else {
      showSnackBar(context, "Please fill all the fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    RouteCubit routeCubit = context.read<RouteCubit>();

    return BlocBuilder<RouteCubit, RouteState>(
      builder: (context, routeState) => Card(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 0, 16),
            child: Column(
              children: [
                SizedBox.fromSize(
                  size: const Size.fromHeight(192),
                  child: ReorderableListView(
                    shrinkWrap: true,
                    onReorder: (int oldIndex, int newIndex) {
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }
                      final item =
                          routeCubit.deleteCreatedRouteLocation(oldIndex)!;
                      routeCubit.addCreatedRouteLocation(item, newIndex);
                    },
                    children: [
                      for (int index = 0;
                          index < routeState.createdRouteLocationList.length;
                          index += 1)
                        ListTile(
                          key: ObjectKey(
                              routeState.createdRouteLocationList[index]),
                          leading: const Icon(Icons.drag_handle_rounded),
                          title: LocationBar(
                            key: Key(index.toString()),
                            index: index,
                            controller:
                                routeState.createdRouteLocationList[index],
                            onDelete:
                                (routeState.createdRouteLocationList.length > 2)
                                    ? () => routeCubit
                                        .deleteCreatedRouteLocation(index)
                                    : null,
                          ),
                        ),
                    ],
                  ),
                ),
                Row(
                  key: const ObjectKey("actionsInList"),
                  children: [
                    // Add Location
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        foregroundColor:
                            Theme.of(context).colorScheme.onTertiary,
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                      ),
                      onPressed: () => routeCubit.addCreatedRouteLocation(
                        TextEditingController(),
                        (routeState.createdRouteLocationList.length / 2)
                            .floor(),
                      ),
                      child: const Icon(Icons.add_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Close
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.onSecondary,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: () => routeCubit.setIsCreatingRoute(false),
                      child: const Text("Close"),
                    ),
                    // Save Route
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        foregroundColor:
                            Theme.of(context).colorScheme.onTertiary,
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                      ),
                      onPressed: () => onSave(context),
                      child: const Icon(Icons.save_rounded),
                    ),
                    // Submit
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => onSubmit(context),
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LocationBar extends StatelessWidget {
  final int index;
  final TextEditingController controller;
  final VoidCallback? onDelete;
  const LocationBar(
      {super.key,
      required this.index,
      required this.controller,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    GeocodingCubit geocodingCubit = context.read<GeocodingCubit>();

    return SearchAnchor(
      builder: (context, controller) => SearchBar(
        controller: this.controller,
        padding: const MaterialStatePropertyAll(
          EdgeInsets.fromLTRB(8, 0, 0, 0),
        ),
        leading: SizedBox(
          width: 48,
          height: 48,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on_rounded),
              Text((index + 1).toString()),
            ],
          ),
        ),
        hintText: "Insert Location",
        trailing: [
          if (onDelete != null)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                foregroundColor: const Color(0xFFFFFFFF),
                backgroundColor: const Color(0xFFEF4444),
              ),
              onPressed: onDelete,
              child: const Icon(Icons.delete_rounded),
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              foregroundColor: Theme.of(context).colorScheme.onTertiary,
              backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),
            onPressed: () async {
              LatLng? position = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PositionPicker(),
                ),
              );
              if (position != null) {
                GeocodingState? geocoding =
                    await geocodingCubit.locationFromCoordinates(position);
                if (geocoding != null) {
                  controller.text = geocoding.location!;
                }
              }
            },
            child: const Icon(Icons.map),
          ),
        ],
      ),
      suggestionsBuilder: (context, controller) => [],
    );
  }
}

class CreateRouteFormButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateRouteFormButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
        foregroundColor: Theme.of(context).colorScheme.onTertiary,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
      onPressed: onPressed,
      child: const Icon(Icons.directions),
    );
  }
}
