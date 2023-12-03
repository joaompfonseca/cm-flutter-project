import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_map/route/route.dart';

class RouteState {
  final List<CreatedRoute> createdRouteList;
  final List<TrackedRoute> trackedRouteList;
  final bool isCreatingRoute;
  final bool isTrackingRoute;
  // Points of the currently tracked route
  final List<TrackedRoutePoint> trackedRoutePointList;

  RouteState(
    this.createdRouteList,
    this.trackedRouteList,
    this.isCreatingRoute,
    this.isTrackingRoute,
    this.trackedRoutePointList,
  );
}

class RouteCubit extends Cubit<RouteState> {
  RouteCubit(routeState) : super(routeState);

  // Created Route Functions

  void createCreatedRoute(CreatedRoute route) => emit(RouteState(
        [...state.createdRouteList, route],
        state.trackedRouteList,
        state.isCreatingRoute,
        state.isTrackingRoute,
        state.trackedRoutePointList,
      ));

  void deleteCreatedRoute(CreatedRoute route) => emit(RouteState(
        state.createdRouteList..remove(route),
        state.trackedRouteList,
        state.isCreatingRoute,
        state.isTrackingRoute,
        state.trackedRoutePointList,
      ));

  void setIsCreatingRoute(bool value) => emit(RouteState(
        state.createdRouteList,
        state.trackedRouteList,
        value,
        state.isTrackingRoute,
        state.trackedRoutePointList,
      ));

  void toggleIsCreatingRoute() => emit(RouteState(
        state.createdRouteList,
        state.trackedRouteList,
        !state.isCreatingRoute,
        state.isTrackingRoute,
        state.trackedRoutePointList,
      ));

  // Tracked Route Functions

  void startTrackingRoute() => emit(RouteState(
        state.createdRouteList,
        state.trackedRouteList,
        state.isCreatingRoute,
        true,
        [],
      ));

  void addTrackedRoutePoint(TrackedRoutePoint point) => emit(RouteState(
        state.createdRouteList,
        state.trackedRouteList,
        state.isCreatingRoute,
        state.isTrackingRoute,
        [...state.trackedRoutePointList, point],
      ));

  void clearTrackedRoutePointList() => emit(RouteState(
        state.createdRouteList,
        state.trackedRouteList,
        state.isCreatingRoute,
        state.isTrackingRoute,
        [],
      ));

  void stopTrackingRoute() => emit(RouteState(
        state.createdRouteList,
        state.trackedRouteList,
        state.isCreatingRoute,
        false,
        state.trackedRoutePointList,
      ));

  void saveTrackedRoute(TrackedRoute route) => emit(RouteState(
        state.createdRouteList,
        [...state.trackedRouteList, route],
        state.isCreatingRoute,
        state.isTrackingRoute,
        state.trackedRoutePointList,
      ));
}
