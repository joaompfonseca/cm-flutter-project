import 'dart:convert';
import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_x/cubit/token.dart';
import 'package:project_x/poi/poi.dart';

class PoiState {
  final List<Poi> poiList;
  final bool filtering;
  final List<Poi> totalPoiList;
  final bool bench;
  final bool bikeParking;
  final bool bikeShop;
  final bool drinkingWater;
  final bool toilets;
  final TextEditingController name;
  final LatLng northEast;
  final LatLng southWest;
  final TokenCubit tokenCubit;

  PoiState({
    required this.totalPoiList,
    required this.filtering,
    required this.poiList,
    required this.name,
    required this.tokenCubit,
    this.bench = true,
    this.bikeParking = true,
    this.bikeShop = true,
    this.drinkingWater = true,
    this.toilets = true,
    this.northEast = const LatLng(0, 0),
    this.southWest = const LatLng(0, 0),
  });
}

class PoiCubit extends Cubit<PoiState> {
  final String gwDomain = dotenv.env['GW_DOMAIN']!;

  PoiCubit(poiList) : super(poiList);

  Future<void> getPois() async {
    safePrint(state.northEast.toString());
    safePrint(state.southWest.toString());

    if (state.northEast.latitude == 0 && state.northEast.longitude == 0) {
      return;
    }

    final uri = Uri.https(gwDomain, 'api/poi/cluster', {
      'max_lat': state.northEast.latitude.toString(),
      'max_lng': state.northEast.longitude.toString(),
      'min_lat': state.southWest.latitude.toString(),
      'min_lng': state.southWest.longitude.toString(),
    });

    final response = await get(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${state.tokenCubit.state}',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final poiList = List<Poi>.from(
          data.map((model) => Poi.fromJson(model)).toList().cast<Poi>());

      //check if already on list
      var newPoiList = List<Poi>.from(state.totalPoiList);
      for (var poi in poiList) {
        if (!newPoiList.any((element) => element.id == poi.id)) {
          newPoiList.add(poi);
        }
      }

      emit(
        PoiState(
          totalPoiList: newPoiList,
          filtering: state.filtering,
          poiList: newPoiList,
          name: state.name,
          tokenCubit: state.tokenCubit,
          bench: state.bench,
          bikeParking: state.bikeParking,
          bikeShop: state.bikeShop,
          drinkingWater: state.drinkingWater,
          toilets: state.toilets,
          northEast: state.northEast,
          southWest: state.southWest,
        ),
      );

      filterPoi();
    } else {
      throw Exception('Failed to load pois');
    }
  }

  Future<PoiInd> getPoi(String id) async {
    final uri = Uri.https(gwDomain, 'api/poi/id/$id');

    final response = await get(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${state.tokenCubit.state}',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      safePrint(data);
      return PoiInd.fromJson(data);
    } else {
      throw Exception('Failed to load poi');
    }
  }

  Future<String> uploadImage(File image) async {
    final uri = Uri.https(gwDomain, 'api/s3/upload');

    //convert image to base64 string
    List<int> imageBytes = image.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    //get image type
    String temp = image.path.split('.').last;
    String imageType = "image/$temp";

    safePrint(base64Image);

    final response = await post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${state.tokenCubit.state}',
      },
      body: jsonEncode({
        'base64_image': base64Image,
        'image_type': imageType,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      safePrint(data);
      return data['image_url'];
    } else {
      throw Exception('Failed to upload image');
    }
  }

  Future<void> createPoi(String name, String description, String type,
      double latitude, double longitude, File image) async {
    final uri = Uri.https(gwDomain, 'api/poi/create');

    String imageUrl = await uploadImage(image);

    final response = await post(uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${state.tokenCubit.state}',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'type': type,
          'picture_url': imageUrl,
          'latitude': latitude,
          'longitude': longitude,
        }));

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      safePrint(data);
      // add poi to list
      final poi = Poi.fromJson(data);
      final newPoiList = List<Poi>.from(state.totalPoiList);
      newPoiList.add(poi);
      emit(
        PoiState(
          totalPoiList: newPoiList,
          filtering: state.filtering,
          poiList: state.poiList,
          name: state.name,
          tokenCubit: state.tokenCubit,
          bench: state.bench,
          bikeParking: state.bikeParking,
          bikeShop: state.bikeShop,
          drinkingWater: state.drinkingWater,
          toilets: state.toilets,
          northEast: state.northEast,
          southWest: state.southWest,
        ),
      );
      filterPoi();
    } else {
      throw Exception('Failed to create poi');
    }
  }

  void deletePoi(Poi poi) => emit(PoiState(
      totalPoiList:
          state.totalPoiList.where((element) => element.id != poi.id).toList(),
      filtering: state.filtering,
      poiList: state.totalPoiList,
      name: state.name,
      tokenCubit: state.tokenCubit,
      bench: state.bench,
      bikeParking: state.bikeParking,
      bikeShop: state.bikeShop,
      drinkingWater: state.drinkingWater,
      toilets: state.toilets,
      northEast: state.northEast,
      southWest: state.southWest));

  Future<String> ratePoi(String id, bool rating) async {
    final uri = Uri.https(gwDomain, 'api/poi/exists');

    final response = await put(uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${state.tokenCubit.state}',
        },
        body: jsonEncode({
          'id': id,
          'rating': rating,
        }));
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data['time'] == 0) {
        return '0';
      } else {
        return prettyDuration(Duration(milliseconds: data['time']));
      }
    } else {
      throw Exception('Failed to set rating');
    }
  }

  String prettyDuration(Duration duration) {
    var components = <String>[];

    var days = duration.inDays;
    if (days != 0) {
      components.add('${days}d');
    }
    var hours = duration.inHours % 24;
    if (hours != 0) {
      components.add('${hours}h');
    }
    var minutes = duration.inMinutes % 60;
    if (minutes != 0) {
      components.add('${minutes}m');
    }

    var seconds = duration.inSeconds % 60;
    var centiseconds = (duration.inMilliseconds % 1000) ~/ 10;
    if (components.isEmpty || seconds != 0 || centiseconds != 0) {
      components.add('$seconds');
      if (centiseconds != 0) {
        components.add('.');
        components.add(centiseconds.toString().padLeft(2, '0'));
      }
      components.add('s');
    }
    return components.join();
  }

  Future<void> statusPoi(String id, bool rating) async {
    final uri = Uri.https(gwDomain, 'api/poi/status');

    final response = await put(uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${state.tokenCubit.state}',
        },
        body: jsonEncode({
          'id': id,
          'status': rating,
        }));
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      safePrint(data);
    } else {
      throw Exception('Failed to set rating');
    }
  }

  void toggleFiltering() => emit(
        PoiState(
          totalPoiList: state.totalPoiList,
          filtering: !state.filtering,
          poiList: state.poiList,
          name: state.name,
          tokenCubit: state.tokenCubit,
          bench: state.bench,
          bikeParking: state.bikeParking,
          bikeShop: state.bikeShop,
          drinkingWater: state.drinkingWater,
          toilets: state.toilets,
        ),
      );

  void filterPoi() {
    List<Poi> filteredPoiList = [];

    List<String> types = [];
    if (state.bench) {
      types.add('bench');
    }
    if (state.bikeParking) {
      types.add('bicycle-parking');
    }
    if (state.bikeShop) {
      types.add('bicycle-shop');
    }
    if (state.drinkingWater) {
      types.add('drinking-water');
    }
    if (state.toilets) {
      types.add('toilets');
    }

    if (state.name.text == '') {
      filteredPoiList = state.totalPoiList
          .where((element) => types.contains(element.type))
          .toList();
    } else {
      filteredPoiList = state.totalPoiList
          .where((element) =>
              element.name
                  .toLowerCase()
                  .contains(state.name.text.toLowerCase()) &&
              types.contains(element.type))
          .toList();
    }
    emit(
      PoiState(
        totalPoiList: state.totalPoiList,
        filtering: state.filtering,
        poiList: filteredPoiList,
        name: state.name,
        tokenCubit: state.tokenCubit,
        bench: state.bench,
        bikeParking: state.bikeParking,
        bikeShop: state.bikeShop,
        drinkingWater: state.drinkingWater,
        toilets: state.toilets,
      ),
    );
  }

  void changeBench() => emit(
        PoiState(
          totalPoiList: state.totalPoiList,
          filtering: state.filtering,
          poiList: state.poiList,
          name: state.name,
          tokenCubit: state.tokenCubit,
          bench: !state.bench,
          bikeParking: state.bikeParking,
          bikeShop: state.bikeShop,
          drinkingWater: state.drinkingWater,
          toilets: state.toilets,
        ),
      );

  void changeBikeParking() => emit(
        PoiState(
          totalPoiList: state.totalPoiList,
          filtering: state.filtering,
          poiList: state.poiList,
          name: state.name,
          tokenCubit: state.tokenCubit,
          bikeParking: !state.bikeParking,
          bench: state.bench,
          bikeShop: state.bikeShop,
          drinkingWater: state.drinkingWater,
          toilets: state.toilets,
        ),
      );

  void changeBikeShop() => emit(
        PoiState(
          totalPoiList: state.totalPoiList,
          filtering: state.filtering,
          poiList: state.poiList,
          name: state.name,
          tokenCubit: state.tokenCubit,
          bikeShop: !state.bikeShop,
          bench: state.bench,
          bikeParking: state.bikeParking,
          drinkingWater: state.drinkingWater,
          toilets: state.toilets,
        ),
      );

  void changeDrinkingWater() => emit(
        PoiState(
          totalPoiList: state.totalPoiList,
          filtering: state.filtering,
          poiList: state.poiList,
          name: state.name,
          tokenCubit: state.tokenCubit,
          drinkingWater: !state.drinkingWater,
          bench: state.bench,
          bikeParking: state.bikeParking,
          bikeShop: state.bikeShop,
          toilets: state.toilets,
        ),
      );

  void changeToilets() => emit(
        PoiState(
          totalPoiList: state.totalPoiList,
          filtering: state.filtering,
          poiList: state.poiList,
          name: state.name,
          tokenCubit: state.tokenCubit,
          toilets: !state.toilets,
          bench: state.bench,
          bikeParking: state.bikeParking,
          bikeShop: state.bikeShop,
          drinkingWater: state.drinkingWater,
        ),
      );

  void setNorthEast(LatLng northEast) => emit(
        PoiState(
          totalPoiList: state.totalPoiList,
          filtering: state.filtering,
          poiList: state.poiList,
          name: state.name,
          tokenCubit: state.tokenCubit,
          northEast: northEast,
          southWest: state.southWest,
          bench: state.bench,
          bikeParking: state.bikeParking,
          bikeShop: state.bikeShop,
          drinkingWater: state.drinkingWater,
          toilets: state.toilets,
        ),
      );

  void setSouthWest(LatLng southWest) => emit(
        PoiState(
          totalPoiList: state.totalPoiList,
          filtering: state.filtering,
          poiList: state.poiList,
          name: state.name,
          tokenCubit: state.tokenCubit,
          northEast: state.northEast,
          southWest: southWest,
          bench: state.bench,
          bikeParking: state.bikeParking,
          bikeShop: state.bikeShop,
          drinkingWater: state.drinkingWater,
          toilets: state.toilets,
        ),
      );
}
