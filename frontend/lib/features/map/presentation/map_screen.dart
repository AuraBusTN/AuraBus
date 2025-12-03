import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:aurabus/features/map/data/map_providers.dart';
import 'map_controller.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final LatLng _center = const LatLng(46.0678, 11.1303);

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final mapController = ref.read(mapControllerProvider);
    final markersAsync = ref.watch(markersProvider);

    final mapStyle = ref.read(mapStyleProvider).value;

    return markersAsync.when(
      data: (rawMarkers) {
        final markers = rawMarkers.map((marker) {
          return marker.copyWith(
            onTapParam: () {
              final stopId = int.parse(
                marker.markerId.value,
              ); // Safety: IDs are always generated from integers in the codebase
              final stopName = marker.infoWindow.title ?? "Unknown";
              mapController.openStopModal(context, stopId, stopName);
            },
          );
        }).toSet();

        return GoogleMap(
          key: const Key('google_map'),
          initialCameraPosition: CameraPosition(target: _center, zoom: 13),
          onMapCreated: mapController.onMapCreated,
          style: mapStyle,
          markers: markers,
          zoomControlsEnabled: true,
          mapType: MapType.normal,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
