import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:project_x/cubit/poi.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterPoi extends StatefulWidget {
  const FilterPoi({super.key});

  @override
  State<FilterPoi> createState() => _FilterPoiState();
}

class _FilterPoiState extends State<FilterPoi> {
  @override
  Widget build(BuildContext context) {
    PoiCubit poiCubit = BlocProvider.of<PoiCubit>(context);
    return Card(
      child: BlocBuilder<PoiCubit, PoiState>(
        builder: (context, state) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  controller: state.name,
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: state.bench,
                    onChanged: (bool? value) {
                      setState(() {
                        poiCubit.changeBench();
                      });
                    },
                  ),
                  const Text(
                    'Bench',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: state.bikeParking,
                    onChanged: (bool? value) {
                      setState(() {
                        poiCubit.changeBikeParking();
                      });
                    },
                  ),
                  const Text(
                    'Bicycle parking',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: state.bikeShop,
                    onChanged: (bool? value) {
                      setState(() {
                        poiCubit.changeBikeShop();
                      });
                    },
                  ),
                  const Text(
                    'Bicycle shop',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: state.drinkingWater,
                    onChanged: (bool? value) {
                      setState(() {
                        poiCubit.changeDrinkingWater();
                      });
                    },
                  ),
                  const Text(
                    'Drinking Water',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: state.toilets,
                    onChanged: (bool? value) {
                      setState(() {
                        poiCubit.changeToilets();
                      });
                    },
                  ),
                  const Text(
                    'Toilets',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 159),
                  ElevatedButton(
                    onPressed: () {
                      filterPoi();
                    },
                    child: const Text('Filter'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  filterPoi() {
    PoiCubit poiCubit = BlocProvider.of<PoiCubit>(context);
    poiCubit.filterPoi();
  }
}

class FilterPoiButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FilterPoiButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
        foregroundColor: Theme.of(context).colorScheme.onTertiary,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
      onPressed: onPressed,
      child: const Icon(Icons.filter_alt_outlined),
    );
  }
}
