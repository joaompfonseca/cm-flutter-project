import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hw_map/util/location.dart';
import 'package:latlong2/latlong.dart';

class MapState {
  final MapController mapController;
  final MapOptions mapOptions;
  final LatLng? userLocation;

  MapState(this.mapController, this.mapOptions, this.userLocation);
}

class MapCubit extends Cubit<MapState> {
  MapCubit(mapState) : super(mapState) {
    _trackUserPosition();
  }

  void _trackUserPosition() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      ),
    ).listen((Position? position) {
      if (position != null) {
        _updateUserPosition(position.latitude, position.longitude);
      }
    }).onError((error) {
      _clearUserPosition();
    });
  }

  void _updateUserPosition(double latitude, double longitude) {
    emit(MapState(
      state.mapController,
      state.mapOptions,
      LatLng(latitude, longitude),
    ));
  }

  void _clearUserPosition() {
    emit(MapState(
      state.mapController,
      state.mapOptions,
      null,
    ));
  }

  void flyTo({
    required double latitude,
    required double longitude,
    required double zoom,
    Offset offset = Offset.zero,
  }) {
    state.mapController.move(LatLng(latitude, longitude), zoom, offset: offset);
  }
}
