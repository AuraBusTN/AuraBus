import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aurabus/features/auth/presentation/providers/auth_provider.dart';
import 'package:aurabus/features/auth/presentation/providers/favorite_route_provider.dart';
import 'package:aurabus/features/auth/data/auth_repository.dart';
import 'package:aurabus/features/auth/data/models/user_model.dart';
import 'package:aurabus/features/ranking/data/models/leaderboard_data.dart';

class _FakeAuthRepository implements AuthRepository {
  final List<int> _favorites = [1, 2, 3];
  List<int>? updatedFavorites;
  bool shouldThrowOnSave = false;

  @override
  Future<List<int>> getFavoriteRoutes() async => _favorites;

  @override
  Future<void> updateFavoriteRoutes(List<int> routeIds) async {
    if (shouldThrowOnSave) throw Exception('Save failed');
    updatedFavorites = routeIds;
  }

  @override
  Future<User> login(String e, String p) async =>
      User(id: '1', firstName: 'A', lastName: 'B', email: e);
  @override
  Future<User> signup(String f, String l, String e, String p) async =>
      User(id: '1', firstName: f, lastName: l, email: e);
  @override
  Future<User> googleLogin(String idToken) async =>
      User(id: '1', firstName: 'G', lastName: 'G', email: 'g@g.com');
  @override
  Future<void> logout() async {}
  @override
  Future<User?> getUserProfile() async =>
      User(id: '1', firstName: 'A', lastName: 'B', email: 'a@b.com');
  @override
  Future<LeaderboardData> getLeaderboard() async =>
      LeaderboardData(topUsers: []);
}

void main() {
  group('FavoriteRoutesNotifier', () {
    test('toggleRoute adds a route', () async {
      final fakeRepo = _FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(fakeRepo)],
      );
      addTearDown(container.dispose);

      await container.read(favoriteRoutesProvider.future);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      await container.read(favoriteRoutesProvider.future);

      final notifier = container.read(favoriteRoutesProvider.notifier);
      notifier.toggleRoute(10);

      final favs = container.read(favoriteRoutesProvider).value!;
      expect(favs.contains(10), isTrue);
    });

    test('toggleRoute removes an existing route', () async {
      final fakeRepo = _FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(fakeRepo)],
      );
      addTearDown(container.dispose);

      await container.read(favoriteRoutesProvider.future);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      await container.read(favoriteRoutesProvider.future);

      final notifier = container.read(favoriteRoutesProvider.notifier);
      notifier.toggleRoute(1);

      final favs = container.read(favoriteRoutesProvider).value!;
      expect(favs.contains(1), isFalse);
    });

    test('isFavorite returns true for existing route', () async {
      final fakeRepo = _FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(fakeRepo)],
      );
      addTearDown(container.dispose);

      await container.read(favoriteRoutesProvider.future);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      await container.read(favoriteRoutesProvider.future);

      final notifier = container.read(favoriteRoutesProvider.notifier);
      expect(notifier.isFavorite(1), isTrue);
      expect(notifier.isFavorite(999), isFalse);
    });

    test('saveFavorites calls repository', () async {
      final fakeRepo = _FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(fakeRepo)],
      );
      addTearDown(container.dispose);

      await container.read(favoriteRoutesProvider.future);

      await container.read(favoriteRoutesProvider.notifier).saveFavorites();

      expect(fakeRepo.updatedFavorites, isNotNull);
    });

    test('saveFavorites throws on error', () async {
      final fakeRepo = _FakeAuthRepository()..shouldThrowOnSave = true;
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(fakeRepo)],
      );
      addTearDown(container.dispose);

      await container.read(favoriteRoutesProvider.future);

      expect(
        () => container.read(favoriteRoutesProvider.notifier).saveFavorites(),
        throwsA(isA<Exception>()),
      );
    });

    test('build returns empty set when not authenticated', () async {
      final fakeRepo = _FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeRepo),
          authProvider.overrideWith(() => _UnauthNotifier()),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(favoriteRoutesProvider.future);
      expect(result, isEmpty);
    });
  });
}

class _UnauthNotifier extends AuthNotifier {
  @override
  AuthState build() {
    return const AuthState(isAuthenticated: false);
  }
}
