import 'package:flutter/material.dart';
import 'package:hw_map/poi/list.dart';
import 'package:hw_map/route/list.dart';
import 'package:hw_map/map/map.dart';

class App extends StatelessWidget {
  const App({super.key});

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
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Map(),
            PoiList(),
            RouteList(),
          ],
        ),
      ),
    );
  }
}
