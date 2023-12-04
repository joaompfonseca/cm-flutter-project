import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_x/cubit/map.dart';
import 'package:project_x/cubit/poi.dart';
import 'package:project_x/poi/create.dart';
import 'package:project_x/poi/poi.dart';
import 'package:project_x/poi/details.dart';
import 'package:project_x/util/assets.dart';
import 'package:project_x/util/button.dart';
import 'package:project_x/util/message.dart';

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
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: getMarkerImage(poi.type),
                    ),
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
