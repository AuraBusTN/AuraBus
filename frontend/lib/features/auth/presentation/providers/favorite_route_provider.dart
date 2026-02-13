import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aurabus/features/auth/presentation/providers/auth_provider.dart';

class FavoriteRoutesNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() {
    final authState = ref.watch(authProvider);

    if (authState.isAuthenticated) {
      _loadFavorites();
    }

    return {};
  }

  Future<void> _loadFavorites() async {
    try {
      final repo = ref.read(authRepositoryProvider);
      final favs = await repo.getFavoriteRoutes();
      state = favs.toSet();
    } catch (e) {
      state = {};
    }
  }

  void toggleRoute(int routeId) {
    if (state.contains(routeId)) {
      state = {...state}..remove(routeId);
    } else {
      state = {...state, routeId};
    }
  }

  bool isFavorite(int routeId) => state.contains(routeId);

  Future<void> saveFavorites() async {
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.updateFavoriteRoutes(state.toList());
    } catch (e) {
      throw Exception("Failed to save: $e");
    }
  }
}

final favoriteRoutesProvider =
    NotifierProvider<FavoriteRoutesNotifier, Set<int>>(
      FavoriteRoutesNotifier.new,
    );
