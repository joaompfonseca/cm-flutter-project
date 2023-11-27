import 'package:flutter/material.dart';
import 'package:hw_map/route.dart';

class RouteDetails extends StatelessWidget {
  final RecordedRoute route;

  const RouteDetails({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Route Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("Origin: ${route.origin}"),
                Text("Destination: ${route.destination}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
