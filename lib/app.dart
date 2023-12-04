import 'package:flutter/material.dart';
import 'package:project_x/poi/list.dart';
import 'package:project_x/route/list.dart';
import 'package:project_x/map/map.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Map(),
            PoiList(),
            RouteList(),
          ],
        ),
        bottomNavigationBar: TabBar(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          tabs: [
            Tab(
              icon: Icon(
                Icons.map,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.location_on,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.directions_bike,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
