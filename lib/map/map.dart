import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hw_map/cubit/map.dart';
import 'package:hw_map/cubit/poi.dart';
import 'package:hw_map/map/config.dart';
import 'package:hw_map/poi/create.dart';
import 'package:hw_map/poi/details.dart';
import 'package:hw_map/poi/poi.dart';
import 'package:hw_map/route/create.dart';
import 'package:hw_map/util/assets.dart';
import 'package:latlong2/latlong.dart';

class Map extends StatefulWidget {
  const Map({
    super.key,
  });

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  bool isCreatingRoute = false;

  void toggleCreatingRoute() {
    setState(() {
      isCreatingRoute = !isCreatingRoute;
    });
  }

  @override
  Widget build(BuildContext context) {
    MapCubit mapCubit = context.read<MapCubit>();

    return Scaffold(
      body: Stack(
        children: [
          /* Map */
          FlutterMap(
            mapController: mapCubit.state.mapController,
            options: mapCubit.state.mapOptions,
            children: [
              TileLayer(
                urlTemplate: tileLayerUrl,
              ),
              /* User Marker */
              BlocBuilder<MapCubit, MapState>(
                builder: (context, mapState) => MarkerLayer(
                  alignment: Alignment.topCenter,
                  markers: [
                    if (mapState.userLocation != null)
                      Marker(
                        point: mapState.userLocation!,
                        child: getMarkerImage('user-location'),
                      ),
                  ],
                ),
              ),
              /* POI Markers */
              BlocBuilder<PoiCubit, List<Poi>>(
                builder: (context, poiList) => MarkerLayer(
                  alignment: Alignment.topCenter,
                  markers: poiList
                      .map((poi) => Marker(
                            point: LatLng(poi.latitude, poi.longitude),
                            width: 50.0,
                            height: 50.0,
                            child: GestureDetector(
                              child: getMarkerImage(poi.type),
                              onTap: () {
                                mapCubit.flyTo(
                                  latitude: poi.latitude,
                                  longitude: poi.longitude,
                                  zoom: 18.0,
                                  offset: const Offset(0, -150),
                                );
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      height: 500,
                                      child: PoiDetails(poi: poi),
                                    );
                                  },
                                );
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
          /* Buttons */
          Container(
            padding: const EdgeInsets.fromLTRB(16, 64, 16, 64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SearchLocationBar(),
                Visibility(
                  visible: isCreatingRoute,
                  child: CreateRouteForm(onClose: toggleCreatingRoute),
                ),
                const SizedBox(height: 32),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        ProfileButton(),
                      ],
                    ),
                    Column(
                      children: [
                        ZoomInButton(),
                        ZoomOutButton(),
                        SizedBox(height: 32),
                        LocateUserButton(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
        child: Row(
          children: [
            const SizedBox(width: 32),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const OpenCreatePoiFormButton(),
                  CreateRouteButton(
                    onPressed: toggleCreatingRoute,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: const InformationMessage(),
    );
  }
}

class SearchLocationBar extends StatelessWidget {
  const SearchLocationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (context, controller) => SearchBar(
        controller: controller,
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16),
        ),
        leading: const Icon(Icons.search),
        hintText: "Search Location",
        trailing: const [Icon(Icons.clear)],
      ),
      suggestionsBuilder: (context, controller) => [],
    );
  }
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      onPressed: () {},
      child: const Icon(Icons.person),
    );
  }
}

class ZoomInButton extends StatelessWidget {
  const ZoomInButton({super.key});

  @override
  Widget build(BuildContext context) {
    MapCubit mapCubit = context.read<MapCubit>();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      onPressed: () {
        mapCubit.zoomIn();
      },
      child: const Icon(Icons.add),
    );
  }
}

class ZoomOutButton extends StatelessWidget {
  const ZoomOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    MapCubit mapCubit = context.read<MapCubit>();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      onPressed: () {
        mapCubit.zoomOut();
      },
      child: const Icon(Icons.remove),
    );
  }
}

class LocateUserButton extends StatelessWidget {
  const LocateUserButton({super.key});

  @override
  Widget build(BuildContext context) {
    MapCubit mapCubit = context.read<MapCubit>();

    return BlocBuilder<MapCubit, MapState>(
      builder: (context, mapState) {
        if (mapState.userLocation != null) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
            ),
            onPressed: () {
              mapCubit.flyToUserLocation();
            },
            child: const Icon(Icons.my_location),
          );
        } else {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
            ),
            onPressed: () {
              mapCubit.trackUserPosition(flyTo: true);
            },
            child: const Icon(Icons.location_disabled_rounded),
          );
        }
      },
    );
  }
}

class CreateRouteButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CreateRouteButton({super.key, required this.onPressed});

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

class InformationMessage extends StatelessWidget {
  const InformationMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(
      builder: (context, mapState) {
        if (mapState.userLocation == null) {
          return const InformationLocationUnavailable();
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class InformationLocationUnavailable extends StatelessWidget {
  const InformationLocationUnavailable({super.key});

  @override
  Widget build(BuildContext context) {
    MapCubit mapCubit = context.read<MapCubit>();

    return SizedBox(
      height: 72,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Location Services Unavailable"),
            TextButton(
              onPressed: () {
                mapCubit.trackUserPosition(flyTo: true);
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
