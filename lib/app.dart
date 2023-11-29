import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:hw_map/poi.dart';
import 'package:hw_map/poi_list.dart';
import 'package:hw_map/route.dart';
import 'package:hw_map/route_list.dart';
import 'package:hw_map/map.dart';

class App extends StatefulWidget {
  final List<Poi> poiList;
  final List<CreatedRoute> routeList;

  const App({
    super.key,
    required this.poiList,
    required this.routeList,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late List<Poi> poiList;
  late List<CreatedRoute> routeList;
  late MapController mapController;
  late OSMOption osmOption;

  @override
  void initState() {
    super.initState();
    poiList = widget.poiList;
    routeList = widget.routeList;
    mapController = MapController.cyclOSMLayer(
      initMapWithUserPosition: const UserTrackingOption(
        enableTracking: true,
        unFollowUser: true,
      ),
    );
    osmOption = OSMOption(
      zoomOption: const ZoomOption(
        initZoom: 15,
        minZoomLevel: 3,
        maxZoomLevel: 19,
        stepZoom: 1.0,
      ),
      enableRotationByGesture: false,
      userLocationMarker: UserLocationMaker(
        personMarker: const MarkerIcon(
          icon: Icon(
            Icons.location_history_rounded,
            color: Colors.red,
            size: 100,
          ),
        ),
        directionArrowMarker: const MarkerIcon(
          icon: Icon(
            Icons.double_arrow,
            size: 50,
          ),
        ),
      ),
      roadConfiguration: const RoadOption(
        roadColor: Colors.yellowAccent,
      ),
      markerOption: MarkerOption(
          defaultMarker: const MarkerIcon(
        icon: Icon(
          Icons.person_pin_circle,
          color: Colors.blue,
          size: 50,
        ),
      )),
    );
  }

  void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), duration: const Duration(seconds: 3)),
    );
  }

  /* POI */

  void addPoi(BuildContext context, Poi poi) {
    mapController.myLocation().then(
          (userLocation) => {
            poi.latitude = userLocation.latitude,
            poi.longitude = userLocation.longitude,
            showSnackBar(context, "Added ${poi.name}"),
            setState(() {
              poiList.add(poi);
            }),
          },
          onError: (e) => showSnackBar(context, "Error adding ${poi.name}"),
        );
  }

  void deletePoi(BuildContext context, Poi poi) {
    showSnackBar(context, "Deleted ${poi.name}");
    setState(() {
      poiList.remove(poi);
    });
  }

  void showPoi(BuildContext context, Poi poi) {
    showSnackBar(context, "Showing ${poi.name}");
    DefaultTabController.of(context).animateTo(0);
    mapController.goToLocation(
      GeoPoint(latitude: poi.latitude, longitude: poi.longitude),
    );
  }

  /* Route */

  void addRoute(BuildContext context, CreatedRoute route) {
    showSnackBar(context, "Added ${route.name}");
    setState(() {
      routeList.add(route);
    });
  }

  void deleteRoute(BuildContext context, CreatedRoute route) {
    showSnackBar(context, "Deleted ${route.name}");
    setState(() {
      routeList.remove(route);
    });
  }

  void showRoute(BuildContext context, CreatedRoute route) {
    showSnackBar(context, "Showing ${route.name}");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.map)),
              Tab(icon: Icon(Icons.location_on)),
              Tab(icon: Icon(Icons.directions_bike)),
            ],
          ),
          title: const Text('Project X'),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Map(
              mapController: mapController,
              osmOption: osmOption,
              poiList: poiList,
              deletePoi: deletePoi,
              showPoi: showPoi,
            ),
            PoiList(
              poiList: poiList,
              addPoi: addPoi,
              deletePoi: deletePoi,
              showPoi: showPoi,
            ),
            RouteList(
              routeList: routeList,
              addRoute: addRoute,
              deleteRoute: deleteRoute,
              showRoute: showRoute,
            )
          ],
        ),
      ),
    );
  }
}
