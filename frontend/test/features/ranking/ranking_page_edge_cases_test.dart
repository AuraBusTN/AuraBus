import 'package:aurabus/features/auth/data/models/user_model.dart';
import 'package:aurabus/features/auth/presentation/providers/auth_provider.dart';
import 'package:aurabus/features/ranking/data/models/leaderboard_data.dart';
import 'package:aurabus/features/ranking/presentation/providers/leaderboard_provider.dart';
import 'package:aurabus/features/ranking/presentation/ranking_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:aurabus/theme.dart';
import '../../utils/test_app_wrapper.dart';

final mockUser = User(
  id: '1',
  firstName: 'Test',
  lastName: 'User',
  email: 'test@test.com',
  points: 1500,
);

class _FakeAuthNotifier extends AuthNotifier {
  final User? _user;
  _FakeAuthNotifier(this._user);

  @override
  AuthState build() => AuthState(isAuthenticated: _user != null, user: _user);
}

void main() {
  Widget createRankingPage(List<Override> overrides) {
    return createTestApp(child: const RankingPage(), overrides: overrides);
  }

  group('RankingPage edge cases', () {
    testWidgets('shows empty leaderboard message when no users', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createRankingPage([
          authProvider.overrideWith(() => _FakeAuthNotifier(mockUser)),
          leaderboardProvider.overrideWith(
            (ref) => Future.value(LeaderboardData(topUsers: [])),
          ),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.text('No users in the leaderboard yet.'), findsOneWidget);
    });

    testWidgets('shows error container when leaderboard fetch fails', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createRankingPage([
          authProvider.overrideWith(() => _FakeAuthNotifier(mockUser)),
          leaderboardProvider.overrideWith(
            (ref) => Future<LeaderboardData>.error('Network error'),
          ),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Network error'), findsOneWidget);
    });

    testWidgets('back button is present and functional', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      late GoRouter router;
      router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(body: Text('Home')),
            routes: [
              GoRoute(
                path: 'ranking',
                builder: (context, state) => const RankingPage(),
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith(() => _FakeAuthNotifier(mockUser)),
            leaderboardProvider.overrideWith(
              (ref) => Future.value(
                LeaderboardData(
                  topUsers: [
                    User(
                      id: '2',
                      firstName: 'Alice',
                      lastName: 'B',
                      email: '',
                      points: 3000,
                      rank: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
          child: MaterialApp.router(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            theme: AppTheme.lightTheme,
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      router.go('/ranking');
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.byType(RankingPage), findsNothing);
      expect(find.text('Home'), findsOneWidget);
    });
  });
}
