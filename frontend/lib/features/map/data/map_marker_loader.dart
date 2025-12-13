import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarkerLoader {
  static Future<BitmapDescriptor>? _loadFuture;

  static Future<BitmapDescriptor> loadStopIcon() {
    if (_loadFuture != null) return _loadFuture!;

    _loadFuture = BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(24, 24)),
      'assets/images/bus_stop_marker.png',
    );

    return _loadFuture!;
  }
}
