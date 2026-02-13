import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aurabus/features/auth/presentation/providers/auth_provider.dart';

class FavoriteRoutesNotifier extends AsyncNotifier<Set<int>> {
  @override
  Future<Set<int>> build() async {
    final authState = ref.watch(authProvider);

    if (authState.isAuthenticated) {
      return await _loadFavorites();
    }

    return {};
  }

  Future<Set<int>> _loadFavorites() async {
    try {
      final repo = ref.read(authRepositoryProvider);
      final favs = await repo.getFavoriteRoutes();
      return favs.toSet();
    } catch (e) {
      return {};
    }
  }

  void toggleRoute(int routeId) {
    final currentFavs = state.value ?? {};
    if (currentFavs.contains(routeId)) {
      state = AsyncData({...currentFavs}..remove(routeId));
    } else {
      state = AsyncData({...currentFavs, routeId});
    }
  }

  bool isFavorite(int routeId) {
    return state.value?.contains(routeId) ?? false;
  }

  Future<void> saveFavorites() async {
    try {
      final repo = ref.read(authRepositoryProvider);
      final currentFavs = state.value ?? {};
      await repo.updateFavoriteRoutes(currentFavs.toList());
    } catch (e) {
      throw Exception("Failed to save: $e");
    }
  }
}

// Nota: Ora è un AsyncNotifierProvider
final favoriteRoutesProvider =
    AsyncNotifierProvider<FavoriteRoutesNotifier, Set<int>>(
      FavoriteRoutesNotifier.new,
    );
