import 'package:aurabus/common/models/stop_details.dart';
import 'package:aurabus/features/map/presentation/stop_details_widgets/bus_card_header.dart';
import 'package:aurabus/features/map/presentation/stop_details_widgets/trip_timeline.dart';
import 'package:flutter/material.dart';

class BusCard extends StatefulWidget {
  final StopArrival arrival;
  final int thisStopId;

  const BusCard({
    super.key, 
    required this.arrival, 
    required this.thisStopId});

  @override
  State<BusCard> createState() => _BusCardState();
}

class _BusCardState extends State<BusCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final arrival = widget.arrival;
    final thisStopId = widget.thisStopId;

    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => expanded = !expanded),
          child: BusCardHeader(arrival: arrival),
        ),
        if (expanded)
          TripTimeline(
            stops: arrival.stopTimes,
            delay: arrival.delay ?? 0,
            passedStopCount: arrival.passedStopCount,
            thisStopId: thisStopId,
          ),
      ],
    );
  }
}