import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hw_map/cubit/map.dart';
import 'package:hw_map/cubit/route.dart';
import 'package:hw_map/mock/route.dart';
import 'package:hw_map/route/route.dart';
import 'package:hw_map/route/details.dart';
import 'package:hw_map/util/message.dart';

class RouteList extends StatelessWidget {
  const RouteList({super.key});

  @override
  Widget build(BuildContext context) {
    MapCubit mapCubit = context.read<MapCubit>();
    RouteCubit routeCubit = context.read<RouteCubit>();

    return Scaffold(
      body: BlocBuilder<RouteCubit, List<CreatedRoute>>(
        builder: (context, routeList) {
          return ListView.builder(
              itemCount: routeList.length,
              itemBuilder: (context, index) {
                CreatedRoute route = routeList[index];
                return RouteItem(
                    route: route,
                    onDelete: (BuildContext context) {
                      showSnackBar(context, "Deleted ${route.name}");
                      routeCubit.deleteRoute(route);
                    },
                    onShow: (BuildContext context) {
                      showSnackBar(context, "Showing ${route.name}");
                      DefaultTabController.of(context).animateTo(0);
                      RoutePoint start = route.points[0];
                      mapCubit.flyTo(start.latitude, start.longitude, 18.0);
                    });
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          int i = routeCubit.state.length + 1;
          CreatedRoute route = mockRoute(i);
          showSnackBar(context, "Created ${route.name}");
          routeCubit.createRoute(route);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class RouteItem extends StatelessWidget {
  final CreatedRoute route;
  final void Function(BuildContext context) onDelete;
  final void Function(BuildContext context) onShow;

  const RouteItem(
      {super.key,
      required this.route,
      required this.onDelete,
      required this.onShow});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: onDelete,
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          )
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 2,
            onPressed: onShow,
            backgroundColor: const Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.map,
            label: 'Show on Map',
          ),
        ],
      ),
      child: ListTile(
          title: Text("From: ${route.origin}"),
          subtitle: Text("To: ${route.destination}"),
          tileColor: Colors.orange[50],
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RouteDetails(
                route: route,
              ),
            ));
          }),
    );
  }
}
