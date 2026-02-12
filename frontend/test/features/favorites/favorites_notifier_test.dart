import 'package:aurabus/features/favorites/data/favorites_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/favorites/data/favorites_provider.dart';
import 'package:aurabus/features/favorites/data/models/favorites_repository.dart';
import 'package:aurabus/features/favorites/data/models/favorite_routes_model.dart';

class _FakeFavoritesRepository implements FavoritesRepository {
  List<int> _mockFavorites = [];
  Exception? _exceptionToThrow;

  _FakeFavoritesRepository({List<int>? initialFavorites}) {
    _mockFavorites = initialFavorites ?? [];
  }

  void setThrowException(Exception? exception) {
    _exceptionToThrow = exception;
  }

  void setMockFavorites(List<int> favorites) {
    _mockFavorites = favorites;
  }

  @override
  Future<FavoriteRoutes> getFavoriteRoutes() async {
    if (_exceptionToThrow != null) throw _exceptionToThrow!;
    return FavoriteRoutes(routes: _mockFavorites);
  }

  @override
  Future<List<int>> updateFavoriteRoutes(List<int> routes) async {
    if (_exceptionToThrow != null) throw _exceptionToThrow!;
    _mockFavorites = routes;
    return _mockFavorites;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('FavoritesNotifier (AsyncNotifier)', () {
    test('initial state is loading then loads favorites', () async {
      final fakeRepo = _FakeFavoritesRepository(initialFavorites: [1, 2, 3]);

      final container = ProviderContainer(
        overrides: [
          favoritesRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(favoritesProvider.notifier);

      expect(container.read(favoritesProvider), isA<AsyncValue<List<int>>>());
      expect(container.read(favoritesProvider).isLoading, true);

      final result = await notifier.build();
      expect(result, [1, 2, 3]);

      final state = container.read(favoritesProvider);
      expect(state.hasError, false);
      expect(state.value, [1, 2, 3]);
    });

    test('loadFavorites handles network error', () async {
      final fakeRepo = _FakeFavoritesRepository();
      fakeRepo.setThrowException(Exception('Network error'));

      final container = ProviderContainer(
        overrides: [
          favoritesRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(favoritesProvider.notifier);

      try {
        await notifier.build();
      } catch (_) {}

      final state = container.read(favoritesProvider);
      expect(state.hasError, true);
      expect(state.error.toString(), contains('Network error'));
    });

    test('updateFavorites successfully updates list', () async {
      final fakeRepo = _FakeFavoritesRepository(initialFavorites: [1, 2]);
      final container = ProviderContainer(
        overrides: [
          favoritesRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(favoritesProvider.notifier);

      await notifier.updateFavorites([3, 4, 5]);

      final state = container.read(favoritesProvider);
      expect(state.hasError, false);
      expect(state.value, [3, 4, 5]);
    });

    test('updateFavorites handles error', () async {
      final fakeRepo = _FakeFavoritesRepository(initialFavorites: [1, 2]);
      fakeRepo.setThrowException(Exception('Server error'));
      final container = ProviderContainer(
        overrides: [
          favoritesRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(favoritesProvider.notifier);

      await notifier.updateFavorites([3, 4, 5]);

      final state = container.read(favoritesProvider);
      expect(state.hasError, true);
      expect(state.error.toString(), contains('Server error'));
    });

    test('isFavorite works correctly', () async {
      final fakeRepo = _FakeFavoritesRepository(initialFavorites: [1, 5, 10]);
      final container = ProviderContainer(
        overrides: [
          favoritesRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(favoritesProvider.notifier);
      await notifier.build();

      expect(notifier.isFavorite(5), true);
      expect(notifier.isFavorite(99), false);
    });
  });
}
