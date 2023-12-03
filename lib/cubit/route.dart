import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_map/route/route.dart';

class RouteState {
  final List<CreatedRoute> createdRouteList;
  final List<TrackedRoute> trackedRouteList;
  final bool isCreatingRoute;
  final bool isTrackingRoute;

  RouteState(
    this.createdRouteList,
    this.trackedRouteList,
    this.isCreatingRoute,
    this.isTrackingRoute,
  );
}

class RouteCubit extends Cubit<RouteState> {
  RouteCubit(routeState) : super(routeState);

  void setIsCreatingRoute(bool value) => emit(
        RouteState(
          state.createdRouteList,
          state.trackedRouteList,
          value,
          state.isTrackingRoute,
        ),
      );

  void toggleIsCreatingRoute() => emit(
        RouteState(
          state.createdRouteList,
          state.trackedRouteList,
          !state.isCreatingRoute,
          state.isTrackingRoute,
        ),
      );

  void createCreatedRoute(CreatedRoute route) => emit(
        RouteState(
          [...state.createdRouteList, route],
          state.trackedRouteList,
          state.isCreatingRoute,
          state.isTrackingRoute,
        ),
      );

  void deleteCreatedRoute(CreatedRoute route) => emit(
        RouteState(
          state.createdRouteList..remove(route),
          state.trackedRouteList,
          state.isCreatingRoute,
          state.isTrackingRoute,
        ),
      );
}
