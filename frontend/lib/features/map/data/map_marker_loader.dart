import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarkerLoader {
  static Future<BitmapDescriptor> loadStopIcon() async {
    return BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(24, 24)),
      'assets/images/bus_stop_marker.png',
    );
  }
}
