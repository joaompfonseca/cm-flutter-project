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
              minimumSize: const Size(96, 96),
              maximumSize: const Size(96, 96),
              padding: const EdgeInsets.all(0),
              foregroundColor: const Color(0xFFFFFFFF),
              backgroundColor: const Color(0xFFEF4444),
            ),
            onPressed: () async {
              routeCubit.stopTrackingRoute();
              mapCubit.setTrackingUserPosition(false);
              if (routeState.trackedRoutePointList.length > 2) {
                // Ask user if they want to save the route
                bool willSaveRoute = await showDialogMessage(
                      context,
                      "Save route?",
                      "Do you want to save the route you just tracked?",
                      "No",
                      "Yes",
                    ) ??
                    false;
                if (willSaveRoute) {
                  // ignore: use_build_context_synchronously
                  showSnackBar(context, "Saved route");
                  CustomRoute route = CustomRoute(
                    id: "route-${DateTime.timestamp()}", // Gets a unique ID by the API
                    points: routeState.trackedRoutePointList,
                  );
                  routeCubit.saveTrackedRoute(route);
                }
              }
              routeCubit.clearTrackedRoute();
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  size: 16,
                  Icons.directions_bike_rounded,
                ),
                Text(
                  style: TextStyle(fontSize: 12),
                  "Stop",
                ),
              ],
            ),
          );
        } else {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              minimumSize: const Size(96, 96),
              maximumSize: const Size(96, 96),
              padding: const EdgeInsets.all(0),
              foregroundColor: const Color(0xFFFFFFFF),
              backgroundColor: const Color(0xFF4CAF50),
            ),
            onPressed: () {
              mapCubit.flyToUserPosition();
              mapCubit.setTrackingUserPosition(true);
              routeCubit.startTrackingRoute();
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  size: 16,
                  Icons.directions_bike_rounded,
                ),
                Text(
                  style: TextStyle(fontSize: 12),
                  "Track Route",
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
