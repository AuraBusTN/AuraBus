import 'package:aurabus/common/widgets/bus_rectangle.dart';
import 'package:aurabus/features/account/widgets/bus_rectangle_toggle.dart';
import 'package:flutter/material.dart';
import 'package:aurabus/common/models/stop_data.dart';
import 'package:aurabus/features/account/favorites/models/favorites_repository.dart';
import 'package:aurabus/l10n/app_localizations.dart';


class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<List<BusRoute>>> _allRoutesFuture;

  @override
  void initState() {
    super.initState();
    _allRoutesFuture = Future.wait([getRoutes(23), getRoutes(24)]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<List<List<BusRoute>>>(
      future: _allRoutesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text(l10n.errorMessage(snapshot.error.toString())));
        }

        final allRoutes = snapshot.data;
        if (allRoutes == null || allRoutes.isEmpty) {
          return Center(child: Text(l10n.errorMessage(snapshot.error.toString())));
        }

        final routesTrento = allRoutes[0];
        final routesRovereto = allRoutes[1];
        routesTrento.sort(compareRouteShortNames);
        routesRovereto.sort(compareRouteShortNames);        

return SingleChildScrollView(
  child: Container(
    width: double.infinity, // forza il Column a full width
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Routes Trento",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: routesTrento
              .map((route) => SelectableBusRectangle(
                    bus: BusRectangle.fromRoute(route, 2),
                  ))
              .toList(),
        ),
        const SizedBox(height: 16),
        const Text("Routes Rovereto",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: routesRovereto
              .map((route) => SelectableBusRectangle(
                    bus: BusRectangle.fromRoute(route, 2),
                  ))
              .toList(),
        ),
      ],
    ),
  ),
);

      },
    );
  }

  Future<List<BusRoute>> getRoutes(int id) async {
    final favorites = FavoritesRepository();
    final routes = await favorites.fetchRoutesDetails(id);
    return routes;
  }
}

int compareRouteShortNames(BusRoute a, BusRoute b) {
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