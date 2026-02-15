import 'package:flutter/material.dart';

import 'package:aurabus/features/map/data/models/stop_trip_info.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:aurabus/theme.dart';

class BusArrivalCard extends StatefulWidget {
  final StopTrip arrival;
  final int currentStopId;

  const BusArrivalCard({
    super.key,
    required this.arrival,
    required this.currentStopId,
  });

  @override
  State<BusArrivalCard> createState() => _BusArrivalCardState();
}

class _BusArrivalCardState extends State<BusArrivalCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(0, 2),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => expanded = !expanded),
              borderRadius: BorderRadius.vertical(
                top: const Radius.circular(18),
                bottom: expanded ? Radius.zero : const Radius.circular(18),
              ),
              child: _BusCardHeader(
                arrival: widget.arrival,
                isExpanded: expanded,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(18),
            ),
            child: AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity),
              secondChild: TripTimeline(
                stops: widget.arrival.stopTimes,
                delay: widget.arrival.delay ?? 0,
                passedStopCount: widget.arrival.passedStopCount,
                thisStopId: widget.currentStopId,
              ),
              crossFadeState: expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ),
        ],
      ),
    );
  }
}

enum UpdateStatus { none, fresh, stale }

class _BusCardHeader extends StatelessWidget {
  final StopTrip arrival;
  final bool isExpanded;

  const _BusCardHeader({required this.arrival, required this.isExpanded});

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

    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now().toUtc();
    final diff = arrival.arrivalTimeEstimated.difference(now);
    final minutes = (diff.inSeconds / 60).ceil();
    var hereIn = l10n.arrivingIn(minutes);

    if (diff.isNegative) {
      hereIn = l10n.arrivingIn(0);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (status != UpdateStatus.none) ...[
            _BlinkingDot(
              color: status == UpdateStatus.fresh
                  ? Colors.green
                  : Colors.orange,
            ),
            const SizedBox(width: 8),
          ] else
            const SizedBox(width: 20),

          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: arrival.routeColor ?? Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              arrival.routeShortName,
              style: const TextStyle(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  arrival.stopTimes.last.stopName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: arrival.occupancy.expected.percentage / 100,
                          minHeight: 6,
                          backgroundColor: Colors.grey.shade200,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${arrival.occupancy.expected.percentage}%",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.grey,
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
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TripTimeline extends StatefulWidget {
  final List<StopTripTime> stops;
  final int delay;
  final int passedStopCount;
  final int thisStopId;

  const TripTimeline({
    required this.stops,
    required this.delay,
    required this.passedStopCount,
    required this.thisStopId,
    super.key,
  });

  @override
  State<TripTimeline> createState() => _TripTimelineState();
}

class _TripTimelineState extends State<TripTimeline> {
  late ScrollController controller;
  static const double _itemHeight = 56.0;

  @override
  void initState() {
    super.initState();
    final index = widget.stops.indexWhere((s) => s.stopId == widget.thisStopId);
    final initialOffset = index != -1 ? index * _itemHeight : 0.0;
    controller = ScrollController(initialScrollOffset: initialOffset);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      constraints: const BoxConstraints(maxHeight: 240),
      child: ListView.builder(
        controller: controller,
        padding: EdgeInsets.zero,
        itemCount: widget.stops.length,
        itemExtent: _itemHeight,
        itemBuilder: (context, index) {
          final stop = widget.stops[index];
          final bool isPastOrCurrent = index < widget.passedStopCount;
          final bool isThisStop = stop.stopId == widget.thisStopId;

          return _TimelineStop(
            stop: stop,
            delay: stop.delayPredicted,
            isThisStop: isThisStop,
            isPastOrCurrent: isPastOrCurrent,
            isFirst: index == 0,
            isLast: index == widget.stops.length - 1,
          );
        },
      ),
    );
  }
}

class _TimelineStop extends StatelessWidget {
  final StopTripTime stop;
  final int delay;
  final bool isPastOrCurrent;
  final bool isThisStop;
  final bool isFirst;
  final bool isLast;

  const _TimelineStop({
    required this.stop,
    required this.delay,
    required this.isPastOrCurrent,
    required this.isThisStop,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final mainColor = isPastOrCurrent
        ? AppColors.primary
        : AppColors.textSecondary.withValues(alpha: 0.3);

    final stopTime = stop.arrivalTimeScheduled.length >= 5
        ? stop.arrivalTimeScheduled.substring(0, 5)
        : stop.arrivalTimeScheduled;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 20,
          child: Column(
            children: [
              Expanded(
                child: !isFirst
                    ? Container(width: 2, color: mainColor)
                    : const SizedBox.shrink(),
              ),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: isThisStop ? mainColor : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: mainColor, width: 2),
                ),
              ),
              Expanded(
                child: !isLast
                    ? Container(width: 2, color: mainColor)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                  children: [
                    TextSpan(text: stopTime),
                    if (!isPastOrCurrent && delay != 0)
                      TextSpan(
                        text: delay > 0 ? "  +$delay'" : "  $delay'",
                        style: TextStyle(
                          color: delay > 0 ? Colors.red : Colors.purple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                stop.stopName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isThisStop ? FontWeight.bold : FontWeight.normal,
                  color: isThisStop
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BlinkingDot extends StatefulWidget {
  final Color color;
  const _BlinkingDot({required this.color});

  @override
  State<_BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<_BlinkingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: FadeTransition(
        opacity: _animation,
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.5),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
