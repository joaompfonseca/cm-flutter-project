import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:hw_map/cubit/map.dart';
import 'package:hw_map/cubit/poi.dart';
import 'package:hw_map/cubit/route.dart';
import 'package:hw_map/poi/poi.dart';
import 'package:hw_map/poi/details.dart';
import 'package:hw_map/util/assets.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map>
    with AutomaticKeepAliveClientMixin<Map>, OSMMixinObserver {
  late MapCubit mapCubit = context.read<MapCubit>();
  late PoiCubit poiCubit = context.read<PoiCubit>();
  late RouteCubit routeCubit = context.read<RouteCubit>();
  List<Poi> oldPoiList = []; // Compare against newPoiList to update markers

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    mapCubit.state.mapController.addObserver(this);
  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady) {
      updateMarkers(poiCubit.state);
    }
  }

  void updateMarkers(List<Poi> newPoiList) {
    for (var poi in oldPoiList) {
      if (!newPoiList.contains(poi)) {
        mapCubit.state.mapController.removeMarker(
          GeoPoint(latitude: poi.latitude, longitude: poi.longitude),
        );
      }
    }
    for (var poi in newPoiList) {
      if (!oldPoiList.contains(poi)) {
        mapCubit.state.mapController.addMarker(
          GeoPoint(latitude: poi.latitude, longitude: poi.longitude),
          markerIcon: markerIcons[poi.type] ?? markerIcons['default']!,
          iconAnchor: IconAnchor(
            anchor: Anchor.top,
          ),
        );
      }
    }
    oldPoiList = List.from(newPoiList);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocListener<PoiCubit, List<Poi>>(
      listener: (context, newPoiList) {
        updateMarkers(newPoiList);
      },
      child: OSMFlutter(
        controller: mapCubit.state.mapController,
        osmOption: mapCubit.state.osmOption,
        onGeoPointClicked: (geoPoint) {
          Poi poi = poiCubit.state.firstWhere((poi) =>
              poi.latitude == geoPoint.latitude &&
              poi.longitude == geoPoint.longitude);
          mapCubit.flyTo(poi.latitude - 0.0005, poi.longitude, 18.0);
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
      ),
    );
  }
}
