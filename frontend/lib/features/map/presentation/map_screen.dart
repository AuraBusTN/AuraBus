import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:aurabus/features/map/data/map_providers.dart';
import 'package:aurabus/features/map/widgets/map_search_bar.dart';
import 'map_controller.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  @override
  bool get wantKeepAlive => true;

  final LatLng _center = const LatLng(46.0678, 11.1303);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(mapControllerProvider).onAppResumed();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final mapController = ref.read(mapControllerProvider);
    final markersAsync = ref.watch(markersProvider);
    final stopsMap = ref.watch(stopsMapProvider);
    final mapStyle = ref.read(mapStyleProvider).value;

    return markersAsync.when(
      data: (rawMarkers) {
        final markers = rawMarkers.map((marker) {
          return marker.copyWith(
            onTapParam: () {
              final stopId = int.parse(marker.markerId.value);
              final stopInfo = stopsMap[stopId];
              if (stopInfo != null) {
                mapController.openStopModal(context, stopInfo);
              }
            },
          );
        }).toSet();

        return Stack(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: mapController.showLocation,
              builder: (context, showBlueDot, child) {
                return GoogleMap(
                  key: const Key('google_map'),
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 13,
                  ),
                  onMapCreated: mapController.onMapCreated,
                  style: mapStyle,
                  markers: markers,
                  zoomControlsEnabled: true,
                  mapType: MapType.normal,
                  myLocationEnabled: showBlueDot,
                  myLocationButtonEnabled: showBlueDot,
                );
              },
            ),
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: MapSearchBar(),
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
