import 'package:flutter/material.dart';
import 'package:project_x/cubit/poi.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterPoi extends StatelessWidget {
  const FilterPoi({super.key});

  @override
  Widget build(BuildContext context) {
    PoiCubit poiCubit = BlocProvider.of<PoiCubit>(context);
    return BlocBuilder<PoiCubit, PoiState>(
      builder: (context, poiState) => Card(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  labelText: "Name",
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.normal,
                  ),
                  hintText: "Type name to filter",
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.normal,
                ),
                controller: poiState.name,
                onChanged: (String value) {
                  poiCubit.filterPoi();
                },
              ),
              // Filters
              Row(
                children: [
                  Checkbox(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    value: poiState.bench,
                    onChanged: (bool? value) {
                      poiCubit.changeBench();
                      poiCubit.filterPoi();
                    },
                  ),
                  const Text('Bench'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    value: poiState.bikeParking,
                    onChanged: (bool? value) {
                      poiCubit.changeBikeParking();
                      poiCubit.filterPoi();
                    },
                  ),
                  const Text('Bicycle Parking'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    value: poiState.bikeShop,
                    onChanged: (bool? value) {
                      poiCubit.changeBikeShop();
                      poiCubit.filterPoi();
                    },
                  ),
                  const Text('Bicycle Shop'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    value: poiState.drinkingWater,
                    onChanged: (bool? value) {
                      poiCubit.changeDrinkingWater();
                      poiCubit.filterPoi();
                    },
                  ),
                  const Text('Drinking Water'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    value: poiState.toilets,
                    onChanged: (bool? value) {
                      poiCubit.changeToilets();
                      poiCubit.filterPoi();
                    },
                  ),
                  const Text('Toilets'),
                ],
              ),
              // Bottom
              Row(
                children: [
                  const SizedBox(width: 4),
                  // Hide
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      minimumSize: const Size(48, 32),
                      maximumSize: const Size(48, 32),
                      padding: const EdgeInsets.all(0),
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: poiCubit.toggleFiltering,
                    child: const Text(
                      style: TextStyle(fontSize: 12),
                      "Hide",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        minimumSize: const Size(96, 48),
        maximumSize: const Size(96, 48),
        padding: const EdgeInsets.all(0),
      ),
      onPressed: onPressed,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            size: 16,
            Icons.filter_alt_outlined,
          ),
          Text(
            style: TextStyle(fontSize: 12),
            "Filter POIs",
          ),
        ],
      ),
    );
  }
}
