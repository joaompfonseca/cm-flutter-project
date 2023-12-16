// ignore_for_file: use_build_context_synchronously

import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:project_x/cubit/geocoding.dart';
import 'package:project_x/cubit/graphhopper.dart';
import 'package:project_x/cubit/map.dart';
import 'package:project_x/cubit/poi.dart';
import 'package:project_x/cubit/position.dart';
import 'package:project_x/cubit/profile.dart';
import 'package:project_x/cubit/route.dart';
import 'package:project_x/map/config.dart';
import 'package:project_x/poi/create.dart';
import 'package:project_x/poi/details.dart';
import 'package:project_x/poi/filter.dart';
import 'package:project_x/poi/poi.dart';
import 'package:project_x/profile/details.dart';
import 'package:project_x/route/create.dart';
import 'package:project_x/route/instruction.dart';
import 'package:project_x/route/route.dart';
import 'package:project_x/route/track.dart';
import 'package:project_x/util/assets.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_x/util/cache.dart';
import 'package:project_x/util/message.dart';
import 'package:url_launcher/url_launcher.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    MapCubit mapCubit = context.read<MapCubit>();
    RouteCubit routeCubit = context.read<RouteCubit>();
    PoiCubit poiCubit = context.read<PoiCubit>();

    return Scaffold(
      body: Stack(
        children: [
          /* Map */
          FutureBuilder<String>(
              future: getCachePath(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return FlutterMap(
                    mapController: mapCubit.state.mapController,
                    options: MapOptions(
                      initialCenter:
                          const LatLng(40.6405, -8.6538), // Aveiro, Portugal
                      initialZoom: 14.0,
                      minZoom: 3.0,
                      maxZoom: 18.0,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                      ),
                      keepAlive: true,
                      onMapReady: () {
                        poiCubit.setNorthEast(mapCubit.state.mapController
                            .camera.visibleBounds.northEast);
                        poiCubit.setSouthWest(mapCubit.state.mapController
                            .camera.visibleBounds.southWest);
                        poiCubit.getPois();
                      },
                      onPositionChanged: (position, hasGesture) {
                        if (hasGesture) {
                          poiCubit.setNorthEast(position.bounds!.northEast);
                          poiCubit.setSouthWest(position.bounds!.southWest);
                        }
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: tileLayerUrl,
                        tileProvider: CachedTileProvider(
                          maxStale: const Duration(days: 30),
                          store: HiveCacheStore(
                            snapshot.data,
                            hiveBoxName: 'MapTiles',
                          ),
                        ),
                      ),
                      /* POI Markers */
                      BlocBuilder<PoiCubit, PoiState>(
                        builder: (context, poiState) => MarkerLayer(
                          alignment: Alignment.topCenter,
                          markers: poiState.poiList
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
                                        getPoi(context, poi);
                                      },
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      /* Displayed Route Lines */
                      BlocBuilder<RouteCubit, RouteState>(
                        builder: (context, routeState) {
                          if (routeState.displayedRoutePoints.isNotEmpty) {
                            return PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: routeState.displayedRoutePoints
                                      .map((point) => LatLng(
                                          point.latitude, point.longitude))
                                      .toList(),
                                  strokeWidth: 5.0,
                                  color: const Color(0xFF4CAF50),
                                ),
                              ],
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                      /* Tracked Route Lines */
                      BlocBuilder<RouteCubit, RouteState>(
                        builder: (context, routeState) {
                          if (routeState.trackedRoutePointList.isNotEmpty) {
                            return PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: routeState.trackedRoutePointList
                                      .map((point) => LatLng(
                                          point.latitude, point.longitude))
                                      .toList(),
                                  strokeWidth: 5.0,
                                  color: const Color(0xFFEF4444),
                                ),
                              ],
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                      /* Displayed Route Markers */
                      BlocBuilder<RouteCubit, RouteState>(
                        builder: (context, routeState) {
                          if (routeState.displayedRoute != null &&
                              routeState.displayedRoutePoints.isNotEmpty) {
                            if (routeState.displayedRoute!.points.length ==
                                routeState.displayedRoutePoints.length) {
                              // Route with tracked points, display only the start and end markers
                              Point start =
                                  routeState.displayedRoute!.points.first;
                              Point end =
                                  routeState.displayedRoute!.points.last;
                              return MarkerLayer(
                                alignment: Alignment.topCenter,
                                markers: [
                                  Marker(
                                    point:
                                        LatLng(start.latitude, start.longitude),
                                    width: 50.0,
                                    height: 50.0,
                                    child: getMarkerImage('route-start'),
                                  ),
                                  Marker(
                                    point: LatLng(end.latitude, end.longitude),
                                    width: 50.0,
                                    height: 50.0,
                                    child: getMarkerImage('route-end'),
                                  ),
                                ],
                              );
                            } else {
                              // Route with points from Graphhopper, display only the start, intermidiate and end markers
                              Point start =
                                  routeState.displayedRoute!.points.first;
                              List<Point> intermediate =
                                  routeState.displayedRoute!.points.sublist(
                                1,
                                routeState.displayedRoute!.points.length - 1,
                              );
                              Point end =
                                  routeState.displayedRoute!.points.last;
                              return MarkerLayer(
                                alignment: Alignment.topCenter,
                                markers: [
                                  Marker(
                                    point:
                                        LatLng(start.latitude, start.longitude),
                                    width: 50.0,
                                    height: 50.0,
                                    child: getMarkerImage('route-start'),
                                  ),
                                  ...intermediate
                                      .map((point) => Marker(
                                            point: LatLng(point.latitude,
                                                point.longitude),
                                            width: 50.0,
                                            height: 50.0,
                                            child: getMarkerImage(
                                                'route-intermediate'),
                                          ))
                                      .toList(),
                                  Marker(
                                    point: LatLng(end.latitude, end.longitude),
                                    width: 50.0,
                                    height: 50.0,
                                    child: getMarkerImage('route-end'),
                                  ),
                                ],
                              );
                            }
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                      /* User Marker */
                      BlocBuilder<MapCubit, MapState>(
                        builder: (context, mapState) => MarkerLayer(
                          alignment: Alignment.topCenter,
                          markers: [
                            if (mapState.userPosition != null)
                              Marker(
                                point: mapState.userPosition!,
                                child: getMarkerImage('user-location'),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
          /* Buttons */
          Container(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final Uri url = Uri.parse(
                          'https://es-project-x.github.io/documentation/',
                        );
                        if (!await launchUrl(url)) {
                          throw Exception('Could not launch $url');
                        }
                      },
                      child: SizedBox(
                        height: 48,
                        width: 48,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: getIconImage("logo-lettering"),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: SearchLocationBar(),
                    ),
                  ],
                ),
                BlocBuilder<RouteCubit, RouteState>(
                  builder: (context, routeState) => AnimatedSwitcher(
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeIn,
                    duration: const Duration(milliseconds: 500),
                    child: routeState.isCreatingRoute
                        ? const CreateRouteForm()
                        : null,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<RouteCubit, RouteState>(
                          builder: (context, routeState) => AnimatedSwitcher(
                            switchInCurve: Curves.easeIn,
                            switchOutCurve: Curves.easeIn,
                            duration: const Duration(milliseconds: 500),
                            child: !routeState.isCreatingRoute
                                ? const Column(
                                    children: [
                                      SizedBox(height: 8),
                                      ProfileButton(),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                        BlocBuilder<PoiCubit, PoiState>(
                          builder: (context, poiState) => AnimatedSwitcher(
                            switchInCurve: Curves.easeIn,
                            switchOutCurve: Curves.easeIn,
                            duration: const Duration(milliseconds: 500),
                            child: poiState.filtering
                                ? const SizedBox(
                                    width: 192,
                                    child: FilterPoi(),
                                  )
                                : Column(
                                    children: [
                                      const SizedBox(height: 8),
                                      FilterPoiButton(
                                        onPressed: poiCubit.toggleFiltering,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const Column(
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
      floatingActionButton: BlocBuilder<MapCubit, MapState>(
        builder: (context, mapState) => BlocBuilder<RouteCubit, RouteState>(
          builder: (context, routeState) => AnimatedSwitcher(
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeIn,
            duration: const Duration(milliseconds: 500),
            child: !routeState.isCreatingRoute
                ? Padding(
                    padding: EdgeInsets.fromLTRB(
                      0,
                      0,
                      0,
                      (mapState.userPosition == null) ? 72 : 0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Buttons
                        Row(
                          children: [
                            const SizedBox(width: 32),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const OpenCreatePoiFormButton(),
                                  const TrackRouteButton(),
                                  Column(
                                    children: [
                                      CreateRouteFormButton(
                                        onPressed: () =>
                                            routeCubit.setIsCreatingRoute(true),
                                      ),
                                      const ClearDisplayedRouteButton(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Instructions
                        Row(
                          children: [
                            const SizedBox(width: 32),
                            Expanded(
                              child: BlocBuilder<GraphhopperCubit,
                                  GraphhopperState>(
                                builder: (context, graphhopperState) =>
                                    BlocBuilder<RouteCubit, RouteState>(
                                  builder: (context, routeState) =>
                                      AnimatedSwitcher(
                                    switchInCurve: Curves.easeIn,
                                    switchOutCurve: Curves.easeIn,
                                    duration: const Duration(milliseconds: 500),
                                    child: (graphhopperState
                                                .instructions.isNotEmpty &&
                                            !routeState.isCreatingRoute)
                                        ? const InstructionCard()
                                        : const SizedBox.shrink(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : null,
          ),
        ),
      ),
      bottomSheet: const InformationMessage(),
    );
  }
}

Future<void> getPoi(
  BuildContext context,
  Poi poi,
) async {
  PoiCubit poiCubit = context.read<PoiCubit>();

  PoiInd newpoi = await poiCubit.getPoi(poi.id);

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 500,
        child: PoiDetails(poi: newpoi),
      );
    },
  );
}

class SearchLocationBar extends StatelessWidget {
  const SearchLocationBar({super.key});

  @override
  Widget build(BuildContext context) {
    GeocodingCubit geocodingCubit = context.read<GeocodingCubit>();
    MapCubit mapCubit = context.read<MapCubit>();

    return SearchAnchor(
      builder: (context, controller) => SearchBar(
        controller: controller,
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.all(0),
        ),
        constraints: const BoxConstraints(
          minHeight: 48,
          maxHeight: 48,
        ),
        leading: const SizedBox(
          width: 32,
          height: 32,
          child: Icon(
            size: 16,
            Icons.search,
          ),
        ),
        hintText: "Search location...",
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
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
            child: GestureDetector(
              child: const Icon(
                size: 16,
                Icons.clear,
              ),
              onTap: () {
                controller.clear();
              },
            ),
          ),
        ],
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            geocodingCubit.coordinatesFromLocation(value).then((geocoding) {
              if (geocoding != null) {
                mapCubit.setTrackingUserPosition(false);
                mapCubit.flyTo(
                  latitude: geocoding.coordinates!.latitude,
                  longitude: geocoding.coordinates!.longitude,
                  zoom: 18.0,
                );
              }
            });
          }
        },
      ),
      suggestionsBuilder: (context, controller) => [],
    );
  }
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileCubit profileCubit = context.read<ProfileCubit>();
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        minimumSize: const Size(96, 48),
        maximumSize: const Size(96, 48),
        padding: const EdgeInsets.all(0),
      ),
      onPressed: () async {
        await profileCubit.getProfile();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ProfileDetails(),
          ),
        );
      },
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            size: 16,
            Icons.person_rounded,
          ),
          Text(
            style: TextStyle(fontSize: 12),
            "Profile",
          ),
        ],
      ),
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
      child: const Icon(
        size: 24,
        Icons.add,
      ),
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
      child: const Icon(
        size: 24,
        Icons.remove,
      ),
    );
  }
}

class LocateUserButton extends StatelessWidget {
  const LocateUserButton({super.key});

  @override
  Widget build(BuildContext context) {
    PositionCubit positionCubit = context.read<PositionCubit>();
    MapCubit mapCubit = context.read<MapCubit>();

    return BlocBuilder<MapCubit, MapState>(
      builder: (context, mapState) {
        if (mapState.userPosition != null) {
          if (mapState.isTrackingUserPosition) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
                foregroundColor: const Color(0xFFEF4444),
              ),
              onPressed: () {
                mapCubit.setTrackingUserPosition(false);
              },
              child: const Icon(Icons.my_location_rounded),
            );
          } else {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
              ),
              onPressed: () {
                mapCubit.flyToUserPosition();
              },
              onLongPress: () {
                HapticFeedback.vibrate();
                mapCubit.flyToUserPosition();
                mapCubit.setTrackingUserPosition(true);
                showSnackBar(
                  context,
                  "Tracking your position. Tap again to stop.",
                );
              },
              child: const Icon(Icons.location_searching_rounded),
            );
          }
        } else {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
            ),
            onPressed: () {
              positionCubit.trackUserPosition();
            },
            onLongPress: () {
              HapticFeedback.vibrate();
              positionCubit.trackUserPosition();
              mapCubit.setTrackingUserPosition(true);
              showSnackBar(
                context,
                "Tracking your position. Tap again to stop.",
              );
            },
            child: const Icon(Icons.location_disabled_rounded),
          );
        }
      },
    );
  }
}

class ClearDisplayedRouteButton extends StatelessWidget {
  const ClearDisplayedRouteButton({super.key});

  @override
  Widget build(BuildContext context) {
    RouteCubit routeCubit = context.read<RouteCubit>();
    GraphhopperCubit graphhopperCubit = context.read<GraphhopperCubit>();

    return BlocBuilder<RouteCubit, RouteState>(
      builder: (context, routeState) {
        if (routeState.displayedRoute != null) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              minimumSize: const Size(96, 32),
              maximumSize: const Size(96, 32),
              padding: const EdgeInsets.all(0),
              foregroundColor: const Color(0xFFFFFFFF),
              backgroundColor: const Color(0xFFEF4444),
            ),
            onPressed: () {
              routeCubit.clearDisplayedRoute();
              graphhopperCubit.clearRoute();
            },
            child: const Text(
              style: TextStyle(fontSize: 12),
              "Clear Route",
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class InformationMessage extends StatelessWidget {
  const InformationMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(
      builder: (context, mapState) {
        if (mapState.userPosition == null) {
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
    PositionCubit positionCubit = context.read<PositionCubit>();

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
              onPressed: positionCubit.trackUserPosition,
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
