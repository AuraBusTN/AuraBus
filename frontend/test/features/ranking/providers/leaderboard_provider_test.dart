import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/ranking/presentation/providers/leaderboard_provider.dart';
import 'package:aurabus/features/auth/presentation/providers/auth_provider.dart';
import 'package:aurabus/features/auth/data/auth_repository.dart';
import 'package:aurabus/features/auth/data/models/user_model.dart';
import 'package:aurabus/features/ranking/data/models/leaderboard_data.dart';

class _FakeAuthRepository implements AuthRepository {
  bool shouldFail = false;
  LeaderboardData? leaderboardResult;

  @override
  Future<LeaderboardData> getLeaderboard() async {
    if (shouldFail) throw Exception('Leaderboard fetch failed');
    return leaderboardResult ??
        LeaderboardData(
          topUsers: [
            User(
              id: '1',
              firstName: 'Alice',
              lastName: 'A',
              email: '',
              points: 3000,
              rank: 1,
            ),
          ],
        );
  }

  @override
  Future<User> login(String e, String p) async => throw UnimplementedError();
  @override
  Future<User> signup(String f, String l, String e, String p) async =>
      throw UnimplementedError();
  @override
  Future<User> googleLogin(String idToken) async => throw UnimplementedError();
  @override
  Future<void> logout() async {}
  @override
  Future<User?> getUserProfile() async => null;
  @override
  Future<List<int>> getFavoriteRoutes() async => [];
  @override
  Future<void> updateFavoriteRoutes(List<int> routeIds) async {}
}

void main() {
  group('leaderboardProvider', () {
    test('fetches leaderboard data from repository', () async {
      final fakeRepo = _FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(fakeRepo)],
      );
      addTearDown(container.dispose);

      final result = await container.read(leaderboardProvider.future);
      expect(result.topUsers.length, 1);
      expect(result.topUsers.first.firstName, 'Alice');
    });

    test('returns empty leaderboard', () async {
      final fakeRepo = _FakeAuthRepository()
        ..leaderboardResult = LeaderboardData(topUsers: []);
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(fakeRepo)],
      );
      addTearDown(container.dispose);

      final result = await container.read(leaderboardProvider.future);
      expect(result.topUsers, isEmpty);
    });

    test('throws when repository fails', () async {
      final fakeRepo = _FakeAuthRepository()..shouldFail = true;
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(fakeRepo)],
      );
      addTearDown(container.dispose);

      final sub = container.listen(leaderboardProvider, (_, __) {});

      await Future.delayed(Duration.zero);

      final value = container.read(leaderboardProvider);
      expect(value.hasError, isTrue);

      sub.close();
    });
  });
}
