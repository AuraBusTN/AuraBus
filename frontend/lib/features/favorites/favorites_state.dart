class FavoritesState {
  final bool isLoading;
  final List<int> favoriteRoutes;
  final String? error;

  const FavoritesState({
    this.isLoading = false,
    this.favoriteRoutes = const [],
    this.error,
  });

  FavoritesState copyWith({
    bool? isLoading,
    List<int>? favoriteRoutes,
    String? error,
  }) {
    return FavoritesState(
      isLoading: isLoading ?? this.isLoading,
      favoriteRoutes: favoriteRoutes ?? this.favoriteRoutes,
      error: error,
    );
  }
}
