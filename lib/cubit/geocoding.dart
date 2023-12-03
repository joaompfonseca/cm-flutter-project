import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:latlong2/latlong.dart';

class GeocodingState {
  final String? location;
  final LatLng? coordinates;

  GeocodingState(
    this.location,
    this.coordinates,
  );
}

class GeocodingCubit extends Cubit<GeocodingState> {
  GeocodingCubit(geocodingState) : super(geocodingState);

  final coord = RegExp(r"(-?\d+\.?\d*),(-?\d+\.?\d*)");
  static String geocodingUrl =
      "https://geocode.search.hereapi.com/v1/geocode?in=countryCode:PRT&apiKey=${dotenv.env['PUBLIC_KEY_HERE']!}";
  final String revGeocodingUrl =
      "https://revgeocode.search.hereapi.com/v1/revgeocode?apiKey=${dotenv.env['PUBLIC_KEY_HERE']!}";

  Future<LatLng?> coordinatesFromLocation(String location) async {
    var response = await get(Uri.parse("$geocodingUrl&q=$location"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final coordinates = LatLng(
        data['items'][0]['position']['lat'],
        data['items'][0]['position']['lng'],
      );
      emit(GeocodingState(location, coordinates));
      return coordinates;
    } else {
      return null;
    }
  }

  Future<String?> locationFromCoordinates(LatLng coordinates) async {
    var response = await get(Uri.parse(
        "$revGeocodingUrl&at=${coordinates.latitude},${coordinates.longitude}"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final location = data['items'][0]['address']['label'];
      emit(GeocodingState(location, coordinates));
      return location;
    } else {
      return null;
    }
  }
}
