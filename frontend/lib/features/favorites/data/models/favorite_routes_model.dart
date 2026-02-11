class FavoriteRoutes {
  final List<int> routes;

  FavoriteRoutes({required this.routes});

  factory FavoriteRoutes.fromJson(Map<String, dynamic> json) {
    final rawList = json['favoriteRoutes'];

    if (rawList is! List) {
      return FavoriteRoutes(routes: []);
    }

    final routes = <int>[];

    for (final value in rawList) {
      int? parsed;

      if (value is int) {
        parsed = value;
      } else if (value is String) {
        parsed = int.tryParse(value);
      }

      if (parsed != null && parsed > 0) {
        routes.add(parsed);
      }
    }

    return FavoriteRoutes(routes: routes);
  }
}
