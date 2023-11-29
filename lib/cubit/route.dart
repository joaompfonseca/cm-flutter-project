import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_map/route/route.dart';

class RouteCubit extends Cubit<List<CreatedRoute>> {
  RouteCubit(routeList) : super(routeList);

  void createRoute(CreatedRoute route) => emit([...state, route]);

  void deleteRoute(CreatedRoute route) =>
      emit(state.where((element) => element.id != route.id).toList());
}
