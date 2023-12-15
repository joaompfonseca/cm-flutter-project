import 'package:flutter/material.dart';
import 'package:project_x/route/route.dart';
import 'package:project_x/util/assets.dart';
import 'package:project_x/util/location.dart';

class RouteDetails extends StatelessWidget {
  final CustomRoute route;
  final bool isCondensed;

  const RouteDetails({
    super.key,
    required this.route,
    required this.isCondensed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          route.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  getMarkerImage("route-start"),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      route.points.first.label,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text("(Origin)"),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const SizedBox(width: 9),
                  const Icon(Icons.arrow_downward_rounded),
                  const SizedBox(width: 16),
                  Text(
                    "${(distanceBetween(route.points.first, (isCondensed) ? route.points.last : route.points[1]) / 1000).toStringAsFixed(2)} km",
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (!isCondensed)
                for (int i = 1; i < route.points.length - 1; i++)
                  Column(
                    children: [
                      Row(
                        children: [
                          getMarkerImage("route-intermediate"),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              route.points[i].label,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const SizedBox(width: 9),
                          const Icon(Icons.arrow_downward_rounded),
                          const SizedBox(width: 16),
                          Text(
                            "${(distanceBetween(route.points[i], route.points[i + 1]) / 1000).toStringAsFixed(2)} km",
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
              Row(
                children: [
                  getMarkerImage("route-end"),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      route.points.last.label,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text("(Destination)"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
