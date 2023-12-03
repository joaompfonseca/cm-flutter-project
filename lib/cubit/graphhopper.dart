import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hw_map/route/route.dart';
import 'package:http/http.dart';
import 'dart:convert';

class GraphhopperCubit extends Cubit<List<Point>> {
  GraphhopperCubit(List<Point> points) : super(points);

  final coord = RegExp(r"(-?\d+\.?\d*),(-?\d+\.?\d*)");
  static String URL_GEO =
      "https://geocode.search.hereapi.com/v1/geocode?apiKey=${dotenv.env['PUBLIC_KEY_HERE']!}&in=countryCode:PRT";
  static String URL_ROUTE = dotenv.env['ROUTER_URL']!;

  void fetchPoints(CustomRoute route) async {
    // Build URL
    String url = URL_ROUTE;
    for (var point in route.points) {
      url += "&point=${point.latitude},${point.longitude}";
    }
    // Fetch Points
    List<Point> points = [];
    var response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final route = data['paths'][0]['points']['coordinates'];
      for (var point in route) {
        points.add(Point(latitude: point[1], longitude: point[0]));
      }
      emit(points);
    }
  }

  void clearPoints() {
    emit([]);
  }

  Future<String> getCoordinates(String location) async {
    var response = await get(Uri.parse("$URL_GEO&q=$location"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final coordinates = data['items'][0]['position'];
      return "${coordinates['lat']},${coordinates['lng']}";
    } else {
      throw Exception("Failed to load coordinates");
    }
  }
}
