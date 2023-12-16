import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

String tileLayerUrl =
    'https://{s}.tile-cyclosm.openstreetmap.fr/cyclosm/{z}/{x}/{y}.png';

MapController mapController = MapController();

MapOptions mapOptions = const MapOptions(
  initialCenter: LatLng(40.6405, -8.6538), // Aveiro, Portugal
  initialZoom: 14.0,
  minZoom: 3.0,
  maxZoom: 18.0,
  interactionOptions: InteractionOptions(
    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
  ),
  keepAlive: true,
);
