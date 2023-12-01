import 'package:flutter/material.dart';

Image getMarkerImage(String poiType) {
  const markerPath = 'assets/markers';
  switch (poiType) {
    case 'bench':
      return Image.asset('$markerPath/m_bench.png');
    case 'bicycle-parking':
      return Image.asset('$markerPath/m_bicycle_parking.png');
    case 'bicycle-shop':
      return Image.asset('$markerPath/m_bicycle_shop.png');
    case 'drinking-water':
      return Image.asset('$markerPath/m_drinking_water.png');
    case 'toilets':
      return Image.asset('$markerPath/m_toilets.png');
    default:
      return Image.asset('$markerPath/m_default.png');
  }
}
