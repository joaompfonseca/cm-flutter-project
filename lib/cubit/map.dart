import 'dart:ui';
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

  MapState({
    required this.mapController,
    required this.mapOptions,
    required this.userPosition,
    required this.isTrackingUserPosition,
    required this.positionCubit,
    required this.poiCubit,
  });
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
      mapController: state.mapController,
      mapOptions: state.mapOptions,
      userPosition: state.userPosition,
      isTrackingUserPosition: value,
      positionCubit: state.positionCubit,
      poiCubit: state.poiCubit,
    ));
  }

  void updateUserPosition(LatLng? position) {
    emit(MapState(
      mapController: state.mapController,
      mapOptions: state.mapOptions,
      userPosition: position,
      isTrackingUserPosition: state.isTrackingUserPosition,
      positionCubit: state.positionCubit,
      poiCubit: state.poiCubit,
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
