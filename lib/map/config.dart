import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

MapController mapController = MapController.cyclOSMLayer(
  initMapWithUserPosition: const UserTrackingOption(
    enableTracking: true,
    unFollowUser: true,
  ),
);

OSMOption osmOption = OSMOption(
  zoomOption: const ZoomOption(
    initZoom: 15,
    minZoomLevel: 3,
    maxZoomLevel: 19,
    stepZoom: 1.0,
  ),
  enableRotationByGesture: false,
  userLocationMarker: UserLocationMaker(
    personMarker: const MarkerIcon(
      icon: Icon(
        Icons.circle,
        color: Colors.blueAccent,
        size: 100,
      ),
    ),
    directionArrowMarker: const MarkerIcon(
      icon: Icon(
        Icons.arrow_circle_right_outlined,
        color: Colors.blueAccent,
        size: 100,
      ),
    ),
  ),
  roadConfiguration: const RoadOption(
    roadColor: Colors.yellowAccent,
  ),
);
