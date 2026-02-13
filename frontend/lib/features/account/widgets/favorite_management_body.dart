import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aurabus/common/widgets/generic_button.dart';
import 'package:aurabus/features/map/data/map_providers.dart';
import 'package:aurabus/features/auth/presentation/providers/favorite_route_provider.dart';
import 'package:aurabus/core/utils/color_utils.dart';
import 'package:aurabus/features/map/presentation/utils/route_utils.dart';
import 'package:aurabus/l10n/app_localizations.dart';

class FavoritesManagementBody extends ConsumerStatefulWidget {
  const FavoritesManagementBody({super.key});

  @override
  ConsumerState<FavoritesManagementBody> createState() =>
      _FavoritesManagementBodyState();
}

class _FavoritesManagementBodyState
    extends ConsumerState<FavoritesManagementBody> {
  bool _isSaving = false;

  Future<void> _onSave() async {
    setState(() => _isSaving = true);
    final l10n = AppLocalizations.of(context)!;

    try {
      await ref.read(favoriteRoutesProvider.notifier).saveFavorites();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.favoritesSaved),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorMessage(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final allRoutesAsync = ref.watch(allRoutesProvider);

    final favoriteIdsAsync = ref.watch(favoriteRoutesProvider);
    final favoriteIds = favoriteIdsAsync.value ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.favoriteLinesSubtitle,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        allRoutesAsync.when(
          data: (routes) {
            if (routes.isEmpty) {
              return Text(l10n.noLinesAvailable);
            }

            final sortedRoutes = routes.toList()
              ..sort(RouteUtils.compareRoutes);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: sortedRoutes.map((route) {
                    final isSelected = favoriteIds.contains(route.routeId);

                    return GestureDetector(
                      onTap: () {
                        ref
                            .read(favoriteRoutesProvider.notifier)
                            .toggleRoute(route.routeId);
                      },
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: isSelected ? 1.0 : 0.4,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: ColorUtils.parseHexColor(route.routeColor),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            route.routeShortName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                _isSaving
                    ? const Center(child: CircularProgressIndicator())
                    : GenericButton(
                        textLabel: l10n.saveButton,
                        onPressed: _onSave,
                      ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Text(l10n.errorLoadingLines(err.toString())),
        ),
      ],
    );
  }
}
