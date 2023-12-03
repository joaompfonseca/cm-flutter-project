import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hw_map/cubit/position.dart';
import 'package:latlong2/latlong.dart';

class MapState {
  final MapController mapController;
  final MapOptions mapOptions;
  final LatLng? userPosition;
  final bool isTrackingUserPosition;
  final PositionCubit positionCubit;

  MapState(
    this.mapController,
    this.mapOptions,
    this.userPosition,
    this.isTrackingUserPosition,
    this.positionCubit,
  );
}

class MapCubit extends Cubit<MapState> {
  MapCubit(mapState) : super(mapState) {
    mapState.positionCubit.stream.listen((position) {
      updateUserPosition(position);
      if (state.isTrackingUserPosition) {
        flyToUserPosition();
      }
    });
  }

  void setTrackingUserPosition(bool value) {
    emit(MapState(
      state.mapController,
      state.mapOptions,
      state.userPosition,
      value,
      state.positionCubit,
    ));
  }

  void updateUserPosition(LatLng? position) {
    emit(MapState(
      state.mapController,
      state.mapOptions,
      position,
      state.isTrackingUserPosition,
      state.positionCubit,
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

  void flyToUserPosition() {
    if (state.userPosition != null) {
      flyTo(
        latitude: state.userPosition!.latitude,
        longitude: state.userPosition!.longitude,
        zoom: 18.0,
      );
    }
  }
}
