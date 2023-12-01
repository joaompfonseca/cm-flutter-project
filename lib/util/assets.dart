import 'package:flutter/material.dart';

Image getMarkerImage(String type) {
  const markerPath = 'assets/markers';
  switch (type) {
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
    case 'user-location':
      return Image.asset('$markerPath/m_user_location.png');
    default:
      return Image.asset('$markerPath/m_default.png');
  }
}
