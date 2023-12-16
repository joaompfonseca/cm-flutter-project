import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_x/cubit/geocoding.dart';
import 'package:project_x/cubit/graphhopper.dart';
import 'package:project_x/cubit/position.dart';
import 'package:project_x/cubit/token.dart';
import 'package:project_x/route/route.dart';
import 'package:http/http.dart';
import 'dart:convert';

class RouteState {
  final List<CustomRoute> createdRouteList;
  final List<CustomRoute> trackedRouteList;
  final bool isCreatingRoute;
  final bool isTrackingRoute;
  // Locations of the currently created route
  final List<TextEditingController> createdRouteLocationList;
  // Points of the currently tracked route
  final List<RoutePoint> trackedRoutePointList;
  // Currently displayed route
  final CustomRoute? displayedRoute;
  final List<Point> displayedRoutePoints;
  final PositionCubit positionCubit;
  final GraphhopperCubit graphhopperCubit;
  final TokenCubit tokenCubit;
  final GeocodingCubit geocodingCubit;

  RouteState({
    required this.createdRouteList,
    required this.trackedRouteList,
    required this.isCreatingRoute,
    required this.isTrackingRoute,
    required this.createdRouteLocationList,
    required this.trackedRoutePointList,
    required this.displayedRoute,
    required this.displayedRoutePoints,
    required this.positionCubit,
    required this.graphhopperCubit,
    required this.tokenCubit,
    required this.geocodingCubit,
  });
}

class RouteCubit extends Cubit<RouteState> {
  final String gwDomain = dotenv.env['GW_DOMAIN']!;

  RouteCubit(routeState) : super(routeState) {
    routeState.positionCubit.stream.listen((position) {
      if (state.isTrackingRoute && position != null) {
        addTrackedRoutePoint(RoutePoint(
          label: "Point ${state.trackedRoutePointList.length}",
          latitude: position.latitude,
          longitude: position.longitude,
        ));
      }
    });
    routeState.graphhopperCubit.stream.listen((graphhopperState) {
      setDisplayedRoutePoints(graphhopperState.points);
    });
  }

  // Get Routes

  Future<void> getRoutes() async {
    final uri = Uri.https(gwDomain, 'api/route/get');

    final response = await get(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${state.tokenCubit.state}',
      },
    );

    var created = <CustomRoute>[];
    var recorded = <CustomRoute>[];

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      safePrint(data);
      var ctemp = data["created"];
      var rtemp = data["recorded"];

      //Created Routes
      for (var i = 0; i < ctemp.length; i++) {
        var points = <RoutePoint>[];
        for (var j = 0; j < ctemp[i]["points"].length; j++) {
          var p = ctemp[i]["points"][j]["latitude"];
          var p1 = ctemp[i]["points"][j]["longitude"];
          var names = ctemp[i]["name"].split("__");
          points.add(RoutePoint(
            label: "${names[j]}",
            latitude: p,
            longitude: p1,
          ));
        }
        created.add(CustomRoute(
          id: ctemp[i]["id"],
          points: points,
        ));
      }

      //Recorded Routes
      for (var i = 0; i < rtemp.length; i++) {
        var points = <RoutePoint>[];
        for (var j = 0; j < rtemp[i]["points"].length; j++) {
          var p = rtemp[i]["points"][j]["latitude"];
          var p1 = rtemp[i]["points"][j]["longitude"];
          var names = rtemp[i]["name"].split("__");
          if (j == 0) {
            points.add(RoutePoint(
              label: "${names[0]}",
              latitude: p,
              longitude: p1,
            ));
          } else if (j == rtemp[i]["points"].length - 1) {
            points.add(RoutePoint(
              label: "${names[1]}",
              latitude: p,
              longitude: p1,
            ));
          } else {
            points.add(RoutePoint(
              label: "Point ${j + 1}",
              latitude: p,
              longitude: p1,
            ));
          }
        }
        safePrint(points[0].label);
        recorded.add(CustomRoute(
          id: rtemp[i]["id"],
          points: points,
        ));
      }

