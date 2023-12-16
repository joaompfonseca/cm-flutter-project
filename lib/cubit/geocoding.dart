import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:latlong2/latlong.dart';

class GeocodingState {
  final String? location;
  final LatLng? coordinates;

  GeocodingState({
    required this.location,
    required this.coordinates,
  });
}

class GeocodingCubit extends Cubit<GeocodingState> {
  GeocodingCubit(geocodingState) : super(geocodingState);

  static String geocodingUrl =
      "https://geocode.search.hereapi.com/v1/geocode?in=countryCode:PRT&apiKey=${dotenv.env['PUBLIC_KEY_HERE']!}";
  final String revGeocodingUrl =
      "https://revgeocode.search.hereapi.com/v1/revgeocode?apiKey=${dotenv.env['PUBLIC_KEY_HERE']!}";

  Future<GeocodingState?> coordinatesFromLocation(String location) async {
    var response = await get(Uri.parse("$geocodingUrl&q=$location"));
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      location = data['items'][0]['address']['label'];
      final coordinates = LatLng(
        data['items'][0]['position']['lat'],
        data['items'][0]['position']['lng'],
      );
      final newState = GeocodingState(
        location: location,
        coordinates: coordinates,
      );
      emit(newState);
      return newState;
    } else {
      return null;
    }
  }

  Future<GeocodingState?> locationFromCoordinates(LatLng coordinates) async {
    var response = await get(Uri.parse(
        "$revGeocodingUrl&at=${coordinates.latitude},${coordinates.longitude}"));
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final location = data['items'][0]['address']['label'];
      final newState = GeocodingState(
        location: location,
        coordinates: coordinates,
      );
      emit(newState);
      return newState;
    } else {
      return null;
    }
  }
}
