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
      id: "route-${DateTime.timestamp()}", // Gets a unique ID by the API
      points: points,
    );
  }

  void onChange(BuildContext context) async {
    if (isFormValid(context)) {
      RouteCubit routeCubit = context.read<RouteCubit>();
      GraphhopperCubit graphhopperCubit = context.read<GraphhopperCubit>();
      // Create the route
      CustomRoute route = await getRoute(context);
      // Display the route on the map
      routeCubit.setDisplayedRoute(route);
      graphhopperCubit.fetchRoute(route);
    }
  }

  void onSave(BuildContext context) async {
    if (isFormValid(context)) {
      RouteCubit routeCubit = context.read<RouteCubit>();
      // Create the route
      CustomRoute route = await getRoute(context);
      routeCubit.saveCreatedRoute(route);
      // ignore: use_build_context_synchronously
      showSnackBar(context, "Saved route");
    } else {
      showSnackBar(context, "Please fill all the fields");
    }
  }

  void onSubmit(BuildContext context) async {
    if (isFormValid(context)) {
      MapCubit mapCubit = context.read<MapCubit>();
      RouteCubit routeCubit = context.read<RouteCubit>();
      GraphhopperCubit graphhopperCubit = context.read<GraphhopperCubit>();
      // Create the route
      CustomRoute route = await getRoute(context);
      // Display the route on the map
      routeCubit.setDisplayedRoute(route);
      graphhopperCubit.fetchRoute(route);
      // Fly to the start of the route
      routeCubit.setIsCreatingRoute(false);
      Point start = routeCubit.state.displayedRoutePoints[0];
      mapCubit.flyTo(
        latitude: start.latitude,
        longitude: start.longitude,
        zoom: 14.0,
      );
      // ignore: use_build_context_synchronously
      showSnackBar(context, "Starting navigation");
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
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                SizedBox.fromSize(
                  size: Size.fromHeight(
                    routeState.createdRouteLocationList.length <= 3
                        ? (routeState.createdRouteLocationList.length * 56)
                        : 192,
                  ),
                  child: ReorderableListView(
                    shrinkWrap: true,
                    onReorder: (int oldIndex, int newIndex) {
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }
                      final item =
                          routeCubit.deleteCreatedRouteLocation(oldIndex)!;
                      routeCubit.addCreatedRouteLocation(item, newIndex);
                      onChange(context); // Update route on map
                    },
                    children: [
                      for (int index = 0;
                          index < routeState.createdRouteLocationList.length;
                          index += 1)
                        ListTile(
                          key: ObjectKey(
                            routeState.createdRouteLocationList[index],
                          ),
                          contentPadding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                          horizontalTitleGap: 4,
                          leading: const Icon(Icons.drag_handle_rounded),
                          title: LocationBar(
                            key: Key(index.toString()),
                            index: index,
                            controller:
                                routeState.createdRouteLocationList[index],
                            position: (routeState.displayedRoute != null &&
                                    index <
                                        routeState
                                            .displayedRoute!.points.length)
                                ? LatLng(
                                    routeState
                                        .displayedRoute!.points[index].latitude,
                                    routeState.displayedRoute!.points[index]
                                        .longitude,
                                  )
                                : null,
                            onChange: () =>
                                onChange(context), // Update route on map
                            onDelete: (routeState
                                        .createdRouteLocationList.length >
                                    2)
                                ? () {
                                    routeCubit
                                        .deleteCreatedRouteLocation(index);
                                    onChange(context); // Update route on map
                                  }
                                : null,
                          ),
                        ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Hide
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        minimumSize: const Size(48, 32),
                        maximumSize: const Size(48, 32),
                        padding: const EdgeInsets.all(0),
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => routeCubit.setIsCreatingRoute(false),
                      child: const Text(
                        style: TextStyle(fontSize: 12),
                        "Hide",
                      ),
                    ),
                    // Add Location
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        minimumSize: const Size(64, 32),
                        maximumSize: const Size(64, 32),
                        padding: const EdgeInsets.all(0),
                        foregroundColor:
                            Theme.of(context).colorScheme.onSecondary,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: () => routeCubit.addCreatedRouteLocation(
                        TextEditingController(),
                        (routeState.createdRouteLocationList.length / 2)
                            .floor(),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            size: 16,
                            Icons.add_rounded,
                          ),
                          SizedBox(width: 4),
                          Text(
                            style: TextStyle(fontSize: 12),
                            "Add",
                          ),
                        ],
                      ),
                    ),
                    // Save Route
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        minimumSize: const Size(64, 32),
                        maximumSize: const Size(64, 32),
                        padding: const EdgeInsets.all(0),
                        foregroundColor:
                            Theme.of(context).colorScheme.onTertiary,
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                      ),
                      onPressed: () => onSave(context),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            size: 16,
                            Icons.save_rounded,
                          ),
                          SizedBox(width: 4),
                          Text(
                            style: TextStyle(fontSize: 12),
                            "Save",
                          ),
                        ],
                      ),
                    ),
                    // Submit
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        minimumSize: const Size(64, 32),
                        maximumSize: const Size(64, 32),
                        padding: const EdgeInsets.all(0),
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => onSubmit(context),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            style: TextStyle(fontSize: 12),
                            "Go!",
                          ),
                          SizedBox(width: 4),
                          Icon(
                            size: 16,
                            Icons.send_rounded,
                          ),
                        ],
                      ),
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
  final LatLng? position;
  final VoidCallback onChange;
  final VoidCallback? onDelete;
  const LocationBar(
      {super.key,
      required this.index,
      required this.controller,
      required this.position,
      required this.onChange,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    GeocodingCubit geocodingCubit = context.read<GeocodingCubit>();

    return SearchAnchor(
      builder: (context, controller) => SearchBar(
        controller: this.controller,
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.all(0),
        ),
        constraints: const BoxConstraints(
          maxHeight: 40,
        ),
        leading: SizedBox(
          width: 32,
          height: 32,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                size: 16,
                Icons.location_on_rounded,
              ),
              Text(
                style: const TextStyle(fontSize: 8),
                (index + 1).toString(),
              ),
            ],
          ),
        ),
        hintText: "Type location...",
        hintStyle: MaterialStateProperty.all(
          TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onBackground,
            fontWeight: FontWeight.normal,
          ),
        ),
        textStyle: MaterialStateProperty.all(
          TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onBackground,
            fontWeight: FontWeight.normal,
          ),
        ),
        trailing: [
          BlocBuilder<MapCubit, MapState>(
            builder: (context, mapState) => ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                minimumSize: const Size(32, 32),
                maximumSize: const Size(32, 32),
                padding: const EdgeInsets.all(0),
                foregroundColor: const Color(0xFFFFFFFF),
                backgroundColor: const Color(0xFFEF4444),
              ),
              onPressed: () async {
                LatLng? position = mapState.userPosition;
                if (position != null) {
                  GeocodingState? geocoding =
                      await geocodingCubit.locationFromCoordinates(position);
                  if (geocoding != null) {
                    this.controller.text = geocoding.location!;
                  }
                  onChange(); // Update route on map
                } else {
                  showSnackBar(context, "Please enable location services");
                }
              },
              child: const Icon(
                size: 16,
                Icons.person_rounded,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              minimumSize: const Size(32, 32),
              maximumSize: const Size(32, 32),
              padding: const EdgeInsets.all(0),
              foregroundColor: Theme.of(context).colorScheme.onTertiary,
              backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),
            onPressed: () async {
              LatLng? position = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PositionPicker(
                    initialPosition: this.position ??
                        const LatLng(40.6405, -8.6538), // Aveiro, Portugal
                  ),
                ),
              );
              if (position != null) {
                GeocodingState? geocoding =
                    await geocodingCubit.locationFromCoordinates(position);
                if (geocoding != null) {
                  this.controller.text = geocoding.location!;
                }
                onChange(); // Update route on map
              }
            },
            child: const Icon(
              size: 16,
              Icons.pin_drop_rounded,
            ),
          ),
          if (onDelete != null)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                minimumSize: const Size(32, 32),
                maximumSize: const Size(32, 32),
                padding: const EdgeInsets.all(0),
                foregroundColor: const Color(0xFFFFFFFF),
                backgroundColor: const Color(0xFFEF4444),
              ),
              onPressed: onDelete,
              child: const Icon(
                size: 16,
                Icons.delete_rounded,
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
            child: GestureDetector(
              child: const Icon(
                size: 16,
                Icons.clear,
              ),
              onTap: () {
                this.controller.clear();
              },
            ),
          ),
        ],
        onChanged: (value) async {
          this.controller.text = value;
          onChange();
        },
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
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        minimumSize: const Size(96, 48),
        maximumSize: const Size(96, 48),
        padding: const EdgeInsets.all(0),
      ),
      onPressed: onPressed,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            size: 16,
            Icons.directions,
          ),
          Text(
            style: TextStyle(
              fontSize: 12,
            ),
            "Create Route",
          ),
        ],
      ),
    );
  }
}
