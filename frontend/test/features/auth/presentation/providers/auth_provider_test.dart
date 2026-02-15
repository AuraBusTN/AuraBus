import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aurabus/features/auth/presentation/providers/auth_provider.dart';
import 'package:aurabus/features/auth/data/auth_repository.dart';
import 'package:aurabus/features/auth/data/models/user_model.dart';
import 'package:aurabus/features/ranking/data/models/leaderboard_data.dart';

class FakeAuthRepository implements AuthRepository {
  bool loginCalled = false;
  bool signupCalled = false;
  bool googleLoginCalled = false;
  bool logoutCalled = false;
  bool getUserProfileCalled = false;

  bool shouldThrow = false;
  User? profileUser;

  final _fakeUser = User(
    id: 'test-id',
    firstName: 'Test',
    lastName: 'User',
    email: 'test@example.com',
  );

  @override
  Future<User> login(String email, String password) async {
    loginCalled = true;
    if (shouldThrow) throw Exception('Login failed');
    return _fakeUser;
  }

  @override
  Future<User> signup(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    signupCalled = true;
    if (shouldThrow) throw Exception('Signup failed');
    return _fakeUser;
  }

  @override
  Future<User> googleLogin(String idToken) async {
    googleLoginCalled = true;
    if (shouldThrow) throw Exception('Google login failed');
    return _fakeUser;
  }

  @override
  Future<void> logout() async {
    logoutCalled = true;
  }

  @override
  Future<User?> getUserProfile() async {
    getUserProfileCalled = true;
    if (shouldThrow) throw Exception('Profile error');
    return profileUser;
  }

  @override
  Future<LeaderboardData> getLeaderboard() async {
    return LeaderboardData(topUsers: []);
  }

  @override
  Future<List<int>> getFavoriteRoutes() async => [];

  @override
  Future<void> updateFavoriteRoutes(List<int> routeIds) async {}
}

