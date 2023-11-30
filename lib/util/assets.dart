import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

const markerPath = 'assets/markers';
Map<String, MarkerIcon> markerIcons = {
  'bench': MarkerIcon(
    assetMarker: AssetMarker(
      image: const AssetImage('$markerPath/m_bench.png'),
    ),
  ),
  'bicycle-parking': MarkerIcon(
    assetMarker: AssetMarker(
      image: const AssetImage('$markerPath/m_bicycle_parking.png'),
    ),
  ),
  'bicycle-shop': MarkerIcon(
    assetMarker: AssetMarker(
      image: const AssetImage('$markerPath/m_bicycle_shop.png'),
    ),
  ),
  'drinking-water': MarkerIcon(
    assetMarker: AssetMarker(
      image: const AssetImage('$markerPath/m_drinking_water.png'),
    ),
  ),
  'toilets': MarkerIcon(
    assetMarker: AssetMarker(
      image: const AssetImage('$markerPath/m_toilets.png'),
    ),
  ),
  'default': MarkerIcon(
    assetMarker: AssetMarker(
      image: const AssetImage('$markerPath/m_default.png'),
    ),
  ),
};
