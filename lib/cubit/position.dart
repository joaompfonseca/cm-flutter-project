import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_x/util/location.dart';
import 'package:latlong2/latlong.dart';

class PositionCubit extends Cubit<LatLng?> {
  StreamSubscription<Position>? _userPositionStream;

  PositionCubit(location) : super(location) {
    trackUserPosition();
  }

  void trackUserPosition() {
    if (_userPositionStream != null) {
      _userPositionStream!.cancel();
    }
    userPositionAvailable().then(
      (position) {
        emit(LatLng(position.latitude, position.longitude));
        _userPositionStream = Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 0,
          ),
        ).listen((Position? position) {
          if (position != null) {
            emit(LatLng(position.latitude, position.longitude));
          }
        });
        _userPositionStream!.onError((error, stackTrace) {
          emit(null);
        });
      },
    ).onError((error, stackTrace) {
      emit(null);
    });
  }
}
