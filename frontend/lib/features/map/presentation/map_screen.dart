import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:aurabus/core/utils/browser_detect.dart';
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
            infoWindowParam: const InfoWindow(title: null, snippet: null),
            consumeTapEventsParam: true,
            onTapParam: () {
              final stopId = int.parse(marker.markerId.value);
              final stopInfo = stopsMap[stopId];
              if (stopInfo != null) {
                mapController.openStopModal(context, stopInfo);
              }
            },
          );
        }).toSet();

        // On Safari/Firefox with canvasKitMaximumSurfaces:1, Flutter can't
        // render widgets as overlays on top of platform views (Google Maps).
        // Place the search bar ABOVE the map in a Column instead of a Stack.
        final bool useOverlay = !kIsWeb || isChromiumBrowser;

        if (!useOverlay) {
          return Column(
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: MapSearchBar(),
                ),
              ),
              Expanded(
                child: ValueListenableBuilder<bool>(
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
              ),
            ],
          );
        }

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
