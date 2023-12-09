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
  final TokenCubit tokenCubin;

  PoiState(this.totalPoiList, this.filtering, this.poiList, this.name,
      this.tokenCubin,
      {this.bench = true,
      this.bikeParking = true,
      this.bikeShop = true,
      this.drinkingWater = true,
      this.toilets = true,
      this.northEast = const LatLng(0, 0),
      this.southWest = const LatLng(0, 0)});
}

class PoiCubit extends Cubit<PoiState> {
  PoiCubit(poiList) : super(poiList);

  final String apiUrl = dotenv.env['API_URL']!;

  Future<void> getPois() async {
    safePrint(state.northEast.toString());
    safePrint(state.southWest.toString());

    if (state.northEast.latitude == 0 && state.northEast.longitude == 0) {
      return;
    }

    final uri = Uri.https("gw.project-x.pt", 'api/poi/cluster', {
      'max_lat': state.northEast.latitude.toString(),
      'max_lng': state.northEast.longitude.toString(),
      'min_lat': state.southWest.latitude.toString(),
      'min_lng': state.southWest.longitude.toString(),
    });

    final response = await get(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${state.tokenCubin.state}',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final poiList = List<Poi>.from(
          data.map((model) => Poi.fromJson(model)).toList().cast<Poi>());

      //check if already on list
      var newPoiList = List<Poi>.from(state.totalPoiList);
      poiList.forEach((element) {
        if (!state.totalPoiList.contains(element)) {
          newPoiList.add(element);
        }
      });

      emit(PoiState(
          newPoiList, state.filtering, newPoiList, state.name, state.tokenCubin,
          bench: state.bench,
          bikeParking: state.bikeParking,
          bikeShop: state.bikeShop,
          drinkingWater: state.drinkingWater,
          toilets: state.toilets,
          northEast: state.northEast,
          southWest: state.southWest));

      filterPoi();
    } else {
      throw Exception('Failed to load pois');
    }
  }

  Future<PoiInd> getPoi(String id) async {
    final uri = Uri.https("gw.project-x.pt", 'api/poi/id/$id');

    final response = await get(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${state.tokenCubin.state}',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      safePrint(data);
      return PoiInd.fromJson(data);
    } else {
      throw Exception('Failed to load poi');
    }
  }

  void createPoi(Poi poi) => emit(PoiState(
      List.from(state.totalPoiList)..add(poi),
      state.filtering,
      state.totalPoiList,
      state.name,
      state.tokenCubin,
      bench: state.bench,
      bikeParking: state.bikeParking,
      bikeShop: state.bikeShop,
      drinkingWater: state.drinkingWater,
      toilets: state.toilets,
      northEast: state.northEast,
      southWest: state.southWest));

  void deletePoi(Poi poi) => emit(PoiState(
      state.totalPoiList.where((element) => element.id != poi.id).toList(),
      state.filtering,
      state.totalPoiList,
      state.name,
      state.tokenCubin,
      bench: state.bench,
      bikeParking: state.bikeParking,
      bikeShop: state.bikeShop,
      drinkingWater: state.drinkingWater,
      toilets: state.toilets,
      northEast: state.northEast,
      southWest: state.southWest));

  bool ratePoi(Poi poi, bool rating) {
    poi.ratingPositive += rating ? 1 : 0;
    poi.ratingNegative += rating ? 0 : 1;
    state.poiList[state.poiList.indexOf(poi)] = poi;
    emit(state);
    return true; // TODO: Check if user can rate
  }

  bool setStatus(Poi poi, bool status) {
    return true; // TODO: How to do this?
  }

  void toggleFiltering() => emit(PoiState(state.totalPoiList, !state.filtering,
      state.poiList, state.name, state.tokenCubin,
      bench: state.bench,
      bikeParking: state.bikeParking,
      bikeShop: state.bikeShop,
      drinkingWater: state.drinkingWater,
      toilets: state.toilets));

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
    emit(PoiState(state.totalPoiList, state.filtering, filteredPoiList,
        state.name, state.tokenCubin,
        bench: state.bench,
        bikeParking: state.bikeParking,
        bikeShop: state.bikeShop,
        drinkingWater: state.drinkingWater,
        toilets: state.toilets));
  }

  void changeBench() => emit(PoiState(state.totalPoiList, state.filtering,
      state.poiList, state.name, state.tokenCubin,
      bench: !state.bench,
      bikeParking: state.bikeParking,
      bikeShop: state.bikeShop,
      drinkingWater: state.drinkingWater,
      toilets: state.toilets));

  void changeBikeParking() => emit(PoiState(state.totalPoiList, state.filtering,
      state.poiList, state.name, state.tokenCubin,
      bikeParking: !state.bikeParking,
      bench: state.bench,
      bikeShop: state.bikeShop,
      drinkingWater: state.drinkingWater,
      toilets: state.toilets));

  void changeBikeShop() => emit(PoiState(state.totalPoiList, state.filtering,
      state.poiList, state.name, state.tokenCubin,
      bikeShop: !state.bikeShop,
      bench: state.bench,
      bikeParking: state.bikeParking,
      drinkingWater: state.drinkingWater,
      toilets: state.toilets));

  void changeDrinkingWater() => emit(PoiState(state.totalPoiList,
      state.filtering, state.poiList, state.name, state.tokenCubin,
      drinkingWater: !state.drinkingWater,
      bench: state.bench,
      bikeParking: state.bikeParking,
      bikeShop: state.bikeShop,
      toilets: state.toilets));

  void changeToilets() => emit(PoiState(state.totalPoiList, state.filtering,
      state.poiList, state.name, state.tokenCubin,
      toilets: !state.toilets,
      bench: state.bench,
      bikeParking: state.bikeParking,
      bikeShop: state.bikeShop,
      drinkingWater: state.drinkingWater));

  void setNorthEast(LatLng northEast) => emit(PoiState(state.totalPoiList,
      state.filtering, state.poiList, state.name, state.tokenCubin,
      northEast: northEast,
      southWest: state.southWest,
      bench: state.bench,
      bikeParking: state.bikeParking,
      bikeShop: state.bikeShop,
      drinkingWater: state.drinkingWater,
      toilets: state.toilets));

  void setSouthWest(LatLng southWest) => emit(PoiState(state.totalPoiList,
      state.filtering, state.poiList, state.name, state.tokenCubin,
      northEast: state.northEast,
      southWest: southWest,
      bench: state.bench,
      bikeParking: state.bikeParking,
      bikeShop: state.bikeShop,
      drinkingWater: state.drinkingWater,
      toilets: state.toilets));
}
