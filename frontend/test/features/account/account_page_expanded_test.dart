import 'package:aurabus/features/account/presentation/account_page.dart';
import 'package:aurabus/features/account/widgets/account_info_body.dart';
import 'package:aurabus/features/account/widgets/subscription_body.dart';
import 'package:aurabus/features/account/widgets/favorite_management_body.dart';
import 'package:aurabus/features/auth/presentation/providers/auth_provider.dart';
import 'package:aurabus/features/auth/data/auth_repository.dart';
import 'package:aurabus/features/auth/data/models/user_model.dart';
import 'package:aurabus/features/ranking/data/models/leaderboard_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../utils/test_app_wrapper.dart';

class _FakeAuthRepository implements AuthRepository {
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
  Future<LeaderboardData> getLeaderboard() async =>
      LeaderboardData(topUsers: []);
  @override
  Future<List<int>> getFavoriteRoutes() async => [];
  @override
  Future<void> updateFavoriteRoutes(List<int> routeIds) async {}
}

class _FakeAuthNotifier extends AuthNotifier {
  final User? _user;
  _FakeAuthNotifier(this._user);

  @override
  AuthState build() => AuthState(isAuthenticated: _user != null, user: _user);

  @override
  Future<void> logout() async {
    state = const AuthState();
  }
}

void main() {
  final mockUser = User(
    id: '1',
    firstName: 'Mario',
    lastName: 'Rossi',
    email: 'mario@test.com',
  );

  group('AccountPage expanded sections', () {
    testWidgets('expanding Account Info section shows AccountInfoBody', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createTestApp(
          child: const AccountPage(),
          overrides: [
            authProvider.overrideWith(() => _FakeAuthNotifier(mockUser)),
            authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Account Info'));
      await tester.pumpAndSettle();

      expect(find.byType(AccountInfoBody), findsOneWidget);
    });

    testWidgets('expanding Subscription section shows SubscriptionBody', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createTestApp(
          child: const AccountPage(),
          overrides: [
            authProvider.overrideWith(() => _FakeAuthNotifier(mockUser)),
            authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Subscription'));
      await tester.pumpAndSettle();

      expect(find.byType(SubscriptionBody), findsOneWidget);
    });

    testWidgets(
      'expanding Favorites Management section shows FavoritesManagementBody',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          createTestApp(
            child: const AccountPage(),
            overrides: [
              authProvider.overrideWith(() => _FakeAuthNotifier(mockUser)),
              authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
            ],
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Manage Favorites'));
        await tester.pumpAndSettle();

        expect(find.byType(FavoritesManagementBody), findsOneWidget);
      },
    );

    testWidgets('tapping Ranking section navigates to ranking page', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createTestApp(
          child: const AccountPage(),
          overrides: [
            authProvider.overrideWith(() => _FakeAuthNotifier(mockUser)),
            authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final rankingSection = find.text('Ranking');
      await tester.ensureVisible(rankingSection);
      await tester.tap(rankingSection);
      await tester.pumpAndSettle();

      expect(find.text('Ranking Screen Reached'), findsOneWidget);
    });

    testWidgets('tapping logout calls logout and navigates to login', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createTestApp(
          child: const AccountPage(),
          overrides: [
            authProvider.overrideWith(() => _FakeAuthNotifier(mockUser)),
            authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final logoutButton = find.text('Logout');
      await tester.ensureVisible(logoutButton);
      await tester.tap(logoutButton);
      await tester.pumpAndSettle();

      expect(find.text('Login Screen Reached'), findsOneWidget);
    });
  });
}
