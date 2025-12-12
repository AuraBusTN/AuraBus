import 'package:aurabus/common/models/stop_data.dart';
import 'package:aurabus/common/models/stop_details.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map_repository.dart';
import 'map_marker_loader.dart';


final mapRepositoryProvider = Provider((ref) => MapRepository());

final mapStyleProvider = FutureProvider<String?>((ref) async {
  ref.keepAlive();
  try {
    return await rootBundle.loadString('assets/data/map_style.json');
  } catch (_) {
    return null;
  }
});

final stopIconProvider = FutureProvider<BitmapDescriptor>((ref) async {
  ref.keepAlive();
  return MapMarkerLoader.loadStopIcon();
});

final markersProvider = FutureProvider<Set<Marker>>((ref) async {
  ref.keepAlive();

  final repo = ref.read(mapRepositoryProvider);
  final icon = await ref.read(stopIconProvider.future);
  final stops = await repo.loadLocalStops();

  return stops.map((StopData stop) {
    return Marker(
      markerId: MarkerId(stop.stopId.toString()),
      position: LatLng(stop.stopLat, stop.stopLon),
      icon: icon,
      consumeTapEvents: true,
      infoWindow: InfoWindow(title: stop.stopName),
    );
  }).toSet();
});

final stopDetailsProvider = FutureProvider.family<List<StopArrival>, int>((
  ref,
  stopId,
) async {
  final repo = ref.read(mapRepositoryProvider);
  return repo.fetchStopDetails(stopId);
});

class SelectedLinesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggle(String routeShortName) {
    if (state.contains(routeShortName)) {
      state = {...state}..remove(routeShortName);
    } else {
      state = {...state, routeShortName};
    }
  }

  void clear() => state = {};
}

final selectedLinesProvider =
    NotifierProvider<SelectedLinesNotifier, Set<String>>(() {
      return SelectedLinesNotifier();
    });