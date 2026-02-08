import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

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
    _initLocationLogic();
  }

  Future<void> _initLocationLogic() async {
    _serviceStatusSubscription = Geolocator.getServiceStatusStream().listen((
      status,
    ) {
      if (status == ServiceStatus.enabled) {
        _enableLocationFeature();
      } else {
        showLocation.value = false;
      }
    });

    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (isServiceEnabled) {
      _enableLocationFeature();
    }
  }

  Future<void> _enableLocationFeature() async {
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

    try {
      final position = await Geolocator.getCurrentPosition();
      _gmaps?.animateCamera(
        CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
      );
    } catch (e) {
      showLocation.value = false;
    }
  }

  void onAppResumed() async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (isServiceEnabled) {
      _enableLocationFeature();
    } else {
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

    if (!context.mounted) return;

    if (kIsWeb) {
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
                    child: StopDetailsModal(stopInfo: stopInfo),
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
