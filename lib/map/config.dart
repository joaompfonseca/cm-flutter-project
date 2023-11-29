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
        Icons.location_history_rounded,
        color: Colors.red,
        size: 100,
      ),
    ),
    directionArrowMarker: const MarkerIcon(
      icon: Icon(
        Icons.double_arrow,
        size: 50,
      ),
    ),
  ),
  roadConfiguration: const RoadOption(
    roadColor: Colors.yellowAccent,
  ),
  markerOption: MarkerOption(
      defaultMarker: const MarkerIcon(
    icon: Icon(
      Icons.person_pin_circle,
      color: Colors.blue,
      size: 50,
    ),
  )),
);
