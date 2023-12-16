String getDistanceString(double distanceInMeters) {
  String distance = "";
  if (distanceInMeters > 1000) {
    distance += " ${(distanceInMeters / 1000).toStringAsFixed(2)} km";
  } else {
    distance += " ${distanceInMeters.toStringAsFixed(0)} m";
  }
  distance.trim();
  return distance;
}

String getTimeString(int timeInMilliseconds) {
  final totalSeconds = timeInMilliseconds ~/ 1000;
  final hours = totalSeconds ~/ 3600;
  final minutes = (totalSeconds % 3600) ~/ 60;
  final seconds = totalSeconds % 60;
  String time = "";
  if (hours > 0) {
    time += " $hours h";
  }
  if (minutes > 0) {
    time += " $minutes min";
  }
  time += " $seconds s";
  time.trim();
  return time;
}
