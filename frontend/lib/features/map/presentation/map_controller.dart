import 'package:aurabus/features/map/data/map_providers.dart';
import 'package:aurabus/features/map/data/models/stop_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  void openStopModal(BuildContext context, StopInfo stopInfo) {
    final _ = ref.refresh(stopDetailsProvider(stopInfo.stopId));

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (_) => StopDetailsModal(stopInfo: stopInfo),
    ).whenComplete(() {
      final notifier = ref.read(selectedLinesProvider.notifier);
      notifier.clear();
    });
  }
}
