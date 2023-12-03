import 'package:flutter_bloc/flutter_bloc.dart';
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
  final PositionCubit positionCubit;

  RouteState({
    required this.createdRouteList,
    required this.trackedRouteList,
    required this.isCreatingRoute,
    required this.isTrackingRoute,
    required this.trackedRoutePointList,
    required this.displayedRoute,
    required this.positionCubit,
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
  }

  // Created Route Functions

  void createCreatedRoute(CustomRoute route) => emit(RouteState(
        createdRouteList: [...state.createdRouteList, route],
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: state.isTrackingRoute,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: state.displayedRoute,
        positionCubit: state.positionCubit,
      ));

  void deleteCreatedRoute(CustomRoute route) => emit(RouteState(
        createdRouteList: state.createdRouteList..remove(route),
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: state.isTrackingRoute,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: state.displayedRoute,
        positionCubit: state.positionCubit,
      ));

  void setIsCreatingRoute(bool value) => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: value,
        isTrackingRoute: state.isTrackingRoute,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: state.displayedRoute,
        positionCubit: state.positionCubit,
      ));

  void toggleIsCreatingRoute() => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: !state.isCreatingRoute,
        isTrackingRoute: state.isTrackingRoute,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: state.displayedRoute,
        positionCubit: state.positionCubit,
      ));

  // Tracked Route Functions

  void startTrackingRoute() => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: true,
        trackedRoutePointList: [],
        displayedRoute: state.displayedRoute,
        positionCubit: state.positionCubit,
      ));

  void addTrackedRoutePoint(RoutePoint point) => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: state.isTrackingRoute,
        trackedRoutePointList: [...state.trackedRoutePointList, point],
        displayedRoute: state.displayedRoute,
        positionCubit: state.positionCubit,
      ));

  void stopTrackingRoute() => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: false,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: state.displayedRoute,
        positionCubit: state.positionCubit,
      ));

  void saveTrackedRoute(CustomRoute route) => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: [...state.trackedRouteList, route],
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: state.isTrackingRoute,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: state.displayedRoute,
        positionCubit: state.positionCubit,
      ));

  // Displayed Route Functions

  void setDisplayedRoute(CustomRoute route) => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: state.isTrackingRoute,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: route,
        positionCubit: state.positionCubit,
      ));

  void clearDisplayedRoute() => emit(RouteState(
        createdRouteList: state.createdRouteList,
        trackedRouteList: state.trackedRouteList,
        isCreatingRoute: state.isCreatingRoute,
        isTrackingRoute: state.isTrackingRoute,
        trackedRoutePointList: state.trackedRoutePointList,
        displayedRoute: null,
        positionCubit: state.positionCubit,
      ));
}
