import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:hw_map/poi.dart';
import 'package:hw_map/poi_details.dart';

class Map extends StatefulWidget {
  final MapController mapController;
  final OSMOption osmOption;
  final List<Poi> poiList;
  final void Function(BuildContext context, Poi poi) deletePoi;
  final void Function(BuildContext context, Poi poi) showPoi;

  const Map({
    super.key,
    required this.mapController,
    required this.osmOption,
    required this.poiList,
    required this.deletePoi,
    required this.showPoi,
  });

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map>
    with AutomaticKeepAliveClientMixin<Map>, OSMMixinObserver {
  late MapController mapController;
  late OSMOption osmOption;
  late List<Poi> poiList;
  late List<Poi> oldPoiList; // Compare against poiList to update markers
  late void Function(BuildContext context, Poi poi) deletePoi;
  late void Function(BuildContext context, Poi poi) showPoi;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    mapController = widget.mapController;
    mapController.addObserver(this);
    osmOption = widget.osmOption;
    poiList = widget.poiList;
    oldPoiList = [];
    deletePoi = widget.deletePoi;
    showPoi = widget.showPoi;
  }

  @override
  void didUpdateWidget(Map oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateMarkers();
  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady) {
      updateMarkers();
    }
  }

  void updateMarkers() {
    for (var poi in oldPoiList) {
      if (!poiList.contains(poi)) {
        mapController.removeMarker(
          GeoPoint(latitude: poi.latitude, longitude: poi.longitude),
        );
      }
    }
    for (var poi in poiList) {
      if (!oldPoiList.contains(poi)) {
        mapController.addMarker(
          GeoPoint(latitude: poi.latitude, longitude: poi.longitude),
        );
      }
    }
    oldPoiList = List.from(poiList);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return OSMFlutter(
      controller: mapController,
      osmOption: osmOption,
      onGeoPointClicked: (geoPoint) {
        var poi = poiList.firstWhere((poi) =>
            poi.latitude == geoPoint.latitude &&
            poi.longitude == geoPoint.longitude);
        mapController
            .goToLocation(
              GeoPoint(
                  latitude: poi.latitude - 0.0005, longitude: poi.longitude),
            )
            .then(
              (_) => {
                Future.delayed(
                  const Duration(seconds: 2),
                  () => mapController.setZoom(zoomLevel: 18.0),
                ),
              },
            );
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            // ignore: sized_box_for_whitespace
            return Container(
              height: 400,
              child: PoiDetails(
                poi: poi,
              ),
            );
          },
        );
      },
    );
  }
}
