import 'package:aurabus/common/models/stop_details.dart';
import 'package:aurabus/features/map/presentation/stop_details_widgets/bus_card.dart';
import 'package:aurabus/features/map/presentation/stop_details_widgets/drag_handle.dart';
import 'package:aurabus/features/map/presentation/stop_details_widgets/line_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:aurabus/features/map/data/map_providers.dart';

class StopDetailsModal extends ConsumerWidget {
  final int stopId;
  final String stopName;

  const StopDetailsModal({
    super.key,
    required this.stopId,
    required this.stopName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(stopDetailsProvider(stopId));
    final l10n = AppLocalizations.of(context)!;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
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
              stopId: stopId,
              stopName: stopName,
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
  final int stopId;
  final String stopName;
  final List<StopArrival> arrivals;

  const _StopDetailsContent({
    required this.controller,
    required this.stopId,
    required this.stopName,
    required this.arrivals,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLines = ref.watch(selectedLinesProvider);

    final filteredArrivals = selectedLines.isEmpty
        ? arrivals
        : arrivals
              .where((a) => selectedLines.contains(a.routeShortName))
              .toList();

    final uniqueLines =
        {for (final a in arrivals) a.routeShortName: a}.values.toList()
          ..sort((a, b) {
            final numA = int.tryParse(a.routeShortName);
            final numB = int.tryParse(b.routeShortName);
            if (numA != null && numB != null) {
              return numA.compareTo(numB);
            } else if (numA != null) {
              return -1;
            } else if (numB != null) {
              return 1;
            }
            return a.routeShortName.compareTo(b.routeShortName);
          });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DragHandle(),
        const SizedBox(height: 12),
        Text(
          "$stopId - $stopName",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),

        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: uniqueLines.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final line = uniqueLines[index];
              final isSelected = selectedLines.contains(line.routeShortName);
              return LineCard(
                line: line,
                isSelected: isSelected,
                onTap: () => ref
                    .read(selectedLinesProvider.notifier)
                    .toggle(line.routeShortName),
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
                padding: const EdgeInsets.only(bottom: 12),
                child: BusCard(arrival: bus, thisStopId: stopId),
              );
            },
          ),
        ),
      ],
    );
  }
}
enum UpdateStatus { none, fresh, stale }