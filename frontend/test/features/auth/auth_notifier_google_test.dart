import 'package:aurabus/features/auth/data/auth_repository.dart';
import 'package:aurabus/features/auth/data/models/user_model.dart';
import 'package:aurabus/features/auth/presentation/providers/auth_provider.dart';
import 'package:aurabus/features/ranking/data/models/leaderboard_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import '../../utils/fake_google_sign_in_platform.dart';

class _FakeAuthRepository implements AuthRepository {
  User? profileUser;

  User googleUserToReturn = User(
    id: 'u1',
    firstName: 'Test',
    lastName: 'User',
    email: 'test@example.com',
  );

  int googleLoginCalls = 0;
  String? lastGoogleIdToken;

  @override
  Future<User?> getUserProfile() async => profileUser;

  @override
  Future<User> googleLogin(String idToken) async {
    googleLoginCalls += 1;
    lastGoogleIdToken = idToken;
    return googleUserToReturn;
  }

  @override
  Future<User> login(String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {}

  @override
  Future<User> signup(
    String firstName,
    String lastName,
    String email,
    String password,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<LeaderboardData> getLeaderboard() async {
    return LeaderboardData(topUsers: [], me: null);
  }

  @override
  Future<List<int>> getFavoriteRoutes() {
    return Future.value([]);
  }

  @override
  Future<void> updateFavoriteRoutes(List<int> routeIds) {
    return Future.value();
  }
}

void main() {
  late GoogleSignInPlatform originalPlatform;

  setUp(() {
    originalPlatform = GoogleSignInPlatform.instance;
  });

  tearDown(() {
    GoogleSignInPlatform.instance = originalPlatform;
  });

  test('loginWithGoogle: success stores user and authenticates', () async {
    final fakePlatform = FakeGoogleSignInPlatform()
      ..nextAuthenticateResult = buildFakeAuthenticationResults(
        email: 'test@example.com',
        userId: 'google-1',
        idToken: 'id-token-123',
      );
    GoogleSignInPlatform.instance = fakePlatform;

    final fakeRepo = _FakeAuthRepository();

    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWith((ref) => fakeRepo)],
    );
    addTearDown(container.dispose);

    final ok = await container.read(authProvider.notifier).loginWithGoogle();

    expect(ok, isTrue);
    expect(fakeRepo.googleLoginCalls, 1);
    expect(fakeRepo.lastGoogleIdToken, 'id-token-123');

    final state = container.read(authProvider);
    expect(state.isAuthenticated, isTrue);
    expect(state.user?.email, 'test@example.com');
    expect(state.error, isNull);
  });

  test('loginWithGoogle: canceled returns false without error', () async {
    final fakePlatform = FakeGoogleSignInPlatform()
      ..nextAuthenticateException = const GoogleSignInException(
        code: GoogleSignInExceptionCode.canceled,
        description: 'User canceled',
      );
    GoogleSignInPlatform.instance = fakePlatform;

    final fakeRepo = _FakeAuthRepository();

    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWith((ref) => fakeRepo)],
    );
    addTearDown(container.dispose);

    final ok = await container.read(authProvider.notifier).loginWithGoogle();

    expect(ok, isFalse);
    expect(fakeRepo.googleLoginCalls, 0);

    final state = container.read(authProvider);
    expect(state.isAuthenticated, isFalse);
    expect(state.error, isNull);
  });

  test(
    'loginWithGoogle: missing ID token returns false with message',
    () async {
      final fakePlatform = FakeGoogleSignInPlatform()
        ..nextAuthenticateResult = buildFakeAuthenticationResults(
          email: 'test@example.com',
          userId: 'google-1',
          idToken: null,
        );
      GoogleSignInPlatform.instance = fakePlatform;

      final fakeRepo = _FakeAuthRepository();

      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWith((ref) => fakeRepo)],
      );
      addTearDown(container.dispose);

      final ok = await container.read(authProvider.notifier).loginWithGoogle();

      expect(ok, isFalse);
      expect(fakeRepo.googleLoginCalls, 0);

      final state = container.read(authProvider);
      expect(state.isAuthenticated, isFalse);
      expect(state.error, contains('ID token'));
    },
  );
}
