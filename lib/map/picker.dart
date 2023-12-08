import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_x/cubit/map.dart';
import 'package:project_x/map/config.dart';
import 'package:project_x/util/assets.dart';
import 'package:project_x/util/cache.dart';

class PositionPicker extends StatelessWidget {
  const PositionPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final MapController mapController = MapController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pick a Location",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder<String>(
            future: getCachePath(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return FlutterMap(
                  mapController: mapController,
                  options: mapOptions,
                  children: [
                    TileLayer(
                      urlTemplate: tileLayerUrl,
                      tileProvider: CachedTileProvider(
                        maxStale: const Duration(days: 30),
                        store: HiveCacheStore(
                          snapshot.data,
                          hiveBoxName: 'MapTiles',
                        ),
                      ),
                    ),
                    /* User Marker */
                    BlocBuilder<MapCubit, MapState>(
                      builder: (context, mapState) => MarkerLayer(
                        alignment: Alignment.topCenter,
                        markers: [
                          if (mapState.userPosition != null)
                            Marker(
                              point: mapState.userPosition!,
                              child: getMarkerImage('user-location'),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          /* Marker in the middle of the screen */
          Center(
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: getMarkerImage('route-end'),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 64),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      LatLng position = mapController.camera.center;
                      Navigator.pop(context, position);
                    },
                    child: const Text('Pick'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
