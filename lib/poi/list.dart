import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hw_map/cubit/map.dart';
import 'package:hw_map/cubit/poi.dart';
import 'package:hw_map/mock/poi.dart';
import 'package:hw_map/poi/create.dart';
import 'package:hw_map/poi/poi.dart';
import 'package:hw_map/poi/details.dart';
import 'package:hw_map/util/assets.dart';
import 'package:hw_map/util/message.dart';

class PoiList extends StatelessWidget {
  const PoiList({super.key});

  @override
  Widget build(BuildContext context) {
    MapCubit mapCubit = context.read<MapCubit>();
    PoiCubit poiCubit = context.read<PoiCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Points of Interest'),
      ),
      body: BlocBuilder<PoiCubit, List<Poi>>(
        builder: (context, poiList) {
          return ListView.builder(
            itemCount: poiList.length,
            itemBuilder: (context, index) {
              Poi poi = poiList[index];
              return PoiItem(
                poi: poi,
                onDetails: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PoiDetails(poi: poi),
                    ),
                  );
                },
                onDelete: () {
                  showSnackBar(context, "Deleted ${poi.name}");
                  poiCubit.deletePoi(poi);
                },
                onShow: () {
                  showSnackBar(context, "Showing ${poi.name}");
                  DefaultTabController.of(context).animateTo(0);
                  mapCubit.flyTo(
                    latitude: poi.latitude,
                    longitude: poi.longitude,
                    zoom: 18.0,
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: const OpenCreatePoiFormButton(),
    );
  }
}

class PoiItem extends StatelessWidget {
  final Poi poi;
  final VoidCallback onDetails;
  final VoidCallback onDelete;
  final VoidCallback onShow;

  const PoiItem(
      {super.key,
      required this.poi,
      required this.onDetails,
      required this.onDelete,
      required this.onShow});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onDetails,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top:
                  BorderSide(color: Theme.of(context).colorScheme.onBackground),
              left:
                  BorderSide(color: Theme.of(context).colorScheme.onBackground),
              right:
                  BorderSide(color: Theme.of(context).colorScheme.onBackground),
              bottom:
                  BorderSide(color: Theme.of(context).colorScheme.onBackground),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    getMarkerImage(poi.type),
                    const SizedBox(width: 16),
                    Text(
                      poi.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        poi.description,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DeleteButton(onPressed: onDelete),
                    const SizedBox(width: 8),
                    MapButton(onPressed: onShow),
                    const SizedBox(width: 8),
                    DetailsButton(onPressed: onDetails),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DeleteButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8),
        foregroundColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xFFEF4444),
      ),
      onPressed: onPressed,
      child: const Icon(Icons.delete_rounded),
    );
  }
}

class MapButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MapButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8),
        foregroundColor: Theme.of(context).colorScheme.onTertiary,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
      onPressed: onPressed,
      child: const Icon(Icons.map_rounded),
    );
  }
}

class DetailsButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DetailsButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      onPressed: onPressed,
      child: const Icon(Icons.info_outline_rounded),
    );
  }
}
