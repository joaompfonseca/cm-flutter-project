import 'dart:ui';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:project_x/cubit/poi.dart';
import 'package:project_x/cubit/position.dart';
import 'package:latlong2/latlong.dart';

class MapState {
  final MapController mapController;
  final MapOptions mapOptions;
  final LatLng? userPosition;
  final bool isTrackingUserPosition;
  final PositionCubit positionCubit;
  final PoiCubit poiCubit;

  MapState(
    this.mapController,
    this.mapOptions,
    this.userPosition,
    this.isTrackingUserPosition,
    this.positionCubit,
    this.poiCubit,
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

    state.mapController.mapEventStream.listen((event) {
      if (event is MapEventMoveEnd) {
        state.poiCubit.getPois();
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
      state.poiCubit,
    ));
  }

  void updateUserPosition(LatLng? position) {
    emit(MapState(
      state.mapController,
      state.mapOptions,
      position,
      state.isTrackingUserPosition,
      state.positionCubit,
      state.poiCubit,
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