void main() {
  group('AuthNotifier', () {
    late ProviderContainer container;
    late FakeAuthRepository fakeRepo;

    setUp(() {
      fakeRepo = FakeAuthRepository();
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeRepo as dynamic),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is not loading and not authenticated', () {
      final state = container.read(authProvider);
      expect(state.isLoading, isFalse);
      expect(state.isAuthenticated, isFalse);
      expect(state.error, isNull);
      expect(state.user, isNull);
    });

    test('setAuthError sets error message', () {
      container.read(authProvider.notifier).setAuthError('Test error');
      final state = container.read(authProvider);
      expect(state.error, 'Test error');
      expect(state.isLoading, isFalse);
    });

    test('setAuthError with null clears error', () {
      container.read(authProvider.notifier).setAuthError('Some error');
      expect(container.read(authProvider).error, 'Some error');

      container.read(authProvider.notifier).setAuthError(null);
      expect(container.read(authProvider).error, isNull);
    });

    test('login succeeds and updates state', () async {
      final notifier = container.read(authProvider.notifier);
      final result = await notifier.login('test@test.com', 'password');

      expect(result, isTrue);
      expect(fakeRepo.loginCalled, isTrue);
      final state = container.read(authProvider);
      expect(state.isAuthenticated, isTrue);
      expect(state.user, isNotNull);
      expect(state.user!.email, 'test@example.com');
      expect(state.isLoading, isFalse);
      expect(state.error, isNull);
    });

    test('login failure sets error', () async {
      fakeRepo.shouldThrow = true;
      final notifier = container.read(authProvider.notifier);
      final result = await notifier.login('test@test.com', 'password');

      expect(result, isFalse);
      final state = container.read(authProvider);
      expect(state.isAuthenticated, isFalse);
      expect(state.isLoading, isFalse);
      expect(state.error, isNotNull);
    });

    test('signup succeeds and updates state', () async {
      final notifier = container.read(authProvider.notifier);
      final result = await notifier.signup('John', 'Doe', 'j@d.com', 'pw1234');

      expect(result, isTrue);
      expect(fakeRepo.signupCalled, isTrue);
      final state = container.read(authProvider);
      expect(state.isAuthenticated, isTrue);
      expect(state.user, isNotNull);
      expect(state.isLoading, isFalse);
    });

    test('signup failure sets error', () async {
      fakeRepo.shouldThrow = true;
      final notifier = container.read(authProvider.notifier);
      final result = await notifier.signup('John', 'Doe', 'j@d.com', 'pw1234');

      expect(result, isFalse);
      final state = container.read(authProvider);
      expect(state.isAuthenticated, isFalse);
      expect(state.error, isNotNull);
    });

    test('loginWithGoogleIdToken with valid token succeeds', () async {
      final notifier = container.read(authProvider.notifier);
      final result = await notifier.loginWithGoogleIdToken('valid-token-123');

      expect(result, isTrue);
      expect(fakeRepo.googleLoginCalled, isTrue);
      final state = container.read(authProvider);
      expect(state.isAuthenticated, isTrue);
      expect(state.user, isNotNull);
    });

    test(
      'loginWithGoogleIdToken with valid token failure sets error',
      () async {
        fakeRepo.shouldThrow = true;
        final notifier = container.read(authProvider.notifier);
        final result = await notifier.loginWithGoogleIdToken('valid-token-123');

        expect(result, isFalse);
        final state = container.read(authProvider);
        expect(state.error, isNotNull);
      },
    );

    test('loginWithGoogleIdToken with empty string returns false', () async {
      final result = await container
          .read(authProvider.notifier)
          .loginWithGoogleIdToken('');

      expect(result, isFalse);
    });

    test('loginWithGoogleIdToken with whitespace only returns false', () async {
      final result = await container
          .read(authProvider.notifier)
          .loginWithGoogleIdToken('   ');

      expect(result, isFalse);
    });

    test('logout resets state', () async {
      await container.read(authProvider.notifier).login('a@b.com', 'pw');
      expect(container.read(authProvider).isAuthenticated, isTrue);

      await container.read(authProvider.notifier).logout();
      expect(fakeRepo.logoutCalled, isTrue);
      final state = container.read(authProvider);
      expect(state.isAuthenticated, isFalse);
    });

    test('checkAuthStatus with user sets authenticated', () async {
      fakeRepo.profileUser = User(
        id: 'u1',
        firstName: 'Jane',
        lastName: 'Doe',
        email: 'jane@test.com',
      );

      await container.read(authProvider.notifier).checkAuthStatus();

      final state = container.read(authProvider);
      expect(state.isAuthenticated, isTrue);
      expect(state.user!.firstName, 'Jane');
    });

    test('checkAuthStatus with null user sets unauthenticated', () async {
      fakeRepo.profileUser = null;

      await container.read(authProvider.notifier).checkAuthStatus();

      final state = container.read(authProvider);
      expect(state.isAuthenticated, isFalse);
      expect(state.user, isNull);
    });

    test('checkAuthStatus on error sets unauthenticated', () async {
      fakeRepo.shouldThrow = true;

      await container.read(authProvider.notifier).checkAuthStatus();

      final state = container.read(authProvider);
      expect(state.isAuthenticated, isFalse);
    });
  });

  group('AuthState', () {
    test('default values', () {
      const state = AuthState();
      expect(state.isLoading, isFalse);
      expect(state.isAuthenticated, isFalse);
      expect(state.error, isNull);
      expect(state.user, isNull);
    });

    test('copyWith preserves unchanged fields', () {
      const state = AuthState(isAuthenticated: true);
      final updated = state.copyWith(isLoading: true);
      expect(updated.isLoading, isTrue);
      expect(updated.isAuthenticated, isTrue);
    });

    test('copyWith clears error when set to null', () {
      const state = AuthState(error: 'Some error');
      final updated = state.copyWith(error: null);
      expect(updated.error, isNull);
    });
  });

  group('Provider Definitions', () {
    test('tokenStorageProvider exists', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final storage = container.read(tokenStorageProvider);
      expect(storage, isNotNull);
    });

    test('authProvider exists and returns AuthState', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(authProvider);
      expect(state, isA<AuthState>());
    });
  });
}
