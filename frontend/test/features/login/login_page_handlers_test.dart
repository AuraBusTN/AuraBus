import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/login/presentation/login_page.dart';
import 'package:aurabus/features/auth/presentation/providers/auth_provider.dart';
import 'package:aurabus/features/auth/data/auth_repository.dart';
import 'package:aurabus/features/auth/data/models/user_model.dart';
import 'package:aurabus/features/ranking/data/models/leaderboard_data.dart';
import 'package:aurabus/common/widgets/generic_button.dart';
import '../../utils/test_app_wrapper.dart';

class _FakeAuthRepository implements AuthRepository {
  bool shouldFail = false;
  String failMessage = 'Login failed';

  final _user = User(
    id: '1',
    firstName: 'Test',
    lastName: 'User',
    email: 'test@test.com',
  );

  @override
  Future<User> login(String email, String password) async {
    if (shouldFail) throw Exception(failMessage);
    return _user;
  }

  @override
  Future<User> signup(String f, String l, String e, String p) async => _user;
  @override
  Future<User> googleLogin(String idToken) async => _user;
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

void main() {
  group('LoginPage handler tests', () {
    testWidgets('successful login navigates to account', (tester) async {
      final fakeRepo = _FakeAuthRepository();

      await tester.pumpWidget(
        createTestApp(
          child: const LoginPage(),
          overrides: [authRepositoryProvider.overrideWithValue(fakeRepo)],
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('emailField')),
        'test@test.com',
      );
      await tester.enterText(
        find.byKey(const Key('passwordField')),
        'password123',
      );

      final loginButton = find.widgetWithText(GenericButton, 'Login');
      await tester.ensureVisible(loginButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.text('Account Screen Reached'), findsOneWidget);
    });

    testWidgets('failed login shows error snackbar', (tester) async {
      final fakeRepo = _FakeAuthRepository()
        ..shouldFail = true
        ..failMessage = 'Invalid credentials';

      await tester.pumpWidget(
        createTestApp(
          child: const LoginPage(),
          overrides: [authRepositoryProvider.overrideWithValue(fakeRepo)],
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('emailField')),
        'test@test.com',
      );
      await tester.enterText(
        find.byKey(const Key('passwordField')),
        'password123',
      );

      final loginButton = find.widgetWithText(GenericButton, 'Login');
      await tester.ensureVisible(loginButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('back button navigates to map', (tester) async {
      await tester.pumpWidget(createTestApp(child: const LoginPage()));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('Map Screen Reached'), findsOneWidget);
    });

    testWidgets('Sign Up link navigates to signup', (tester) async {
      await tester.pumpWidget(createTestApp(child: const LoginPage()));
      await tester.pumpAndSettle();

      final signUpLink = find.text('Sign Up');
      await tester.ensureVisible(signUpLink);
      await tester.tap(signUpLink);
      await tester.pumpAndSettle();

      expect(find.text('Signup Screen Reached'), findsOneWidget);
    });

    testWidgets('shows loading indicator while authenticating', (tester) async {
      final fakeRepo = _FakeAuthRepository();

      await tester.pumpWidget(
        createTestApp(
          child: const LoginPage(),
          overrides: [authRepositoryProvider.overrideWithValue(fakeRepo)],
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('emailField')),
        'test@test.com',
      );
      await tester.enterText(
        find.byKey(const Key('passwordField')),
        'password123',
      );

      final loginButton = find.widgetWithText(GenericButton, 'Login');
      await tester.ensureVisible(loginButton);
      await tester.tap(loginButton);

      await tester.pump();
      await tester.pumpAndSettle();
    });

    testWidgets('tapping Forgot Password does not crash', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestApp(child: const LoginPage()));
      await tester.pumpAndSettle();

      final forgotPassword = find.text('Forgot Password?');
      expect(forgotPassword, findsOneWidget);
      await tester.ensureVisible(forgotPassword);
      await tester.tap(forgotPassword);
      await tester.pump();

      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('tapping body unfocuses form fields', (tester) async {
      await tester.pumpWidget(createTestApp(child: const LoginPage()));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('emailField')));
      await tester.pump();

      await tester.tapAt(const Offset(100, 100));
      await tester.pump();

      expect(find.byType(LoginPage), findsOneWidget);
    });
  });
}
