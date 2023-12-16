// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_x/cubit/map.dart';
import 'package:project_x/cubit/poi.dart';
import 'package:project_x/cubit/profile.dart';
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
        title: const Text(
          "Points of Interest",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<PoiCubit, PoiState>(
        builder: (context, poiState) {
          return ListView(
            children: [
              ...poiState.poiList.map(
                (poi) => PoiItem(
                  poi: poi,
                  onDetails: () {
                    getPoi(context, poi);
                  },
                  onDelete: () {
                    showSnackBar(context, "Deleted ${poi.name}");
                    poiCubit.deletePoi(poi);
                  },
                  onShow: () {
                    showSnackBar(context, "Showing ${poi.name}");
                    DefaultTabController.of(context).animateTo(1);
                    mapCubit.flyTo(
                      latitude: poi.latitude,
                      longitude: poi.longitude,
                      zoom: 18.0,
                    );
                  },
                ),
              ),
              const SizedBox(height: 48),
            ],
          );
        },
      ),
      floatingActionButton: const OpenCreatePoiFormButton(),
    );
  }
}

Future<void> getPoi(
  BuildContext context,
  Poi poi,
) async {
  PoiCubit poiCubit = context.read<PoiCubit>();

  PoiInd newpoi = await poiCubit.getPoi(poi.id);

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => PoiDetails(poi: newpoi),
    ),
  );
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
    ProfileCubit profileCubit = context.read<ProfileCubit>();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onDetails,
      child: Padding(
        padding: const EdgeInsets.all(4),
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
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: getMarkerImage(poi.type),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        poi.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
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
                const SizedBox(height: 4),
                if (profileCubit.state.profile.username == poi.addedBy)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DeleteButton(onPressed: onDelete),
                      const SizedBox(width: 8),
                      MapButton(onPressed: onShow),
                      const SizedBox(width: 8),
                      DetailsButton(onPressed: onDetails),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
