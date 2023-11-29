import 'package:flutter/material.dart';
import 'package:hw_map/route.dart';

class RouteDetails extends StatelessWidget {
  final CreatedRoute route;

  const RouteDetails({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Route Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Origin",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(route.origin),
              const SizedBox(height: 20),
              const Text(
                "Destination",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(route.destination),
              const SizedBox(height: 20),
              const Text(
                "Points",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ...route.points
                  .map((point) => Text(
                        "Label: ${point.label}, Latitude: ${point.latitude}, Longitude: ${point.longitude}",
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
