import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_x/cubit/geocoding.dart';
import 'package:project_x/cubit/graphhopper.dart';
import 'package:project_x/cubit/map.dart';
import 'package:project_x/cubit/route.dart';
import 'package:project_x/route/route.dart';
import 'package:project_x/util/message.dart';

class CreateRouteForm extends StatefulWidget {
  const CreateRouteForm({super.key});

  @override
  State<CreateRouteForm> createState() => _CreateRouteFormState();
}

class _CreateRouteFormState extends State<CreateRouteForm> {
  List<TextEditingController> locations = List.from([
    TextEditingController(),
    TextEditingController(),
  ]);

  void onAdd() {
    setState(() {
      locations.insert(locations.length - 1, TextEditingController());
    });
  }

  void onDelete(int index) {
    setState(() {
      if (locations.length > 2) {
        locations.removeAt(index);
      }
    });
  }

  bool isFormValid() {
    for (final location in locations) {
      if (location.text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    MapCubit mapCubit = context.read<MapCubit>();
    RouteCubit routeCubit = context.read<RouteCubit>();
    GraphhopperCubit graphhopperCubit = context.read<GraphhopperCubit>();
    GeocodingCubit geocodingCubit = context.read<GeocodingCubit>();

    return Card(
      child: Form(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 16, 0, 16),
          child: Column(
            children: [
              SizedBox.fromSize(
                size: const Size.fromHeight(168),
                child: ReorderableListView(
                  shrinkWrap: true,
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }
                      final item = locations.removeAt(oldIndex);
                      locations.insert(newIndex, item);
                    });
                  },
                  children: [
                    for (int index = 0; index < locations.length; index += 1)
                      ListTile(
                        key: ObjectKey(locations[index]),
                        leading: const Icon(Icons.drag_handle_rounded),
                        title: LocationBar(
                          key: Key(index.toString()),
                          index: index,
                          controller: locations[index],
                          onDelete: (locations.length > 2)
                              ? () => onDelete(index)
                              : null,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onTertiary,
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                    ),
                    onPressed: onAdd,
                    child: const Text("Add Location"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          Theme.of(context).colorScheme.onSecondary,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () => routeCubit.setIsCreatingRoute(false),
                    child: const Text("Close"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () async {
                      if (isFormValid()) {
                        List<RoutePoint> points = [];
                        for (final location in locations) {
                          GeocodingState? geocoding = await geocodingCubit
                              .coordinatesFromLocation(location.text);
                          if (geocoding != null) {
                            points.add(RoutePoint(
                              label: geocoding.location!,
                              latitude: geocoding.coordinates!.latitude,
                              longitude: geocoding.coordinates!.longitude,
                            ));
                          }
                        }
                        CustomRoute route = CustomRoute(
                          id: "poi${DateTime.timestamp()}", // TODO: remove
                          points: points,
                        );
                        routeCubit.createCreatedRoute(route);
                        // ignore: use_build_context_synchronously
                        showSnackBar(context, "Created ${route.name}");
                        routeCubit.setIsCreatingRoute(false);
                        // Display the route on the map
                        routeCubit.setDisplayedRoute(route);
                        graphhopperCubit.fetchPoints(route);
                        RoutePoint start = route.points[0];
                        mapCubit.flyTo(
                          latitude: start.latitude,
                          longitude: start.longitude,
                          zoom: 18.0,
                        );
                      } else {
                        showSnackBar(context, "Please fill all the fields");
                      }
                    },
                    child: const Text('Submit'),
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
                foregroundColor: Theme.of(context).colorScheme.onError,
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: onDelete,
              child: const Icon(Icons.delete_rounded),
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
