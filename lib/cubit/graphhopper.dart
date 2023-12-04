import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_x/route/route.dart';
import 'package:http/http.dart';
import 'dart:convert';

class GraphhopperCubit extends Cubit<List<Point>> {
  GraphhopperCubit(List<Point> points) : super(points);

  final String routerUrl = dotenv.env['ROUTER_URL']!;

  void fetchPoints(CustomRoute route) async {
    // Build URL
    String url = routerUrl;
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
}
