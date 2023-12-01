import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hw_map/cubit/map.dart';
import 'package:hw_map/cubit/poi.dart';
import 'package:hw_map/map/config.dart';
import 'package:hw_map/poi/details.dart';
import 'package:hw_map/poi/poi.dart';
import 'package:hw_map/util/assets.dart';
import 'package:latlong2/latlong.dart';

class Map extends StatelessWidget {
  const Map({super.key});

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
                                  offset: const Offset(0, -100),
                                );
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      height: 400,
                                      child: PoiDetails(
                                        poi: poi,
                                      ),
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
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SearchLocationBar(),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(),
                    Column(
                      children: [
                        ZoomInButton(),
                        ZoomOutButton(),
                        SizedBox(height: 16),
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

class ZoomInButton extends StatelessWidget {
  const ZoomInButton({super.key});

  @override
  Widget build(BuildContext context) {
    MapCubit mapCubit = context.read<MapCubit>();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
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
        padding: const EdgeInsets.all(16),
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

    return BlocBuilder<MapCubit, MapState>(builder: (context, mapState) {
      if (mapState.userLocation != null) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
            backgroundColor: Theme.of(context).colorScheme.secondary,
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
            padding: const EdgeInsets.all(16),
          ),
          onPressed: () {
            mapCubit.trackUserPosition(flyTo: true);
          },
          child: const Icon(Icons.location_disabled_rounded),
        );
      }
    });
  }
}

class InformationMessage extends StatelessWidget {
  const InformationMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(
      builder: (context, mapState) {
        if (mapState.userLocation != null) {
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
      height: 64,
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
