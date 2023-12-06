import 'package:path_provider/path_provider.dart';

Future<String> getCachePath() async {
  final cacheDirectory = await getTemporaryDirectory();
  return cacheDirectory.path;
}
