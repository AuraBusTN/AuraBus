import 'package:aurabus/features/favorites/favorites_state.dart';
import 'package:aurabus/features/favorites/data/favorites_provider.dart';
import 'package:aurabus/features/favorites/data/favorites_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class FavoritesNotifier extends Notifier<FavoritesState> {
  @override
FavoritesState build() {
  Future.microtask(() => loadFavorites());
  return const FavoritesState();
}

  FavoritesRepository get _repo =>
      ref.read(favoritesRepositoryProvider);

  Future<void> loadFavorites() async {
    state = state.copyWith(isLoading: true);
    try {
      final favorites = await _repo.getFavoriteRoutes();
      state = state.copyWith(
        isLoading: false,
        favoriteRoutes: favorites.routes,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateFavorites(List<int> routes) async {
    state = state.copyWith(isLoading: true);
    try {
      final updated = await _repo.updateFavoriteRoutes(routes);
      state = state.copyWith(
        isLoading: false,
        favoriteRoutes: updated,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  bool isFavorite(int routeId) {
    return state.favoriteRoutes.contains(routeId);
  }
}

final favoritesProvider =
    NotifierProvider<FavoritesNotifier, FavoritesState>(
  FavoritesNotifier.new,
);
