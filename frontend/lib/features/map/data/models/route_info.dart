import 'dart:ui';

class RouteInfo {
  final int areaId;
  final Object? news;
  final Color routeColor;
  final int routeId;
  final String routeLongName;
  final String routeShortName;
  final int routeType;
  final String type;

  RouteInfo({
    required this.areaId,
    required this.news,
    required this.routeColor,
    required this.routeId,
    required this.routeLongName,
    required this.routeShortName,
    required this.routeType,
    required this.type,
  });

  factory RouteInfo.fromJson(Map<String, dynamic> json) {
    return RouteInfo(
      areaId: json['areaId'] is int ? json['areaId'] as int : 0,
      news: json['news'],
      routeColor: parseHexColor(
        (json['routeColor'] as String?)?.replaceAll('#', '') ?? '000000',
      ),
      routeId: json['routeId'] is int ? json['routeId'] as int : -1,
      routeLongName: json['routeLongName'] as String? ?? '',
      routeShortName: json['routeShortName'] as String? ?? '',
      routeType: json['routeType'] is int ? json['routeType'] as int : 0,
      type: json['type'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteInfo && other.routeId == routeId;

  @override
  int get hashCode => routeId.hashCode;
}


Color parseHexColor(String hex) {
  final value = int.parse('FF$hex', radix: 16);
  return Color(value);
}