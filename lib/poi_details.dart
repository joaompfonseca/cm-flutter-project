import 'package:flutter/material.dart';
import 'package:hw_map/poi.dart';

class PoiDetails extends StatelessWidget {
  final Poi poi;

  const PoiDetails({
    super.key,
    required this.poi,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("POI Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Name",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(poi.name),
              const SizedBox(height: 20),
              const Text(
                "Type",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(poi.type),
              const SizedBox(height: 20),
              const Text(
                "Description",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(poi.description),
              const SizedBox(height: 20),
              const Text(
                "Added by",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(poi.addedBy),
              const SizedBox(height: 20),
              const Text(
                "Ratings",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                  "Positive: ${poi.ratingPositive}, Negative: ${poi.ratingNegative}"),
              const SizedBox(height: 20),
              Image(
                image: NetworkImage(poi.pictureUrl),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
