import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hw_map/cubit/map.dart';
import 'package:hw_map/cubit/poi.dart';
import 'package:hw_map/map/config.dart';
import 'package:hw_map/poi/details.dart';
import 'package:hw_map/poi/poi.dart';
import 'package:hw_map/util/assets.dart';
import 'package:latlong2/latlong.dart';

class Map extends StatelessWidget {
  const Map({super.key});

  @override
  Widget build(BuildContext context) {
    late MapCubit mapCubit = context.read<MapCubit>();

    return FlutterMap(
      mapController: mapCubit.state.mapController,
      options: mapCubit.state.mapOptions,
      children: [
        TileLayer(
          urlTemplate: tileLayerUrl,
        ),
        BlocBuilder<MapCubit, MapState>(
          builder: (context, mapState) => MarkerLayer(
            alignment: Alignment.topCenter,
            markers: [
              if (mapState.userLocation != null)
                Marker(
                  point: mapState.userLocation!,
                  child: getMarkerImage('user-location'),
                ),
            ],
          ),
        ),
        BlocBuilder<PoiCubit, List<Poi>>(
          builder: (context, poiList) => MarkerLayer(
            alignment: Alignment.topCenter,
            markers: poiList
                .map((poi) => Marker(
                      point: LatLng(poi.latitude, poi.longitude),
                      width: 50.0,
                      height: 50.0,
                      child: GestureDetector(
                        child: getMarkerImage(poi.type),
                        onTap: () {
                          mapCubit.flyTo(
                            latitude: poi.latitude,
                            longitude: poi.longitude,
                            zoom: 18.0,
                            offset: const Offset(0, -100),
                          );
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: 400,
                                child: PoiDetails(
                                  poi: poi,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
