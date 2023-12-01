import 'dart:async';
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
  StreamSubscription<Position>? _userPositionStream;

  MapCubit(mapState) : super(mapState) {
    trackUserPosition();
  }

  void trackUserPosition({bool flyTo = false}) {
    if (_userPositionStream != null) {
      _userPositionStream!.cancel();
    }
    userPositionAvailable().then(
      (position) {
        _updateUserPosition(position.latitude, position.longitude);
        if (flyTo) {
          flyToUserLocation();
        }
        _userPositionStream = Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 0,
          ),
        ).listen((Position? position) {
          if (position != null) {
            _updateUserPosition(position.latitude, position.longitude);
          }
        });
        _userPositionStream!.onError((error, stackTrace) {
          _clearUserPosition();
        });
      },
    ).onError((error, stackTrace) {
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

  void zoomIn() {
    state.mapController.move(
      state.mapController.camera.center,
      state.mapController.camera.zoom + 1,
    );
  }

  void zoomOut() {
    state.mapController.move(
      state.mapController.camera.center,
      state.mapController.camera.zoom - 1,
    );
  }

  void flyTo({
    required double latitude,
    required double longitude,
    required double zoom,
    Offset offset = Offset.zero,
  }) {
    state.mapController.move(LatLng(latitude, longitude), zoom, offset: offset);
  }

  void flyToUserLocation() {
    if (state.userLocation != null) {
      flyTo(
        latitude: state.userLocation!.latitude,
        longitude: state.userLocation!.longitude,
        zoom: 18.0,
      );
    }
  }
}
