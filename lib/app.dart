import 'package:flutter/material.dart';
import 'package:project_x/poi/list.dart';
import 'package:project_x/route/list.dart';
import 'package:project_x/map/map.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            PoiList(),
            Map(),
            RouteList(),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(
              icon: Icon(
                size: 24,
                Icons.location_on_rounded,
              ),
              iconMargin: EdgeInsets.zero,
              text: "POIs",
            ),
            Tab(
              icon: Icon(
                size: 24,
                Icons.map_rounded,
              ),
              iconMargin: EdgeInsets.zero,
              text: "Map",
            ),
            Tab(
              icon: Icon(
                size: 24,
                Icons.route_rounded,
              ),
              iconMargin: EdgeInsets.zero,
              text: "Routes",
            ),
          ],
        ),
      ),
    );
  }
}
