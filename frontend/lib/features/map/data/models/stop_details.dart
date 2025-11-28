import 'package:flutter/material.dart';

class StopArrival {
  final int routeId;
  final String routeShortName;
  final String routeLongName;
  final Color routeColor;
  final int busId;
  final DateTime? lastUpdate;
  final int? delay;
  final int lastStopId;
  final int nextStopId;
  final DateTime arrivalTimeScheduled;
  final DateTime arrivalTimeEstimated;
  final List<StopTime> stopTimes;

  StopArrival({
    required this.routeId,
    required this.routeShortName,
    required this.routeLongName,
    required this.routeColor,
    required this.busId,
    required this.lastUpdate,
    required this.delay,
    required this.lastStopId,
    required this.nextStopId,
    required this.arrivalTimeScheduled,
    required this.arrivalTimeEstimated,
    required this.stopTimes,
  });

  factory StopArrival.fromJson(Map<String, dynamic> json) {
    return StopArrival(
      routeId: json['routeId'] as int,
      routeShortName: json['routeShortName'] as String,
      routeLongName: json['routeLongName'] as String,
      routeColor: _parseHexColor(json['routeColor'] as String? ?? '000000'),
      busId: json['busId'] as int? ?? 0,
      lastUpdate: (json['lastUpdate'] as String?)?.isNotEmpty == true
          ? DateTime.parse(json['lastUpdate'])
          : null,
      delay: json['delay'] as int?,
      lastStopId: json['lastStopId'] as int,
      nextStopId: json['nextStopId'] as int,
      arrivalTimeScheduled: DateTime.parse(
        json['arrivalTimeScheduled'] as String,
      ),
      arrivalTimeEstimated: DateTime.parse(
        json['arrivalTimeEstimated'] as String,
      ),
      stopTimes: (json['stopTimes'] as List<dynamic>)
          .map((e) => StopTime.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class StopTime {
  final int stopId;
  final String stopName;
  final String arrivalTimeScheduled;
  final String arrivalTimeEstimated;

  StopTime({
    required this.stopId,
    required this.stopName,
    required this.arrivalTimeScheduled,
    required this.arrivalTimeEstimated,
  });

  factory StopTime.fromJson(Map<String, dynamic> json) {
    return StopTime(
      stopId: json['stopId'] as int,
      stopName: json['stopName'] as String,
      arrivalTimeScheduled: json['arrivalTimeScheduled'] as String,
      arrivalTimeEstimated: json['arrivalTimeEstimated'] as String,
    );
  }
}

Color _parseHexColor(String hex) {
  // "70B442" -> 0xFF70B442
  final value = int.parse('FF$hex', radix: 16);
  return Color(value);
}
