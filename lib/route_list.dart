import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hw_map/route.dart';
import 'package:hw_map/route_details.dart';

class RouteList extends StatelessWidget {
  final List<CreatedRoute> routeList;
  final void Function(BuildContext context, CreatedRoute route) addRoute;
  final void Function(BuildContext context, CreatedRoute route) deleteRoute;
  final void Function(BuildContext context, CreatedRoute route) showRoute;

  const RouteList({
    super.key,
    required this.routeList,
    required this.addRoute,
    required this.deleteRoute,
    required this.showRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: routeList
            .map((route) => RouteItem(
                  route: route,
                  onDelete: (BuildContext context) =>
                      deleteRoute(context, route),
                  onShow: (BuildContext context) => showRoute(context, route),
                ))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          int n = routeList.length + 1;
          CreatedRoute route = CreatedRoute(
            origin: "route$n origin",
            destination: "route$n destination",
            points: [
              RoutePoint(
                label: "route$n origin",
                latitude: 0.0,
                longitude: 0.0,
              ),
              RoutePoint(
                label: "route$n destination",
                latitude: 0.0,
                longitude: 0.0,
              ),
            ],
          );
          addRoute(
            context,
            route,
          );
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
