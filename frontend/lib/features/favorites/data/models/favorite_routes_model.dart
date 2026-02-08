class FavoriteRoutes {
  final List<int> routes;

  FavoriteRoutes({required this.routes});

  factory FavoriteRoutes.fromJson(Map<String, dynamic> json) {
    final list = json['favoriteRoutes'] as List?;
    return FavoriteRoutes(
      routes: list?.map((e) => int.tryParse(e.toString()) ?? 0).toList() ?? [],
    );
  }
}
