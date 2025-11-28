import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:aurabus/features/map/data/map_providers.dart';
import 'package:aurabus/features/map/data/models/stop_details.dart';

class StopDetailsModal extends ConsumerWidget {
  final String stopId;
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
  final String stopId;
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
        const _DragHandle(),
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
              return _LineCard(
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
                child: _BusCard(arrival: bus),
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
          color: Colors.black26,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class _LineCard extends StatelessWidget {
  final StopArrival line;
  final bool isSelected;
  final VoidCallback onTap;

  const _LineCard({
    required this.line,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? Colors.black.withValues(alpha: 0.8)
        : Colors.black12;
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              offset: const Offset(0, 3),
              color: Colors.black.withValues(alpha: .08),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/bus_icon.png',
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 2),
            Text(
              l10n.lineTitle(line.routeShortName),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum UpdateStatus { none, fresh, stale }

class _BusCard extends StatelessWidget {
  final StopArrival arrival;

  const _BusCard({required this.arrival});
  static const int _kPlaceholderOvercrowding = 0;

  @override
  Widget build(BuildContext context) {
    final updatedAt = arrival.lastUpdate;
    UpdateStatus status;
    if (updatedAt == null) {
      status = UpdateStatus.none;
    } else {
      final diffMinutes = DateTime.now().difference(updatedAt).inMinutes;
      status = diffMinutes <= 5 ? UpdateStatus.fresh : UpdateStatus.stale;
    }

    final delay = arrival.delay ?? 0;

    final scheduledTime = arrival.arrivalTimeScheduled.toLocal();
    final timeStr = TimeOfDay.fromDateTime(scheduledTime).format(context);

    Widget buildTime() {
      const baseStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

      if (delay == 0) {
        return SizedBox(
          width: 72,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(timeStr, style: baseStyle),
          ),
        );
      }

      final sign = delay > 0 ? "+$delay" : "$delay";
      final color = delay > 0 ? Colors.red : Colors.purple;

      return SizedBox(
        width: 72,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Text(timeStr, style: baseStyle),
            ),
            Positioned(
              right: -10,
              top: -10,
              child: Text(
                "$sign'",
                style: baseStyle.copyWith(fontSize: 11, color: color),
              ),
            ),
          ],
        ),
      );
    }

    final diff = arrival.arrivalTimeEstimated.difference(DateTime.now());
    int remainingMinutes = diff.isNegative ? 0 : (diff.inSeconds / 60).ceil();

    final hereIn = remainingMinutes >= 60
        ? "Here in ${remainingMinutes ~/ 60}h ${remainingMinutes % 60}m"
        : "Here in ${remainingMinutes}m";

    final overcrowding = _kPlaceholderOvercrowding;
    final overcrowdingFraction = overcrowding / 100.0;
    final l10n = AppLocalizations.of(context)!;

    final now = DateTime.now().toUtc();
    final diff = arrival.arrivalTimeEstimated.difference(now);
    final minutes = diff.inMinutes.abs();

    final hereIn = l10n.arrivingIn(minutes);

    final timeStr = TimeOfDay.fromDateTime(
      arrival.arrivalTimeEstimated.toLocal(),
    ).format(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: Colors.black.withValues(alpha: .06),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          if (status != UpdateStatus.none) ...[
            BlinkingDot(
              color: status == UpdateStatus.fresh
                  ? Colors.green
                  : Colors.orange,
            ),
            const SizedBox(width: 8),
          ] else
            const SizedBox(width: 20),

          // Line badge
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: arrival.routeColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              arrival.routeShortName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),

          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  arrival.stopTimes.last.stopName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: overcrowdingFraction,
                          minHeight: 5,
                          backgroundColor: Colors.grey.shade300,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "$overcrowding%",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildTime(),
              const SizedBox(height: 2),
              Text(
                hereIn,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BlinkingDot extends StatefulWidget {
  final Color color;
  const BlinkingDot({required this.color, super.key});

  @override
  State<BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<BlinkingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: .3,
      upperBound: 1,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}
