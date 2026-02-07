import 'package:aurabus/common/widgets/bus_rectangle.dart';
import 'package:aurabus/common/widgets/bus_rectangle_toggle.dart';
import 'package:aurabus/features/favorites/models/favorites_model.dart';
import 'package:aurabus/features/map/data/models/route_info.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:aurabus/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<RouteInfo>> _routesFuture;

  @override
  void initState() {
    super.initState();
    _routesFuture = getRoutes(); // Recupera tutte le linee
  }

  // Funzione che prende tutte le rotte e le ordina
  Future<List<RouteInfo>> getRoutes() async {
    final favorites = FavoritesRepository();
    final routes = await favorites.fetchRoutesDetails();
    routes.sort(compareRouteShortNames);
    return routes;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Preferiiti", 
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: FutureBuilder<List<RouteInfo>>(
          future: _routesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(l10n.errorMessage(snapshot.error.toString())),
              );
            }

            final routes = snapshot.data;
            if (routes == null || routes.isEmpty) {
              return const Center(child: Text('Nessuna rotta disponibile'));
            }

            // Ordinamento sicuro (anche se già ordinato in getRoutes)
            routes.sort(compareRouteShortNames);

            return SingleChildScrollView(
              child:Center(
                child: Column(
                  children: [
                  
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,       // centra gli elementi su ogni riga
                      runAlignment: WrapAlignment.center,
                      children: routes
                          .map(
                            (route) => SelectableBusRectangle(
                              bus: BusRectangle.fromRoute(route, 2.5),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              )
            );
          },
        ),
      ),
    );
  }
}

// Ordinamento delle rotte basato su routeShortName
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
