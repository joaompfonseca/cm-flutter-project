import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_x/cubit/graphhopper.dart';
import 'package:project_x/cubit/map.dart';
import 'package:project_x/cubit/route.dart';
import 'package:project_x/route/create.dart';
import 'package:project_x/route/route.dart';
import 'package:project_x/route/details.dart';
import 'package:project_x/util/button.dart';
import 'package:project_x/util/message.dart';

class RouteList extends StatelessWidget {
  const RouteList({super.key});

  @override
  Widget build(BuildContext context) {
    MapCubit mapCubit = context.read<MapCubit>();
    RouteCubit routeCubit = context.read<RouteCubit>();
    GraphhopperCubit graphhopperCubit = context.read<GraphhopperCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Routes",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<RouteCubit, RouteState>(
        builder: (context, routeState) => ListView(
          children: [
            ExpansionTile(
              title: const Text('Created Routes'),
              subtitle: const Text(
                  'Routes that you created by specifying the points on the map'),
              initiallyExpanded: true,
              shape: const RoundedRectangleBorder(),
              children: routeState.createdRouteList
                  .map(
                    (route) => RouteItem(
                      route: route,
                      isCondensed: false,
                      onDetails: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RouteDetails(
                              route: route,
                              isCondensed: false,
                            ),
                          ),
                        );
                      },
                      onDelete: () async {
                        try {
                          // Ask user if they want to delete the route
                          bool willDeleteRoute = await showDialogMessage(
                                context,
                                "Delete route?",
                                "Are you sure you want to delete this route?",
                                "No",
                                "Yes",
                              ) ??
                              false;
                          if (willDeleteRoute) {
                            routeCubit.deleteCreatedRoute(route.id);
                            // ignore: use_build_context_synchronously
                            showSnackBar(context, "Deleted route");
                          }
                        } catch (e) {
                          // ignore: use_build_context_synchronously
                          showSnackBar(context, "Error deleting route");
                        }
                      },
                      onShow: () {
                        routeCubit.setIsCreatingRoute(false);
                        routeCubit.setDisplayedRoute(route);
                        graphhopperCubit.fetchRoute(route);
                        DefaultTabController.of(context).animateTo(1);
                        RoutePoint start = route.points[0];
                        mapCubit.flyTo(
                          latitude: start.latitude,
                          longitude: start.longitude,
                          zoom: 14.0,
                        );
                        showSnackBar(context, "Displaying ${route.name}");
                      },
                    ),
                  )
                  .toList(),
            ),
            ExpansionTile(
              title: const Text('Tracked Routes'),
              subtitle: const Text(
                  'Routes that you tracked using your device position'),
              initiallyExpanded: true,
              shape: const RoundedRectangleBorder(),
              children: routeState.trackedRouteList
                  .map(
                    (route) => RouteItem(
                      route: route,
                      isCondensed: true,
                      onDetails: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RouteDetails(
                              route: route,
                              isCondensed: true,
                            ),
                          ),
                        );
                      },
                      onDelete: () async {
                        try {
                          // Ask user if they want to delete the route
                          bool willDeleteRoute = await showDialogMessage(
                                context,
                                "Delete route?",
                                "Are you sure you want to delete this route?",
                                "No",
                                "Yes",
                              ) ??
                              false;
                          if (willDeleteRoute) {
                            routeCubit.deleteRecordedRoute(route.id);
                            // ignore: use_build_context_synchronously
                            showSnackBar(context, "Deleted route");
                          }
                        } catch (e) {
                          // ignore: use_build_context_synchronously
                          showSnackBar(context, "Error deleting route");
                        }
                      },
                      onShow: () {
                        routeCubit.setIsCreatingRoute(false);
                        routeCubit.setDisplayedRoute(route);
                        routeCubit.setDisplayedRoutePoints(route.points);
                        graphhopperCubit.clearRoute();
                        DefaultTabController.of(context).animateTo(1);
                        RoutePoint start = route.points[0];
                        mapCubit.flyTo(
                          latitude: start.latitude,
                          longitude: start.longitude,
                          zoom: 14.0,
                        );
                        showSnackBar(context, "Displaying ${route.name}");
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
      floatingActionButton: CreateRouteFormButton(
        onPressed: () {
          DefaultTabController.of(context).animateTo(1);
          routeCubit.setIsCreatingRoute(true);
        },
      ),
    );
  }
}

class RouteItem extends StatelessWidget {
  final CustomRoute route;
  final bool isCondensed;
  final VoidCallback onDetails;
  final VoidCallback onDelete;
  final VoidCallback onShow;

  const RouteItem(
      {super.key,
      required this.route,
      required this.isCondensed,
      required this.onDetails,
      required this.onDelete,
      required this.onShow});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onDetails,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top:
                  BorderSide(color: Theme.of(context).colorScheme.onBackground),
              left:
                  BorderSide(color: Theme.of(context).colorScheme.onBackground),
              right:
                  BorderSide(color: Theme.of(context).colorScheme.onBackground),
              bottom:
                  BorderSide(color: Theme.of(context).colorScheme.onBackground),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.directions_rounded),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        route.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        (isCondensed)
                            ? "${route.points.first.label} - ${route.points.last.label}"
                            : route.points.map((p) => p.label).join(" - "),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DeleteButton(onPressed: onDelete),
                    const SizedBox(width: 8),
                    MapButton(onPressed: onShow),
                    const SizedBox(width: 8),
                    DetailsButton(onPressed: onDetails),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