      emit(RouteState(
        createdRouteList: created,
        trackedRouteList: recorded,
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: state.isTrackingRoute,
        createdRouteLocationList: state.createdRouteLocationList,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: state.displayedRoute,
        displayedRoutePoints: state.displayedRoutePoints,
        positionCubit: state.positionCubit,
        graphhopperCubit: state.graphhopperCubit,
        tokenCubit: state.tokenCubit,
        geocodingCubit: state.geocodingCubit,
      ));
    } else {
      throw Exception('Failed to fetch routes');
    }
  }

  Future<void> deleteCreatedRoute(String id) async {
    final uri = Uri.https(gwDomain, 'api/route/delete/$id');

    safePrint(id);

    final response = await delete(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${state.tokenCubit.state}',
      },
    );

    if (response.statusCode == 200) {
      // final data = jsonDecode(utf8.decode(response.bodyBytes));
      emit(RouteState(
        createdRouteList: state.createdRouteList
          ..removeWhere((element) => element.id == id),
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: state.isTrackingRoute,
        createdRouteLocationList: state.createdRouteLocationList,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: state.displayedRoute,
        displayedRoutePoints: state.displayedRoutePoints,
        positionCubit: state.positionCubit,
        graphhopperCubit: state.graphhopperCubit,
        tokenCubit: state.tokenCubit,
        geocodingCubit: state.geocodingCubit,
      ));
    } else {
      throw Exception('Failed to delete route');
    }
  }

  Future<void> deleteRecordedRoute(String id) async {
    final uri = Uri.https(gwDomain, 'api/route/delete/$id');

    safePrint(id);

    final response = await delete(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${state.tokenCubit.state}',
      },
    );

    if (response.statusCode == 200) {
      // final data = jsonDecode(utf8.decode(response.bodyBytes));
      emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList
          ..removeWhere((element) => element.id == id),
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: state.isTrackingRoute,
        createdRouteLocationList: state.createdRouteLocationList,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: state.displayedRoute,
        displayedRoutePoints: state.displayedRoutePoints,
        positionCubit: state.positionCubit,
        graphhopperCubit: state.graphhopperCubit,
        tokenCubit: state.tokenCubit,
        geocodingCubit: state.geocodingCubit,
      ));
    } else {
      throw Exception('Failed to delete route');
    }
  }

  // Created Route Functions

  void addCreatedRouteLocation(TextEditingController location, int index) =>
      emit(
        RouteState(
          createdRouteList: state.createdRouteList,
          trackedRouteList: state.trackedRouteList,
          isCreatingRoute: state.isCreatingRoute,
          isTrackingRoute: state.isTrackingRoute,
          createdRouteLocationList: state.createdRouteLocationList
            ..insert(index, location),
          trackedRoutePointList: state.trackedRoutePointList,
          displayedRoute: state.displayedRoute,
          displayedRoutePoints: state.displayedRoutePoints,
          positionCubit: state.positionCubit,
          graphhopperCubit: state.graphhopperCubit,
          tokenCubit: state.tokenCubit,
          geocodingCubit: state.geocodingCubit,
        ),
      );

  TextEditingController? deleteCreatedRouteLocation(int index) {
    if (index >= 0 && index < state.createdRouteLocationList.length) {
      TextEditingController removed = state.createdRouteLocationList[index];
      emit(
        RouteState(
          createdRouteList: state.createdRouteList,
          trackedRouteList: state.trackedRouteList,
          isCreatingRoute: state.isCreatingRoute,
          isTrackingRoute: state.isTrackingRoute,
          createdRouteLocationList: state.createdRouteLocationList
            ..removeAt(index),
          trackedRoutePointList: state.trackedRoutePointList,
          displayedRoute: state.displayedRoute,
          displayedRoutePoints: state.displayedRoutePoints,
          positionCubit: state.positionCubit,
          graphhopperCubit: state.graphhopperCubit,
          tokenCubit: state.tokenCubit,
          geocodingCubit: state.geocodingCubit,
        ),
      );
      return removed;
    }
    return null;
  }

  Future<void> saveCreatedRoute(CustomRoute route) async {
    final uri = Uri.https(gwDomain, 'api/route/create');

    var name = "";
    var points = [];

    for (var i = 0, len = route.points.length; i < len; i++) {
      //check if last point
      if (i == len - 1) {
        name += route.points[i].label;
      } else {
        name += "${route.points[i].label}__";
      }

      points.add("${route.points[i].latitude},${route.points[i].longitude}");
    }

    final response = await post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${state.tokenCubit.state}',
      },
      body: jsonEncode({
        "name": name,
        "points": points,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      emit(state
        ..createdRouteList
            .add(CustomRoute(id: data["id"], points: route.points)));
    } else {
      throw Exception('Failed to create route');
    }
  }

  void setIsCreatingRoute(bool value) => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: value,
        isTrackingRoute: state.isTrackingRoute,
        createdRouteLocationList: state.createdRouteLocationList,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: state.displayedRoute,
        displayedRoutePoints: state.displayedRoutePoints,
        positionCubit: state.positionCubit,
        graphhopperCubit: state.graphhopperCubit,
        tokenCubit: state.tokenCubit,
        geocodingCubit: state.geocodingCubit,
      ));

  void toggleIsCreatingRoute() => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: !state.isCreatingRoute,
        isTrackingRoute: state.isTrackingRoute,
        createdRouteLocationList: state.createdRouteLocationList,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: state.displayedRoute,
        displayedRoutePoints: state.displayedRoutePoints,
        positionCubit: state.positionCubit,
        graphhopperCubit: state.graphhopperCubit,
        tokenCubit: state.tokenCubit,
        geocodingCubit: state.geocodingCubit,
      ));

  // Tracked Route Functions

  void startTrackingRoute() => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: true,
        createdRouteLocationList: state.createdRouteLocationList,
        trackedRoutePointList: [],
        displayedRoute: state.displayedRoute,
        displayedRoutePoints: state.displayedRoutePoints,
        positionCubit: state.positionCubit,
        graphhopperCubit: state.graphhopperCubit,
        tokenCubit: state.tokenCubit,
        geocodingCubit: state.geocodingCubit,
      ));

  void addTrackedRoutePoint(RoutePoint point) => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: state.isTrackingRoute,
        createdRouteLocationList: state.createdRouteLocationList,
        trackedRoutePointList: [...state.trackedRoutePointList, point],
        displayedRoute: state.displayedRoute,
        displayedRoutePoints: state.displayedRoutePoints,
        positionCubit: state.positionCubit,
        graphhopperCubit: state.graphhopperCubit,
        tokenCubit: state.tokenCubit,
        geocodingCubit: state.geocodingCubit,
      ));

  void stopTrackingRoute() => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: false,
        createdRouteLocationList: state.createdRouteLocationList,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: state.displayedRoute,
        displayedRoutePoints: state.displayedRoutePoints,
        positionCubit: state.positionCubit,
        graphhopperCubit: state.graphhopperCubit,
        tokenCubit: state.tokenCubit,
        geocodingCubit: state.geocodingCubit,
      ));

  Future<void> saveTrackedRoute(CustomRoute route) async {
    final uri = Uri.https(gwDomain, 'api/route/create');

    var name = "";
    var points = [];

    for (var i = 0, len = route.points.length; i < len; i++) {
      //check if first point
      if (i == 0) {
        var g = await state.geocodingCubit.locationFromCoordinates(
            LatLng(route.points[i].latitude, route.points[i].longitude));
        if (g == null) {
          throw Exception("Can't get location");
        } else {
          name += "${g.location!}__";
        }
      }

      //check if last point
      if (i == len - 1) {
        var g = await state.geocodingCubit.locationFromCoordinates(
            LatLng(route.points[i].latitude, route.points[i].longitude));
        if (g == null) {
          throw Exception("Can't get location");
        } else {
          name += g.location!;
        }
      }

      points.add("${route.points[i].latitude},${route.points[i].longitude}");
    }

    final response = await post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${state.tokenCubit.state}',
      },
      body: jsonEncode({
        "name": name,
        "points": points,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      emit(state
        ..trackedRouteList
            .add(CustomRoute(id: data["id"], points: route.points)));
    } else {
      throw Exception('Failed to create route');
    }
  }

  void clearTrackedRoute() => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: state.isTrackingRoute,
        createdRouteLocationList: state.createdRouteLocationList,
        trackedRoutePointList: [],
        displayedRoute: state.displayedRoute,
        displayedRoutePoints: state.displayedRoutePoints,
        positionCubit: state.positionCubit,
        graphhopperCubit: state.graphhopperCubit,
        tokenCubit: state.tokenCubit,
        geocodingCubit: state.geocodingCubit,
      ));

  // Displayed Route Functions

  void setDisplayedRoute(CustomRoute route) => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: state.isTrackingRoute,
        createdRouteLocationList: state.createdRouteLocationList,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: route,
        displayedRoutePoints: state.displayedRoutePoints,
        positionCubit: state.positionCubit,
        graphhopperCubit: state.graphhopperCubit,
        tokenCubit: state.tokenCubit,
        geocodingCubit: state.geocodingCubit,
      ));

  void setDisplayedRoutePoints(List<Point> points) => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: state.isTrackingRoute,
        createdRouteLocationList: state.createdRouteLocationList,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: state.displayedRoute,
        displayedRoutePoints: points,
        positionCubit: state.positionCubit,
        graphhopperCubit: state.graphhopperCubit,
        tokenCubit: state.tokenCubit,
        geocodingCubit: state.geocodingCubit,
      ));

  void clearDisplayedRoute() => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: state.isTrackingRoute,
        createdRouteLocationList: state.createdRouteLocationList,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: null,
        displayedRoutePoints: [],
        positionCubit: state.positionCubit,
        graphhopperCubit: state.graphhopperCubit,
        tokenCubit: state.tokenCubit,
        geocodingCubit: state.geocodingCubit,
      ));
}
