import 'package:flutter/material.dart';

class StopTrip {
  final int routeId;
  final String routeShortName;
  final String routeLongName;
  final Color? routeColor;
  final int? busId;
  final int busCapacity;
  final String busType;
  final OccupancyStatus occupancy;
  final DateTime? lastUpdate;
  final int? delay;
  final int lastStopId;
  final int nextStopId;
  final int passedStopCount;
  final DateTime arrivalTimeScheduled;
  final DateTime arrivalTimeEstimated;
  final List<StopTripTime> stopTimes;

  StopTrip({
    required this.routeId,
    required this.routeShortName,
    required this.routeLongName,
    required this.routeColor,
    required this.busId,
    required this.busCapacity,
    required this.busType,
    required this.occupancy,
    required this.lastUpdate,
    required this.delay,
    required this.lastStopId,
    required this.nextStopId,
    required this.passedStopCount,
    required this.arrivalTimeScheduled,
    required this.arrivalTimeEstimated,
    required this.stopTimes,
  });

  factory StopTrip.fromJson(Map<String, dynamic> json) {
    return StopTrip(
      routeId: json['routeId'],
      routeShortName: json['routeShortName'],
      routeLongName: json['routeLongName'],
      routeColor: json['routeColor'] != null
          ? _parseHexColor(json['routeColor'])
          : null,
      busId: json['busId'],
      busCapacity: json['busCapacity'],
      busType: json['busType'],
      occupancy: OccupancyStatus.fromJson(
        json['occupancy'] as Map<String, dynamic>,
      ),
      lastUpdate: json['lastUpdate'] != null
          ? DateTime.parse(json['lastUpdate'])
          : null,
      delay: json['delay'],
      lastStopId: json['lastStopId'],
      nextStopId: json['nextStopId'],
      passedStopCount: json['passedStopCount'],
      arrivalTimeScheduled: DateTime.parse(json['arrivalTimeScheduled']),
      arrivalTimeEstimated: DateTime.parse(json['arrivalTimeEstimated']),
      stopTimes: (json['stopTimes'] as List)
          .map((e) => StopTripTime.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class StopTripTime {
  final int stopId;
  final String stopName;
  final String arrivalTimeScheduled;
  final int delayPredicted;

  StopTripTime({
    required this.stopId,
    required this.stopName,
    required this.arrivalTimeScheduled,
    required this.delayPredicted,
  });

  factory StopTripTime.fromJson(Map<String, dynamic> json) {
    return StopTripTime(
      stopId: json['stopId'],
      stopName: json['stopName'],
      arrivalTimeScheduled: json['arrivalTimeScheduled'],
      delayPredicted: (json['delayPredicted'] as int?) ?? 0,
    );
  }
}

class OccupancyData {
  final int percentage;
  final int passengers;

  OccupancyData({required this.percentage, required this.passengers});

  factory OccupancyData.fromJson(Map<String, dynamic> json) {
    return OccupancyData(
      percentage: json['percentage'],
      passengers: json['passengers'],
    );
  }
}

class OccupancyStatus {
  final OccupancyData realTime;
  final OccupancyData expected;

  OccupancyStatus({required this.realTime, required this.expected});

  factory OccupancyStatus.fromJson(Map<String, dynamic> json) {
    return OccupancyStatus(
      realTime: OccupancyData.fromJson(
        json['realTime'] as Map<String, dynamic>,
      ),
      expected: OccupancyData.fromJson(
        json['expected'] as Map<String, dynamic>,
      ),
    );
  }
}

Color _parseHexColor(String hex) {
  // "70B442" -> 0xFF70B442
  final value = int.parse('FF$hex', radix: 16);
  return Color(value);
}
