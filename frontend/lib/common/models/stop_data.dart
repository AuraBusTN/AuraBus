import 'package:aurabus/common/models/utils.dart';
import 'package:flutter/material.dart';

class StopData {
  final double? distance;
  final List<BusRoute> routes;
  final String stopCode;
  final String? stopDesc;
  final int stopId;
  final double stopLat;
  final int stopLevel;
  final double stopLon;
  final String stopName;
  final String street;
  final String? town;
  final String type;
  final int wheelchairBoarding;

  StopData({
    required this.distance,
    required this.routes,
    required this.stopCode,
    required this.stopDesc,
    required this.stopId,
    required this.stopLat,
    required this.stopLevel,
    required this.stopLon,
    required this.stopName,
    required this.street,
    required this.town,
    required this.type,
    required this.wheelchairBoarding,
  });

  factory StopData.fromJson(Map<String, dynamic> json) {
    return StopData(
      distance: json['distance'] as double?,
      routes: (json['routes'] as List<dynamic>)
          .map((e) => BusRoute.fromJson(e as Map<String, dynamic>))
          .toList(),
      stopCode: (json['stopCode'] as String?) ?? '',
      stopDesc: json['stopDesc'] as String?,
      stopId: json['stopId'] as int,
      stopLat: (json['stopLat'] as num).toDouble(),
      stopLevel: json['stopLevel'] as int,
      stopLon: (json['stopLon'] as num).toDouble(),
      stopName: (json['stopName'] as String?) ?? '',
      street: (json['street'] as String?) ?? '',
      town: (json['town'] as String?) ?? '',
      type: (json['type'] as String?) ?? '',
      wheelchairBoarding: json['wheelchairBoarding'] as int,
    );
  }
}

class BusRoute {
  final int areaId;
  final List<String> news;
  final Color routeColor;
  final int routeId;
  final String routeLongName;
  final String routeShortName;
  final int routeType;
  final String type;

  BusRoute({
    required this.areaId,
    required this.news,
    required this.routeColor,
    required this.routeId,
    required this.routeLongName,
    required this.routeShortName,
    required this.routeType,
    required this.type,
  });

  factory BusRoute.fromJson(Map<String, dynamic> json) {
    return BusRoute(
      areaId: json['areaId'] as int,
      news: (json['news'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      routeColor: parseHexColor(json['routeColor'] as String? ?? '000000'),
      routeId: json['routeId'] as int,
      routeLongName: (json['routeLongName'] as String?) ?? '',
      routeShortName: (json['routeShortName'] as String?) ?? '',
      routeType: json['routeType'] as int,
      type: (json['type'] as String?) ?? '',
    );
  }
}
