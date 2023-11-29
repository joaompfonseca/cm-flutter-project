import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_map/poi/poi.dart';

class PoiCubit extends Cubit<List<Poi>> {
  PoiCubit(poiList) : super(poiList);

  void createPoi(Poi poi) => emit([...state, poi]);

  void deletePoi(Poi poi) =>
      emit(state.where((element) => element.id != poi.id).toList());
}
