import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_map/poi/poi.dart';

class PoiCubit extends Cubit<List<Poi>> {
  PoiCubit(poiList) : super(poiList);

  void createPoi(Poi poi) => emit([...state, poi]);

  void deletePoi(Poi poi) =>
      emit(state.where((element) => element.id != poi.id).toList());

  bool ratePoi(Poi poi, bool rating) {
    poi.ratingPositive += rating ? 1 : 0;
    poi.ratingNegative += rating ? 0 : 1;
    state[state.indexOf(poi)] = poi;
    emit(state);
    return true; // TODO: Check if user can rate
  }

  bool setStatus(Poi poi, bool status) {
    return true; // TODO: How to do this?
  }
}
