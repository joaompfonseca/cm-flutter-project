import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_x/route/route.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:project_x/util/converter.dart';

class Instruction {
  final String text;
  final String distance;
  final String time;

  Instruction({
    required this.text,
    required this.distance,
    required this.time,
  });
}

class GraphhopperState {
  final List<Point> points;
  final List<Instruction> instructions;
  final int instructionIndex;
  final String? distance;
  final String? time;

  GraphhopperState({
    required this.points,
    required this.instructions,
    required this.instructionIndex,
    required this.distance,
    required this.time,
  });
}

class GraphhopperCubit extends Cubit<GraphhopperState> {
  GraphhopperCubit(graphhopperState) : super(graphhopperState);

  final String gwDomain = dotenv.env['GW_DOMAIN']!;

  void fetchRoute(CustomRoute route) async {
    // Build URL
    String url = Uri.https(
      gwDomain,
      "router/route?points_encoded=false&profile=custom_bike",
    ).toString();
    for (var point in route.points) {
      url += "&point=${point.latitude},${point.longitude}";
    }

    // Fetch points, instructions, distance and time
    List<Point> points = [];
    List<Instruction> instructions = [];
    String distance;
    String time;

    var response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data['paths'].length == 0) {
        clearRoute();
      }
      // Points
      for (var point in data['paths'][0]['points']['coordinates']) {
        points.add(
          Point(
            latitude: point[1],
            longitude: point[0],
          ),
        );
      }
      // Instructions
      for (var instruction in data['paths'][0]['instructions']) {
        instructions.add(
          Instruction(
            text: instruction['text'],
            distance: getDistanceString(instruction['distance']),
            time: getTimeString(instruction['time']),
          ),
        );
      }
      // Distance
      distance = getDistanceString(data['paths'][0]['distance']);
      // Time
      time = getTimeString(data['paths'][0]['time']);
      emit(GraphhopperState(
        points: points,
        instructions: instructions,
        instructionIndex: 0,
        distance: distance,
        time: time,
      ));
    }
  }

  void nextInstruction() {
    if (state.instructionIndex < state.instructions.length - 1) {
      emit(
        GraphhopperState(
          points: state.points,
          instructions: state.instructions,
          instructionIndex: state.instructionIndex + 1,
          distance: state.distance,
          time: state.time,
        ),
      );
    }
  }

  void previousInstruction() {
    if (state.instructionIndex > 0) {
      emit(
        GraphhopperState(
          points: state.points,
          instructions: state.instructions,
          instructionIndex: state.instructionIndex - 1,
          distance: state.distance,
          time: state.time,
        ),
      );
    }
  }

  void clearRoute() {
    emit(
      GraphhopperState(
        points: [],
        instructions: [],
        instructionIndex: 0,
        distance: null,
        time: null,
      ),
    );
  }
}
