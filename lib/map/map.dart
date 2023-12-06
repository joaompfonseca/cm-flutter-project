import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:project_x/cubit/geocoding.dart';
import 'package:project_x/cubit/graphhopper.dart';
import 'package:project_x/cubit/map.dart';
import 'package:project_x/cubit/poi.dart';
import 'package:project_x/cubit/position.dart';
import 'package:project_x/cubit/route.dart';
import 'package:project_x/map/config.dart';
import 'package:project_x/poi/create.dart';
import 'package:project_x/poi/details.dart';
import 'package:project_x/poi/poi.dart';
import 'package:project_x/profile/details.dart';
import 'package:project_x/route/create.dart';
import 'package:project_x/route/route.dart';
import 'package:project_x/route/track.dart';
import 'package:project_x/util/assets.dart';
import 'package:latlong2/latlong.dart';

class Map extends StatelessWidget {
  const Map({super.key});

  @override
  Widget build(BuildContext context) {
    MapCubit mapCubit = context.read<MapCubit>();
    RouteCubit routeCubit = context.read<RouteCubit>();

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
              /* Displayed Route Lines */
              BlocBuilder<RouteCubit, RouteState>(
                builder: (context, routeState) {
                  if (routeState.displayedRoutePoints.isNotEmpty) {
                    return PolylineLayer(
                      polylines: [
                        Polyline(
                          points: routeState.displayedRoutePoints
                              .map((point) =>
                                  LatLng(point.latitude, point.longitude))
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
                              .map((point) =>
                                  LatLng(point.latitude, point.longitude))
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
                      Point start = routeState.displayedRoute!.points.first;
                      Point end = routeState.displayedRoute!.points.last;
                      return MarkerLayer(
                        alignment: Alignment.topCenter,
                        markers: [
                          Marker(
                            point: LatLng(start.latitude, start.longitude),
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
                      Point start = routeState.displayedRoute!.points.first;
                      List<Point> intermediate =
                          routeState.displayedRoute!.points.sublist(
                        1,
                        routeState.displayedRoute!.points.length - 1,
                      );
                      Point end = routeState.displayedRoute!.points.last;
                      return MarkerLayer(
                        alignment: Alignment.topCenter,
                        markers: [
                          Marker(
                            point: LatLng(start.latitude, start.longitude),
                            width: 50.0,
                            height: 50.0,
                            child: getMarkerImage('route-start'),
                          ),
                          ...intermediate
                              .map((point) => Marker(
                                    point:
                                        LatLng(point.latitude, point.longitude),
                                    width: 50.0,
                                    height: 50.0,
                                    child: getMarkerImage('route-intermediate'),
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
          ),
          /* Buttons */
          Container(
            padding: const EdgeInsets.fromLTRB(16, 64, 16, 64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SearchLocationBar(),
                BlocBuilder<RouteCubit, RouteState>(
                  builder: (context, routeState) => Visibility(
                    visible: routeState.isCreatingRoute,
                    child: const CreateRouteForm(),
                  ),
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
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
        child: Row(
          children: [
            const SizedBox(width: 32),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const OpenCreatePoiFormButton(),
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClearDisplayedRouteButton(),
                      SizedBox(height: 16),
                      TrackRouteButton(),
                    ],
                  ),
                  CreateRouteFormButton(
                    onPressed: routeCubit.toggleIsCreatingRoute,
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
    GeocodingCubit geocodingCubit = context.read<GeocodingCubit>();
    MapCubit mapCubit = context.read<MapCubit>();

    return SearchAnchor(
      builder: (context, controller) => SearchBar(
        controller: controller,
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16),
        ),
        leading: const Icon(Icons.search),
        hintText: "Search Location",
        trailing: [
          GestureDetector(
            child: Icon(Icons.clear),
            onTap: () {
              controller.clear();
            },
          ),
        ],
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            geocodingCubit.coordinatesFromLocation(value).then((geocoding) => {
                  if (geocoding != null)
                    {
                      mapCubit.flyTo(
                        latitude: geocoding.coordinates!.latitude,
                        longitude: geocoding.coordinates!.longitude,
                        zoom: 18.0,
                      ),
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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ProfileDetails(),
          ),
        );
      },
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
                mapCubit.setTrackingUserPosition(true);
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
              mapCubit.setTrackingUserPosition(true);
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
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
              foregroundColor: const Color(0xFFFFFFFF),
              backgroundColor: const Color(0xFFEF4444),
            ),
            onPressed: () {
              routeCubit.clearDisplayedRoute();
              graphhopperCubit.clearPoints();
            },
            child: const SizedBox(
              height: 24,
              child: Center(
                child: Text("Clear Displayed Route"),
              ),
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
              onPressed: positionCubit.trackUserPosition,
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
