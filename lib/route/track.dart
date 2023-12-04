import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_x/cubit/map.dart';
import 'package:project_x/cubit/route.dart';
import 'package:project_x/route/route.dart';
import 'package:project_x/util/message.dart';

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
              shape: const CircleBorder(),
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
              foregroundColor: const Color(0xFFFFFFFF),
              backgroundColor: const Color(0xFFEF4444),
              fixedSize: const Size(96, 96),
            ),
            onPressed: () {
              routeCubit.stopTrackingRoute();
              mapCubit.setTrackingUserPosition(false);
              if (routeState.trackedRoutePointList.length > 2) {
                showSnackBar(context, "Saved route");
                CustomRoute route = CustomRoute(
                  id: "poi${DateTime.timestamp()}", // TODO: remove
                  points: routeState.trackedRoutePointList,
                );
                routeCubit.saveTrackedRoute(route);
              }
              routeCubit.clearTrackedRoute();
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.directions_bike_rounded),
                Text('Stop'),
              ],
            ),
          );
        } else {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
              foregroundColor: const Color(0xFFFFFFFF),
              backgroundColor: const Color(0xFF4CAF50),
              fixedSize: const Size(96, 96),
            ),
            onPressed: () {
              mapCubit.flyToUserPosition();
              mapCubit.setTrackingUserPosition(true);
              routeCubit.startTrackingRoute();
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.directions_bike_rounded),
                Text('Track me!'),
              ],
            ),
          );
        }
      },
    );
  }
}
