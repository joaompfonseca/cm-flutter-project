import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_map/cubit/map.dart';
import 'package:hw_map/cubit/route.dart';
import 'package:hw_map/route/route.dart';

class TrackRouteButton extends StatelessWidget {
  const TrackRouteButton({super.key});

  @override
  Widget build(BuildContext context) {
    MapCubit mapCubit = context.read<MapCubit>();
    RouteCubit routeCubit = context.read<RouteCubit>();

    return BlocBuilder<RouteCubit, RouteState>(
      builder: (context, routeState) {
        if (routeState.isTrackingRoute) {
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
              routeCubit.stopTrackingRoute();
              mapCubit.setTrackingUserPosition(false);
              if (routeState.trackedRoutePointList.length >= 2) {
                CustomRoute route = CustomRoute(
                  id: "poi${DateTime.timestamp()}", // TODO: remove
                  points: routeState.trackedRoutePointList,
                );
                routeCubit.saveTrackedRoute(route);
              }
            },
            child: const Icon(Icons.directions),
          );
        } else {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
              foregroundColor: const Color(0xFFFFFFFF),
              backgroundColor: const Color(0xFF4CAF50),
            ),
            onPressed: () {
              routeCubit.startTrackingRoute();
              mapCubit.setTrackingUserPosition(true);
            },
            child: const Icon(Icons.directions),
          );
        }
      },
    );
  }
}
