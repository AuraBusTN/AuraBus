import 'package:aurabus/features/favorites/data/favorites_notifier.dart';
import 'package:aurabus/features/favorites/data/favorites_provider.dart';
import 'package:aurabus/features/favorites/data/favorites_repository.dart';
import 'package:aurabus/features/favorites/data/models/favorite_routes_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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
    if (_exceptionToThrow != null) {
      throw _exceptionToThrow!;
    }
    return FavoriteRoutes(routes: _mockFavorites);
  }

  @override
  Future<List<int>> updateFavoriteRoutes(List<int> routes) async {
    if (_exceptionToThrow != null) {
      throw _exceptionToThrow!;
    }
    _mockFavorites = routes;
    return _mockFavorites;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('FavoritesNotifier', () {
    test('initial state is empty with no loading or error', () {
      final fakeRepo = _FakeFavoritesRepository();

      final container = ProviderContainer(
        overrides: [
          favoritesRepositoryProvider.overrideWith((ref) => fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      final state = container.read(favoritesProvider);
      expect(state.isLoading, isFalse);
      expect(state.favoriteRoutes, isEmpty);
      expect(state.error, isNull);
    });

    test('loadFavorites: successfully loads favorite routes', () async {
      final fakeRepo = _FakeFavoritesRepository(initialFavorites: [1, 5, 10]);

      final container = ProviderContainer(
        overrides: [
          favoritesRepositoryProvider.overrideWith((ref) => fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(favoritesProvider.notifier)
          .loadFavorites();

      final state = container.read(favoritesProvider);
      expect(state.isLoading, isFalse);
      expect(state.favoriteRoutes, [1, 5, 10]);
      expect(state.error, isNull);
    });

    test('loadFavorites: handles empty favorites list', () async {
      final fakeRepo = _FakeFavoritesRepository(initialFavorites: []);

      final container = ProviderContainer(
        overrides: [
          favoritesRepositoryProvider.overrideWith((ref) => fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(favoritesProvider.notifier)
          .loadFavorites();

      final state = container.read(favoritesProvider);
      expect(state.isLoading, isFalse);
      expect(state.favoriteRoutes, isEmpty);
      expect(state.error, isNull);
    });

    test('loadFavorites: handles network error', () async {
      final fakeRepo = _FakeFavoritesRepository();
      fakeRepo.setThrowException(Exception('Network error: Unable to fetch'));

      final container = ProviderContainer(
        overrides: [
          favoritesRepositoryProvider.overrideWith((ref) => fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(favoritesProvider.notifier)
          .loadFavorites();

      final state = container.read(favoritesProvider);
      expect(state.isLoading, isFalse);
      expect(state.favoriteRoutes, isEmpty);
      expect(state.error, contains('Network error'));
    });

    test('loadFavorites: handles timeout exception', () async {
      final fakeRepo = _FakeFavoritesRepository();
      fakeRepo.setThrowException(
        Exception('Request timeout'),
      );

      final container = ProviderContainer(
        overrides: [
          favoritesRepositoryProvider.overrideWith((ref) => fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(favoritesProvider.notifier)
          .loadFavorites();

      final state = container.read(favoritesProvider);
      expect(state.isLoading, isFalse);
      expect(state.error, contains('Request timeout'));
    });

    test('updateFavorites: successfully updates favorites', () async {
      final fakeRepo = _FakeFavoritesRepository(initialFavorites: [1, 2]);

      final container = ProviderContainer(
        overrides: [
          favoritesRepositoryProvider.overrideWith((ref) => fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(favoritesProvider.notifier)
          .updateFavorites([3, 4, 5]);

      final state = container.read(favoritesProvider);
      expect(state.isLoading, isFalse);
      expect(state.favoriteRoutes, [3, 4, 5]);
      expect(state.error, isNull);
    });

    test('updateFavorites: handles empty update', () async {
      final fakeRepo = _FakeFavoritesRepository(initialFavorites: [1, 2, 3]);

      final container = ProviderContainer(
        overrides: [
          favoritesRepositoryProvider.overrideWith((ref) => fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(favoritesProvider.notifier)
          .updateFavorites([]);

      final state = container.read(favoritesProvider);
      expect(state.isLoading, isFalse);
      expect(state.favoriteRoutes, isEmpty);
      expect(state.error, isNull);
    });

    test('updateFavorites: handles network error', () async {
      final fakeRepo = _FakeFavoritesRepository(initialFavorites: [1, 2]);
      fakeRepo.setThrowException(
        Exception('Failed to update favorites on server'),
      );

      final container = ProviderContainer(
        overrides: [
          favoritesRepositoryProvider.overrideWith((ref) => fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(favoritesProvider.notifier)
          .updateFavorites([3, 4, 5]);

      final state = container.read(favoritesProvider);
      expect(state.isLoading, isFalse);
      expect(state.favoriteRoutes, [1, 2]);
      expect(state.error, contains('Failed to update'));
    });

    test('updateFavorites: handles server error (5xx)', () async {
      final fakeRepo = _FakeFavoritesRepository(initialFavorites: [1]);
      fakeRepo.setThrowException(
        Exception('Server error: 500'),
      );

      final container = ProviderContainer(
        overrides: [
          favoritesRepositoryProvider.overrideWith((ref) => fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(favoritesProvider.notifier)
          .updateFavorites([2, 3]);

      final state = container.read(favoritesProvider);
      expect(state.isLoading, isFalse);
      expect(state.error, contains('500'));
    });

    test('isFavorite: returns true for favorite route', () async {
      final fakeRepo = _FakeFavoritesRepository(initialFavorites: [1, 5, 10]);

      final container = ProviderContainer(
        overrides: [
          favoritesRepositoryProvider.overrideWith((ref) => fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(favoritesProvider.notifier)
          .loadFavorites();

      final isFavorite =
          container.read(favoritesProvider.notifier).isFavorite(5);
      expect(isFavorite, isTrue);
    });

    test('isFavorite: returns false for non-favorite route', () async {
      final fakeRepo = _FakeFavoritesRepository(initialFavorites: [1, 5, 10]);

      final container = ProviderContainer(
        overrides: [
          favoritesRepositoryProvider.overrideWith((ref) => fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(favoritesProvider.notifier)
          .loadFavorites();

      final isFavorite =
          container.read(favoritesProvider.notifier).isFavorite(99);
      expect(isFavorite, isFalse);
    });

    test('isFavorite: returns false when no favorites loaded', () {
      final fakeRepo = _FakeFavoritesRepository();

      final container = ProviderContainer(
        overrides: [
          favoritesRepositoryProvider.overrideWith((ref) => fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      final isFavorite =
          container.read(favoritesProvider.notifier).isFavorite(1);
      expect(isFavorite, isFalse);
    });

    test('state updates correctly through multiple operations', () async {
      final fakeRepo = _FakeFavoritesRepository(initialFavorites: [1, 2]);

      final container = ProviderContainer(
        overrides: [
          favoritesRepositoryProvider.overrideWith((ref) => fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(favoritesProvider.notifier)
          .loadFavorites();
      var state = container.read(favoritesProvider);
      expect(state.favoriteRoutes, [1, 2]);

      await container
          .read(favoritesProvider.notifier)
          .updateFavorites([3, 4, 5, 6]);
      state = container.read(favoritesProvider);
      expect(state.favoriteRoutes, [3, 4, 5, 6]);

      await container
          .read(favoritesProvider.notifier)
          .updateFavorites([7]);
      state = container.read(favoritesProvider);
      expect(state.favoriteRoutes, [7]);
    });

    test('error state is cleared on successful operation', () async {
      final fakeRepo = _FakeFavoritesRepository(initialFavorites: [1]);

      final container = ProviderContainer(
        overrides: [
          favoritesRepositoryProvider.overrideWith((ref) => fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      fakeRepo.setThrowException(Exception('Network error'));
      await container
          .read(favoritesProvider.notifier)
          .loadFavorites();
      var state = container.read(favoritesProvider);
      expect(state.error, isNotNull);

      fakeRepo.setThrowException(null);
      fakeRepo.setMockFavorites([2, 3, 4]);
      await container
          .read(favoritesProvider.notifier)
          .loadFavorites();
      state = container.read(favoritesProvider);
      expect(state.error, isNull);
      expect(state.favoriteRoutes, [2, 3, 4]);
    });
  });
}
