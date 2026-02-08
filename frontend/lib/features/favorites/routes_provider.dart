import 'package:aurabus/features/favorites/data/favorites_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aurabus/features/map/data/models/route_info.dart';

final routesProvider = FutureProvider<List<RouteInfo>>((ref) async {
  final repo = ref.watch(favoritesRepositoryProvider);
  final routes = await repo.fetchRoutes();
  routes.sort(compareRouteShortNames);
  return routes;
});
int compareRouteShortNames(RouteInfo a, RouteInfo b) {
  final intA = int.tryParse(a.routeShortName);
  final intB = int.tryParse(b.routeShortName);

  if (intA != null && intB != null) {
    return intA.compareTo(intB);
  } else if (intA != null) {
    return -1;
  } else if (intB != null) {
    return 1;
  } else {
    return a.routeShortName.compareTo(b.routeShortName);
  }
}
