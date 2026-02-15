import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import 'package:aurabus/core/utils/browser_detect.dart';
import 'package:aurabus/features/auth/presentation/providers/favorite_route_provider.dart';
import 'package:aurabus/features/map/data/map_providers.dart';
import 'package:aurabus/features/map/data/models/stop_info.dart';
import 'stop_details_modal.dart';

final mapControllerProvider = Provider<MapController>((ref) {
  final controller = MapController(ref);
  ref.onDispose(controller.dispose);
  return controller;
});

class MapController {
  final Ref ref;

  GoogleMapController? _gmaps;
  GoogleMapController? get controller => _gmaps;

  final ValueNotifier<bool> showLocation = ValueNotifier(false);

  StreamSubscription<ServiceStatus>? _serviceStatusSubscription;

  MapController(this.ref);

  void onMapCreated(GoogleMapController c) {
    _gmaps = c;
    _initLocationLogic().catchError((_) {});
  }

  Future<void> _initLocationLogic() async {
    // Geolocator.getServiceStatusStream() uses navigator.permissions API
    // which is not supported on Safari and partially on Firefox.
    // Skip it on web and wrap in try-catch for safety.
    if (!kIsWeb) {
      try {
        _serviceStatusSubscription = Geolocator.getServiceStatusStream().listen(
          (status) {
            if (status == ServiceStatus.enabled) {
              _enableLocationFeature();
            } else {
              showLocation.value = false;
            }
          },
          onError: (_) {},
        );
      } catch (_) {
        // Silently ignore — stream not supported on this platform.
      }
    }

    try {
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (isServiceEnabled) {
        _enableLocationFeature();
      }
    } catch (_) {
      // Location service check failed — ignore.
    }
  }

  Future<void> _enableLocationFeature() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      showLocation.value = true;

      final position = await Geolocator.getCurrentPosition();
      _gmaps?.animateCamera(
        CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
      );
    } catch (e) {
      showLocation.value = false;
    }
  }

  void onAppResumed() async {
    try {
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (isServiceEnabled) {
        _enableLocationFeature();
      } else {
        showLocation.value = false;
      }
    } catch (_) {
      showLocation.value = false;
    }
  }

  void dispose() {
    _gmaps?.dispose();
    _gmaps = null;
    _serviceStatusSubscription?.cancel();
    showLocation.dispose();
  }

  void openStopModal(BuildContext context, StopInfo stopInfo) {
    final _ = ref.refresh(stopDetailsProvider(stopInfo.stopId));

    final notifier = ref.read(selectedLinesProvider.notifier);
    notifier.clear();

    final favoriteIds = ref.read(favoriteRoutesProvider).value ?? {};

    final favoriteRoutesAtThisStop = stopInfo.routes
        .where((route) => favoriteIds.contains(route.routeId))
        .toSet();

    if (favoriteRoutesAtThisStop.isNotEmpty) {
      notifier.setRoutes(favoriteRoutesAtThisStop);
    }

    if (!context.mounted) return;

    if (kIsWeb) {
      if (isChromiumBrowser) {
        // Chrome has plenty of WebGL contexts — overlay dialogs work fine.
        showGeneralDialog<void>(
          context: context,
          useRootNavigator: true,
          barrierDismissible: true,
          barrierLabel: MaterialLocalizations.of(
            context,
          ).modalBarrierDismissLabel,
          barrierColor: Colors.black54,
          transitionDuration: const Duration(milliseconds: 200),
          transitionBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          pageBuilder: (context, animation, secondaryAnimation) {
            return PointerInterceptor(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(context).maybePop(),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: PointerInterceptor(
                      child: Material(
                        type: MaterialType.transparency,
                        child: StopDetailsModal(stopInfo: stopInfo),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ).whenComplete(() {
          final notifier = ref.read(selectedLinesProvider.notifier);
          notifier.clear();
        });
      } else {
        // Safari/Firefox: use an opaque page route to avoid needing
        // extra WebGL overlay surfaces that would crash the browser.
        Navigator.of(context, rootNavigator: true)
            .push(
              MaterialPageRoute(
                builder: (_) => Scaffold(
                  appBar: AppBar(
                    title: Text(stopInfo.stopName),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                    ),
                  ),
                  body: StopDetailsModal(stopInfo: stopInfo),
                ),
              ),
            )
            .whenComplete(() {
              final notifier = ref.read(selectedLinesProvider.notifier);
              notifier.clear();
            });
      }
      return;
    }

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
