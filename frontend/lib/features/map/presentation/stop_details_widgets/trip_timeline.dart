import 'package:aurabus/common/models/stop_details.dart';
import 'package:aurabus/features/map/presentation/stop_details_widgets/timeline_stop.dart';
import 'package:flutter/material.dart';

class TripTimeline extends StatefulWidget {
  final List<StopTime> stops;
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
  final controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final index = widget.stops.indexWhere(
        (s) => s.stopId == widget.thisStopId,
      );

      if (index != -1) {
        controller.jumpTo(index * 56);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            offset: const Offset(0, 3),
            color: Colors.black.withValues(alpha: .07),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
      constraints: const BoxConstraints(maxHeight: 240),
      child: ListView.builder(
        controller: controller,
        itemCount: widget.stops.length,
        itemBuilder: (context, index) {
          final stop = widget.stops[index];
          final bool isPastOrCurrent = index < widget.passedStopCount;

          final bool isThisStop = stop.stopId == widget.thisStopId;

          return TimelineStop(
            stop: stop,
            delay: widget.delay,
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