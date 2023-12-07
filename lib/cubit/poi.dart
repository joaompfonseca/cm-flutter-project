import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  PoiState(this.totalPoiList, this.filtering, this.poiList, this.name,
      {this.bench = true,
      this.bikeParking = true,
      this.bikeShop = true,
      this.drinkingWater = true,
      this.toilets = true});
}

class PoiCubit extends Cubit<PoiState> {
  PoiCubit(poiList) : super(poiList);

  void createPoi(Poi poi) => emit(PoiState(
      List.from(state.totalPoiList)..add(poi),
      state.filtering,
      state.totalPoiList,
      state.name));

  void deletePoi(Poi poi) => emit(PoiState(
      state.totalPoiList.where((element) => element.id != poi.id).toList(),
      state.filtering,
      state.totalPoiList,
      state.name));

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

  void toggleFiltering() => emit(PoiState(
      state.totalPoiList, !state.filtering, state.poiList, state.name));

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
    emit(PoiState(
        state.totalPoiList, state.filtering, filteredPoiList, state.name,
        bench: state.bench,
        bikeParking: state.bikeParking,
        bikeShop: state.bikeShop,
        drinkingWater: state.drinkingWater,
        toilets: state.toilets));
  }

  void changeBench() => emit(PoiState(
      state.totalPoiList, state.filtering, state.poiList, state.name,
      bench: !state.bench,
      bikeParking: state.bikeParking,
      bikeShop: state.bikeShop,
      drinkingWater: state.drinkingWater,
      toilets: state.toilets));

  void changeBikeParking() => emit(PoiState(
      state.totalPoiList, state.filtering, state.poiList, state.name,
      bikeParking: !state.bikeParking,
      bench: state.bench,
      bikeShop: state.bikeShop,
      drinkingWater: state.drinkingWater,
      toilets: state.toilets));

  void changeBikeShop() => emit(PoiState(
      state.totalPoiList, state.filtering, state.poiList, state.name,
      bikeShop: !state.bikeShop,
      bench: state.bench,
      bikeParking: state.bikeParking,
      drinkingWater: state.drinkingWater,
      toilets: state.toilets));

  void changeDrinkingWater() => emit(PoiState(
      state.totalPoiList, state.filtering, state.poiList, state.name,
      drinkingWater: !state.drinkingWater,
      bench: state.bench,
      bikeParking: state.bikeParking,
      bikeShop: state.bikeShop,
      toilets: state.toilets));

  void changeToilets() => emit(PoiState(
      state.totalPoiList, state.filtering, state.poiList, state.name,
      toilets: !state.toilets,
      bench: state.bench,
      bikeParking: state.bikeParking,
      bikeShop: state.bikeShop,
      drinkingWater: state.drinkingWater));
}
