import 'package:aurabus/common/widgets/bus_rectangle_toggle.dart';
import 'package:aurabus/features/favorites/data/favorites_notifier.dart';
import 'package:aurabus/features/favorites/routes_provider.dart';
import 'package:aurabus/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final routesAsync = ref.watch(routesProvider);
    final favoritesState = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.favoritesTitle),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: routesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text(l10n.errorMessage(e.toString())),
          ),
          data: (routes) {

            return SingleChildScrollView(
              child: Center(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: routes.map((route) {
                    final isFavorite = favoritesState.favoriteRoutes
                        .contains(route.routeId);

                    return SelectableBusRectangle(
                      route: route,
                      size: 2.5,
                      isSelected: isFavorite,
                      onToggle: () {
                          final notifier =
                              ref.read(favoritesProvider.notifier);

                          final updated = [...favoritesState.favoriteRoutes];

                          if (isFavorite) {
                            updated.remove(route.routeId);
                          } else {
                            updated.add(route.routeId);
                          }

                          notifier.updateFavorites(updated);
                        },
                      );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
