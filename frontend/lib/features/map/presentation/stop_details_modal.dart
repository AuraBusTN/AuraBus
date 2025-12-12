import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aurabus/theme.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:aurabus/features/map/data/map_providers.dart';
import 'package:aurabus/features/map/data/models/stop_info.dart';
import 'package:aurabus/features/map/data/models/stop_trip_info.dart';
import 'package:aurabus/features/map/widgets/bus_arrival_card.dart';
import 'package:aurabus/features/map/widgets/route_filter_card.dart';

class StopDetailsModal extends ConsumerWidget {
  final StopInfo stopInfo;

  const StopDetailsModal({super.key, required this.stopInfo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(stopDetailsProvider(stopInfo.stopId));
    final l10n = AppLocalizations.of(context)!;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).bottomSheetTheme.backgroundColor,
            borderRadius: switch (Theme.of(context).bottomSheetTheme.shape) {
              RoundedRectangleBorder r => r.borderRadius,
              _ => const BorderRadius.vertical(top: Radius.circular(20)),
            },
          ),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: async.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Center(child: Text(l10n.errorMessage(e.toString()))),
            data: (arrivals) => _StopDetailsContent(
              controller: controller,
              stopInfo: stopInfo,
              arrivals: arrivals,
            ),
          ),
        );
      },
    );
  }
}

class _StopDetailsContent extends ConsumerWidget {
  final ScrollController controller;
  final StopInfo stopInfo;
  final List<StopTrip> arrivals;

  const _StopDetailsContent({
    required this.controller,
    required this.stopInfo,
    required this.arrivals,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uniqueLines = ref.watch(sortedUniqueLinesProvider(stopInfo.stopId));

    final selectedLines = ref.watch(selectedLinesProvider);

    final filteredArrivals = selectedLines.isEmpty
        ? arrivals
        : arrivals
              .where((a) => selectedLines.any((r) => r.routeId == a.routeId))
              .toList();

    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _DragHandle(),
        const SizedBox(height: 12),
        SizedBox(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "${stopInfo.stopId} - ${stopInfo.stopName}",
                  style: Theme.of(context).textTheme.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              AnimatedOpacity(
                opacity: selectedLines.isNotEmpty ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: IgnorePointer(
                  ignoring: selectedLines.isEmpty,
                  child: TextButton(
                    onPressed: () {
                      ref.read(selectedLinesProvider.notifier).clear();
                    },
                    child: Text(l10n.clear),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),

        SizedBox(
          height: 100,
          child: ListView.separated(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount: uniqueLines.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final route = uniqueLines[index];

              final isSelected = selectedLines.contains(route);

              return RouteFilterCard(
                line: route,
                isSelected: isSelected,
                onTap: () {
                  ref.read(selectedLinesProvider.notifier).toggle(route);
                },
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        Expanded(
          child: ListView.builder(
            controller: controller,
            itemCount: filteredArrivals.length,
            itemBuilder: (context, index) {
              final bus = filteredArrivals[index];
              return Padding(
                key: ValueKey("${bus.routeId}"),
                padding: const EdgeInsets.only(bottom: 12),
                child: BusArrivalCard(
                  arrival: bus,
                  currentStopId: stopInfo.stopId,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.divider,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
