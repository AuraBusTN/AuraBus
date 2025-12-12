class RouteInfo {
  final int areaId;
  final Object? news;
  final String? routeColor;
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
      areaId: json['areaId'],
      news: json['news'],
      routeColor: json['routeColor'],
      routeId: json['routeId'],
      routeLongName: json['routeLongName'],
      routeShortName: json['routeShortName'],
      routeType: json['routeType'],
      type: json['type'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RouteInfo && other.routeId == routeId;
  }

  @override
  int get hashCode => routeId.hashCode;
}
