import 'package:aurabus/features/map/data/models/route_info.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:aurabus/features/auth/presentation/providers/auth_provider.dart';

import 'map_repository.dart';
import 'map_marker_loader.dart';
import 'models/stop_info.dart';
import 'models/stop_trip_info.dart';

final mapRepositoryProvider = Provider((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return MapRepository(dioClient);
});

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

final stopsListProvider = FutureProvider<List<StopInfo>>((ref) async {
  final repo = ref.read(mapRepositoryProvider);
  return repo.loadLocalStops();
});

final markersProvider = FutureProvider<Set<Marker>>((ref) async {
  ref.keepAlive();
  final icon = await ref.read(stopIconProvider.future);
  final stops = await ref.watch(stopsListProvider.future);

  return stops.map((StopInfo stop) {
    return Marker(
      markerId: MarkerId(stop.stopId.toString()),
      position: LatLng(stop.stopLat, stop.stopLon),
      icon: icon,
      consumeTapEvents: true,
      infoWindow: InfoWindow(title: stop.stopName),
    );
  }).toSet();
});

final stopDetailsProvider = FutureProvider.family<List<StopTrip>, int>((
  ref,
  stopId,
) async {
  final repo = ref.read(mapRepositoryProvider);
  return repo.fetchStopTrips(stopId);
});

final stopsMapProvider = Provider<Map<int, StopInfo>>((ref) {
  final stopsAsync = ref.watch(stopsListProvider);
  return stopsAsync.maybeWhen(
    data: (stops) => {for (var s in stops) s.stopId: s},
    orElse: () => {},
  );
});

class SelectedLinesNotifier extends Notifier<Set<RouteInfo>> {
  @override
  Set<RouteInfo> build() => {};

  void toggle(RouteInfo route) {
    if (state.contains(route)) {
      state = {...state}..remove(route);
    } else {
      state = {...state, route};
    }
  }

  void clear() => state = {};
}

final selectedLinesProvider =
    NotifierProvider<SelectedLinesNotifier, Set<RouteInfo>>(() {
      return SelectedLinesNotifier();
    });

final sortedUniqueLinesProvider = Provider.family<List<RouteInfo>, int>((
  ref,
  stopId,
) {
  final stopsMap = ref.watch(stopsMapProvider);
  final stop = stopsMap[stopId];

  if (stop == null) return const [];

  final routes = List<RouteInfo>.from(stop.routes);

  routes.sort((a, b) {
    final regExp = RegExp(r'^(\d+)(.*)$');

    final matchA = regExp.firstMatch(a.routeShortName);
    final matchB = regExp.firstMatch(b.routeShortName);

    final numA = matchA != null ? int.parse(matchA.group(1)!) : null;
    final numB = matchB != null ? int.parse(matchB.group(1)!) : null;

    if (numA != null && numB != null) {
      final compareNums = numA.compareTo(numB);

      if (compareNums != 0) return compareNums;

      return a.routeShortName.compareTo(b.routeShortName);
    }

    if (numA != null) return -1;

    if (numB != null) return 1;

    return a.routeShortName.compareTo(b.routeShortName);
  });

  return routes;
});
