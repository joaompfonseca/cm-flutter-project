import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_x/route/route.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:project_x/util/converter.dart';

class Instruction {
  final String text;
  final double distance;
  final int time;

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
  final double distance;
  final int time;

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
            distance: instruction['distance'],
            time: instruction['time'],
          ),
        );
      }
      // Distance
      double distance = data['paths'][0]['distance'];
      // Time
      int time = data['paths'][0]['time'];
      emit(GraphhopperState(
        points: points,
        instructions: instructions,
        instructionIndex: 0,
        distance: distance,
        time: time,
      ));
    }
  }

  int getRemainingTime(int index) {
    int remainingTime = 0;
    for (int i = index; i < state.instructions.length; i++) {
      remainingTime += state.instructions[i].time;
    }
    return remainingTime;
  }

  double getRemainingDistance(int index) {
    double remainingDistance = 0.0;
    for (int i = index; i < state.instructions.length; i++) {
      remainingDistance += state.instructions[i].distance;
    }
    return remainingDistance;
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
        distance: 0.0,
        time: 0,
      ),
    );
  }
}
