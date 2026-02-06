import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:aurabus/core/utils/color_utils.dart';
import 'package:aurabus/core/utils/route_utils.dart';
import 'package:aurabus/theme.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:aurabus/features/map/data/map_providers.dart';
import 'package:aurabus/features/map/data/models/stop_info.dart';
import 'package:aurabus/features/map/data/models/route_info.dart';
import 'package:aurabus/features/map/presentation/map_controller.dart';

class UnifiedStopEntry {
  final String stopName;
  final Set<RouteInfo> allRoutes;
  final LatLng location;

  UnifiedStopEntry({
    required this.stopName,
    required this.allRoutes,
    required this.location,
  });
}

class MapSearchBar extends ConsumerStatefulWidget {
  const MapSearchBar({super.key});

  @override
  ConsumerState<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends ConsumerState<MapSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<UnifiedStopEntry> _filteredEntries = [];
  bool _showResults = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _showResults = _focusNode.hasFocus && _controller.text.isNotEmpty;
    });
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      final query = _controller.text.trim().toLowerCase();

      final stopsAsync = ref.read(stopsListProvider);
      final allStops = stopsAsync.asData?.value ?? [];

      if (query.isEmpty) {
        setState(() {
          _filteredEntries = [];
          _showResults = false;
        });
        return;
      }

      final Map<String, List<StopInfo>> groupedStops = {};

      for (var stop in allStops) {
        if (stop.stopName.toLowerCase().contains(query)) {
          groupedStops.putIfAbsent(stop.stopName, () => []).add(stop);
        }
      }

      final List<UnifiedStopEntry> results = [];

      groupedStops.forEach((name, stops) {
        final allRoutes = <RouteInfo>{};
        double sumLat = 0;
        double sumLon = 0;

        for (var stop in stops) {
          allRoutes.addAll(stop.routes);
          sumLat += stop.stopLat;
          sumLon += stop.stopLon;
        }

        final centerLat = sumLat / stops.length;
        final centerLon = sumLon / stops.length;

        results.add(
          UnifiedStopEntry(
            stopName: name,
            allRoutes: allRoutes,
            location: LatLng(centerLat, centerLon),
          ),
        );
      });

      setState(() {
        _filteredEntries = results.take(10).toList();
        _showResults = true;
      });
    });
  }

  void _onEntrySelected(UnifiedStopEntry entry) {
    _controller.text = entry.stopName;
    _focusNode.unfocus();
    setState(() {
      _showResults = false;
    });

    final mapController = ref.read(mapControllerProvider);

    mapController.controller?.animateCamera(
      CameraUpdate.newLatLngZoom(entry.location, 17.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    ref.watch(stopsListProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: l10n.searchPlaceholder,
              hintStyle: const TextStyle(color: AppColors.textSecondary),
              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () {
                        _controller.clear();
                        setState(() {
                          _filteredEntries = [];
                          _showResults = false;
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        if (_showResults && _filteredEntries.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 350),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: _filteredEntries.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1, color: AppColors.divider),
                  itemBuilder: (context, index) {
                    final entry = _filteredEntries[index];

                    final sortedRoutes = entry.allRoutes.toList()
                      ..sort(RouteUtils.compareRoutes);

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      title: Text(
                        entry.stopName,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: sortedRoutes.map((route) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: ColorUtils.parseHexColor(
                                  route.routeColor,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                route.routeShortName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      onTap: () => _onEntrySelected(entry),
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}
