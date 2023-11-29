import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapState {
  final MapController mapController;
  final OSMOption osmOption;

  MapState(this.mapController, this.osmOption);
}

class MapCubit extends Cubit<MapState> {
  MapCubit(mapState) : super(mapState);

  void flyTo(double latitude, double longitude, double zoomLevel) {
    state.mapController
        .goToLocation(GeoPoint(latitude: latitude, longitude: longitude))
        .then(
      (_) {
        Future.delayed(
          const Duration(seconds: 2),
          () => state.mapController.setZoom(zoomLevel: zoomLevel),
        );
      },
    );
  }
}
