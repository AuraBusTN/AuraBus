class RouteInfo {
  final String? routeColor;
  final int routeId;
  final String routeLongName;
  final String routeShortName;

  RouteInfo({
    required this.routeColor,
    required this.routeId,
    required this.routeLongName,
    required this.routeShortName,
  });

  factory RouteInfo.fromJson(Map<String, dynamic> json) {
    return RouteInfo(
      routeColor: json['routeColor'],
      routeId: json['routeId'],
      routeLongName: json['routeLongName'],
      routeShortName: json['routeShortName'],
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
