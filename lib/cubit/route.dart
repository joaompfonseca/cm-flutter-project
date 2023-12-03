import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_map/cubit/graphhopper.dart';
import 'package:hw_map/cubit/position.dart';
import 'package:hw_map/route/route.dart';

class RouteState {
  final List<CustomRoute> createdRouteList;
  final List<CustomRoute> trackedRouteList;
  final bool isCreatingRoute;
  final bool isTrackingRoute;
  // Points of the currently tracked route
  final List<RoutePoint> trackedRoutePointList;
  // Currently displayed route
  final CustomRoute? displayedRoute;
  final List<Point> displayedRoutePoints;
  final PositionCubit positionCubit;
  final GraphhopperCubit graphhopperCubit;

  RouteState({
    required this.createdRouteList,
    required this.trackedRouteList,
    required this.isCreatingRoute,
    required this.isTrackingRoute,
    required this.trackedRoutePointList,
    required this.displayedRoute,
    required this.displayedRoutePoints,
    required this.positionCubit,
    required this.graphhopperCubit,
  });
}

class RouteCubit extends Cubit<RouteState> {
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
    routeState.graphhopperCubit.stream.listen((points) {
      setDisplayedRoutePoints(points);
    });
  }

  // Created Route Functions

  void createCreatedRoute(CustomRoute route) => emit(RouteState(
        createdRouteList: [...state.createdRouteList, route],
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: state.isTrackingRoute,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: state.displayedRoute,
        displayedRoutePoints: state.displayedRoutePoints,
        positionCubit: state.positionCubit,
        graphhopperCubit: state.graphhopperCubit,
      ));

  void deleteCreatedRoute(CustomRoute route) => emit(RouteState(
        createdRouteList: state.createdRouteList..remove(route),
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: state.isTrackingRoute,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: state.displayedRoute,
        displayedRoutePoints: state.displayedRoutePoints,
        positionCubit: state.positionCubit,
        graphhopperCubit: state.graphhopperCubit,
      ));

  void setIsCreatingRoute(bool value) => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: value,
        isTrackingRoute: state.isTrackingRoute,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: state.displayedRoute,
        displayedRoutePoints: state.displayedRoutePoints,
        positionCubit: state.positionCubit,
        graphhopperCubit: state.graphhopperCubit,
      ));

  void toggleIsCreatingRoute() => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: !state.isCreatingRoute,
        isTrackingRoute: state.isTrackingRoute,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: state.displayedRoute,
        displayedRoutePoints: state.displayedRoutePoints,
        positionCubit: state.positionCubit,
        graphhopperCubit: state.graphhopperCubit,
      ));

  // Tracked Route Functions

  void startTrackingRoute() => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: true,
        trackedRoutePointList: [],
        displayedRoute: state.displayedRoute,
        displayedRoutePoints: state.displayedRoutePoints,
        positionCubit: state.positionCubit,
        graphhopperCubit: state.graphhopperCubit,
      ));

  void addTrackedRoutePoint(RoutePoint point) => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: state.isTrackingRoute,
        trackedRoutePointList: [...state.trackedRoutePointList, point],
        displayedRoute: state.displayedRoute,
        displayedRoutePoints: state.displayedRoutePoints,
        positionCubit: state.positionCubit,
        graphhopperCubit: state.graphhopperCubit,
      ));

  void stopTrackingRoute() => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: false,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: state.displayedRoute,
        displayedRoutePoints: state.displayedRoutePoints,
        positionCubit: state.positionCubit,
        graphhopperCubit: state.graphhopperCubit,
      ));

  void saveTrackedRoute(CustomRoute route) => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: [...state.trackedRouteList, route],
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: state.isTrackingRoute,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: state.displayedRoute,
        displayedRoutePoints: state.displayedRoutePoints,
        positionCubit: state.positionCubit,
        graphhopperCubit: state.graphhopperCubit,
      ));

  void clearTrackedRoute() => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: state.isTrackingRoute,
        trackedRoutePointList: [],
        displayedRoute: state.displayedRoute,
        displayedRoutePoints: state.displayedRoutePoints,
        positionCubit: state.positionCubit,
        graphhopperCubit: state.graphhopperCubit,
      ));

  // Displayed Route Functions

  void setDisplayedRoute(CustomRoute route) => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: state.isTrackingRoute,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: route,
        displayedRoutePoints: state.displayedRoutePoints,
        positionCubit: state.positionCubit,
        graphhopperCubit: state.graphhopperCubit,
      ));

  void setDisplayedRoutePoints(List<Point> points) => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: state.isTrackingRoute,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: state.displayedRoute,
        displayedRoutePoints: points,
        positionCubit: state.positionCubit,
        graphhopperCubit: state.graphhopperCubit,
      ));

  void clearDisplayedRoute() => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: state.isTrackingRoute,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: null,
        displayedRoutePoints: [],
        positionCubit: state.positionCubit,
        graphhopperCubit: state.graphhopperCubit,
      ));
}
