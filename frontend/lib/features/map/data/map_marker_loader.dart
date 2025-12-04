import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarkerLoader {
  static BitmapDescriptor? _cachedStopIcon;

  static Future<BitmapDescriptor> loadStopIcon() async {
    if (_cachedStopIcon != null) return _cachedStopIcon!;
    _cachedStopIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(24, 24)),
      'assets/images/bus_stop_marker.png',
    );
    return _cachedStopIcon!;
  }
}
