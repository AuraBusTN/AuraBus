import 'route_info.dart';

class StopInfo {
  final double? distance;
  final List<RouteInfo> routes;
  final String stopCode;
  final String stopDesc;
  final int stopId;
  final double stopLat;
  final int stopLevel;
  final double stopLon;
  final String stopName;
  final String street;
  final String? town;
  final String type;
  final int wheelchairBoarding;

  StopInfo({
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

  factory StopInfo.fromJson(Map<String, dynamic> json) {
    return StopInfo(
      distance: json['distance'],
      routes: (json['routes'] as List)
          .map((e) => RouteInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      stopCode: json['stopCode'],
      stopDesc: json['stopDesc'],
      stopId: json['stopId'],
      stopLat: json['stopLat'],
      stopLevel: json['stopLevel'],
      stopLon: json['stopLon'],
      stopName: json['stopName'],
      street: json['street'],
      town: json['town'],
      type: json['type'],
      wheelchairBoarding: json['wheelchairBoarding'],
    );
  }
}
