import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hw_map/poi.dart';
import 'package:hw_map/poi_details.dart';

class PoiList extends StatelessWidget {
  final List<Poi> poiList;
  final void Function(BuildContext context, Poi poi) addPoi;
  final void Function(BuildContext context, Poi poi) deletePoi;
  final void Function(BuildContext context, Poi poi) showPoi;

  const PoiList({
    super.key,
    required this.poiList,
    required this.addPoi,
    required this.deletePoi,
    required this.showPoi,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: poiList
            .map((poi) => PoiItem(
                  poi: poi,
                  onDelete: (BuildContext context) => deletePoi(context, poi),
                  onShow: (BuildContext context) => showPoi(context, poi),
                ))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          int n = poiList.length + 1;
          Poi poi = Poi(
            id: "poi$n",
            name: "poi$n name",
            type: "poi$n type",
            description: "poi$n description",
            latitude: 0.0, // choose current location when adding
            longitude: 0.0,
            pictureUrl:
                "https://www.jpn.up.pt/wp-content/uploads/2018/02/wc_p%C3%BAblica_3_06-de-fevereiro-de-2018.jpg",
            ratingPositive: 0,
            ratingNegative: 0,
            addedBy: "testUser",
          );
          addPoi(context, poi);
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
