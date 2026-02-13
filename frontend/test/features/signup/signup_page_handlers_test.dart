import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/signup/presentation/signup_page.dart';
import 'package:aurabus/features/auth/presentation/providers/auth_provider.dart';
import 'package:aurabus/features/auth/data/auth_repository.dart';
import 'package:aurabus/features/auth/data/models/user_model.dart';
import 'package:aurabus/features/ranking/data/models/leaderboard_data.dart';
import 'package:aurabus/common/widgets/generic_button.dart';
import 'package:aurabus/features/signup/widgets/terms_and_conditions.dart';
import '../../utils/test_app_wrapper.dart';

class _FakeAuthRepository implements AuthRepository {
  bool shouldFail = false;
  String failMessage = 'Signup failed';

  final _user = User(
    id: '1',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@test.com',
  );

  @override
  Future<User> signup(String f, String l, String e, String p) async {
    if (shouldFail) throw Exception(failMessage);
    return _user;
  }

  @override
  Future<User> login(String e, String p) async => _user;
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
  group('SignupPage handler tests', () {
    testWidgets('successful signup navigates to account', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final fakeRepo = _FakeAuthRepository();

      await tester.pumpWidget(
        createTestApp(
          child: const SignupPage(),
          overrides: [authRepositoryProvider.overrideWithValue(fakeRepo)],
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(findTextFormFieldByLabel('First Name'), 'John');
      await tester.enterText(findTextFormFieldByLabel('Last Name'), 'Doe');
      await tester.enterText(
        findTextFormFieldByLabel('Email Address'),
        'john@test.com',
      );
      await tester.enterText(
        findTextFormFieldByLabel('Password'),
        'password123',
      );
      await tester.enterText(
        findTextFormFieldByLabel('Confirm Password'),
        'password123',
      );

      final termsWidget = find.byType(TermsAndConditions);
      await tester.ensureVisible(termsWidget);
      await tester.tap(termsWidget);
      await tester.pump();

      // Tap signup
      final signupButton = find.widgetWithText(GenericButton, 'Sign Up');
      await tester.ensureVisible(signupButton);
      await tester.tap(signupButton);
      await tester.pumpAndSettle();

      expect(find.text('Account Screen Reached'), findsOneWidget);
    });

    testWidgets('signup without terms shows error snackbar', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final fakeRepo = _FakeAuthRepository();

      await tester.pumpWidget(
        createTestApp(
          child: const SignupPage(),
          overrides: [authRepositoryProvider.overrideWithValue(fakeRepo)],
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(findTextFormFieldByLabel('First Name'), 'John');
      await tester.enterText(findTextFormFieldByLabel('Last Name'), 'Doe');
      await tester.enterText(
        findTextFormFieldByLabel('Email Address'),
        'john@test.com',
      );
      await tester.enterText(
        findTextFormFieldByLabel('Password'),
        'password123',
      );
      await tester.enterText(
        findTextFormFieldByLabel('Confirm Password'),
        'password123',
      );

      // Tap signup without checking terms
      final signupButton = find.widgetWithText(GenericButton, 'Sign Up');
      await tester.ensureVisible(signupButton);
      await tester.tap(signupButton);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('failed signup shows error snackbar', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final fakeRepo = _FakeAuthRepository()..shouldFail = true;

      await tester.pumpWidget(
        createTestApp(
          child: const SignupPage(),
          overrides: [authRepositoryProvider.overrideWithValue(fakeRepo)],
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(findTextFormFieldByLabel('First Name'), 'John');
      await tester.enterText(findTextFormFieldByLabel('Last Name'), 'Doe');
      await tester.enterText(
        findTextFormFieldByLabel('Email Address'),
        'john@test.com',
      );
      await tester.enterText(
        findTextFormFieldByLabel('Password'),
        'password123',
      );
      await tester.enterText(
        findTextFormFieldByLabel('Confirm Password'),
        'password123',
      );

      final termsWidget2 = find.byType(TermsAndConditions);
      await tester.ensureVisible(termsWidget2);
      await tester.tap(termsWidget2);
      await tester.pump();

      final signupButton = find.widgetWithText(GenericButton, 'Sign Up');
      await tester.ensureVisible(signupButton);
      await tester.tap(signupButton);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
