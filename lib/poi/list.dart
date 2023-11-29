import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hw_map/cubit/map.dart';
import 'package:hw_map/cubit/poi.dart';
import 'package:hw_map/mock/poi.dart';
import 'package:hw_map/poi/poi.dart';
import 'package:hw_map/poi/details.dart';
import 'package:hw_map/util/message.dart';

class PoiList extends StatelessWidget {
  const PoiList({super.key});

  @override
  Widget build(BuildContext context) {
    MapCubit mapCubit = context.read<MapCubit>();
    PoiCubit poiCubit = context.read<PoiCubit>();

    return Scaffold(
      body: BlocBuilder<PoiCubit, List<Poi>>(
        builder: (context, poiList) {
          return ListView.builder(
              itemCount: poiList.length,
              itemBuilder: (context, index) {
                Poi poi = poiList[index];
                return PoiItem(
                    poi: poi,
                    onDelete: (BuildContext context) {
                      showSnackBar(context, "Deleted ${poi.name}");
                      poiCubit.deletePoi(poi);
                    },
                    onShow: (BuildContext context) {
                      showSnackBar(context, "Showing ${poi.name}");
                      DefaultTabController.of(context).animateTo(0);
                      mapCubit.flyTo(poi.latitude, poi.longitude, 18.0);
                    });
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          int i = poiCubit.state.length + 1;
          Poi poi;
          mapCubit.state.mapController.myLocation().then(
                (userLocation) => {
                  poi = mockPoi(
                    i,
                    userLocation.latitude,
                    userLocation.longitude,
                  ),
                  showSnackBar(context, "Created ${poi.name}"),
                  poiCubit.createPoi(poi),
                },
                onError: (e) => showSnackBar(context, "Error creating POI"),
              );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PoiItem extends StatelessWidget {
  final Poi poi;
  final void Function(BuildContext context) onDelete;
  final void Function(BuildContext context) onShow;

  const PoiItem(
      {super.key,
      required this.poi,
      required this.onDelete,
      required this.onShow});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: onDelete,
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          )
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 2,
            onPressed: onShow,
            backgroundColor: const Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.map,
            label: 'Show on Map',
          ),
        ],
      ),
      child: ListTile(
          title: Text(poi.name),
          subtitle: Text(poi.description),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PoiDetails(
                poi: poi,
              ),
            ));
          }),
    );
  }
}
