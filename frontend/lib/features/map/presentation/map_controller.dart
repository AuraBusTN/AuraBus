import 'package:aurabus/features/map/data/map_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/models/route_info.dart';
import 'stop_details_modal.dart';

final mapControllerProvider = Provider<MapController>((ref) {
  return MapController(ref);
});

class MapController {
  final Ref ref;

  GoogleMapController? _gmaps;

  GoogleMapController? get controller => _gmaps;

  MapController(this.ref);

  void onMapCreated(GoogleMapController c) {
    _gmaps = c;
  }

  void dispose() {
    _gmaps?.dispose();
    _gmaps = null;
  }

  void openStopModal(
    BuildContext context,
    int stopId,
    String stopName,
    List<RouteInfo> stopRoutes,
  ) {
    final _ = ref.refresh(stopDetailsProvider(stopId));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StopDetailsModal(
        stopId: stopId,
        stopName: stopName,
        stopRoutes: stopRoutes,
      ),
    ).whenComplete(() {
      final notifier = ref.read(selectedLinesProvider.notifier);
      notifier.clear();
    });
  }

  /// Optional: camera animation
  Future<void> moveCamera(LatLng target, {double zoom = 16}) async {
    if (_gmaps == null) return;
    await _gmaps!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: zoom),
      ),
    );
  }
}
