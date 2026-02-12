import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aurabus/features/favorites/data/models/favorites_repository.dart';
import 'package:aurabus/features/favorites/data/favorites_provider.dart';

class FavoritesNotifier extends AsyncNotifier<List<int>> {
  FavoritesRepository get _repo => ref.read(favoritesRepositoryProvider);

  @override
  Future<List<int>> build() async {
    // fetch iniziale, AsyncNotifier gestisce loading/error/data
    final favorites = await _repo.getFavoriteRoutes();
    return favorites.routes;
  }

  Future<void> updateFavorites(List<int> routes) async {
    // set loading durante l'aggiornamento
    state = const AsyncValue.loading();
    try {
      final updated = await _repo.updateFavoriteRoutes(routes);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  bool isFavorite(int routeId) {
    return state.value?.contains(routeId) ?? false;
  }
}

final favoritesProvider =
    AsyncNotifierProvider<FavoritesNotifier, List<int>>(FavoritesNotifier.new);
