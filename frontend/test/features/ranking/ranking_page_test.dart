import 'package:aurabus/features/auth/data/models/user_model.dart';
import 'package:aurabus/features/auth/presentation/providers/auth_provider.dart';
import 'package:aurabus/features/ranking/data/models/leaderboard_data.dart';
import 'package:aurabus/features/ranking/presentation/providers/leaderboard_provider.dart';
import 'package:aurabus/features/ranking/presentation/ranking_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import '../../utils/device_definitions.dart';

final mockUser = User(
  id: '1',
  firstName: 'Test',
  lastName: 'User',
  email: 'test@test.com',
  points: 1500,
);

final mockLeaderboardData = LeaderboardData(
  topUsers: [
    User(
      id: '2',
      firstName: 'Top',
      lastName: 'One',
      email: '',
      points: 3000,
      rank: 1,
    ),
    User(
      id: '1',
      firstName: 'Test',
      lastName: 'User',
      email: '',
      points: 1500,
      rank: 2,
    ),
  ],
  me: null,
);

void main() {
  Widget createRankingPage(List overrides) {
    return ProviderScope(
      overrides: overrides.cast(),
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: RankingPage(),
      ),
    );
  }

  group('RankingPage Functional Tests', () {
    testWidgets('RankingPage shows user points and leaderboard list', (
      tester,
    ) async {
      await tester.pumpWidget(
        createRankingPage([
          authProvider.overrideWith(() => FakeAuthNotifier(mockUser)),
          leaderboardProvider.overrideWith(
            (ref) => Future.value(mockLeaderboardData),
          ),
        ]),
      );

      await tester.pumpAndSettle();

      expect(find.text('1500'), findsOneWidget);
      expect(find.text('Top'), findsOneWidget);
    });
  });

  group('RankingPage Responsiveness Tests', () {
    for (var device in TestDevices.all) {
      testWidgets(
        'Renders correctly on ${device.name} (${device.size.width}x${device.size.height})',
        (tester) async {
          tester.view.physicalSize = device.size;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);

          await tester.pumpWidget(
            createRankingPage([
              authProvider.overrideWith(() => FakeAuthNotifier(mockUser)),
              leaderboardProvider.overrideWith(
                (ref) => Future.value(mockLeaderboardData),
              ),
            ]),
          );

          await tester.pumpAndSettle();

          expect(find.text('1500'), findsOneWidget);
          expect(find.text('Top'), findsOneWidget);
        },
      );
    }
  });
}

class FakeAuthNotifier extends AuthNotifier {
  final User _user;
  FakeAuthNotifier(this._user);

  @override
  AuthState build() => AuthState(isAuthenticated: true, user: _user);
}
