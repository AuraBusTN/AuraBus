import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/auth/data/models/user_model.dart';
import 'package:aurabus/features/ranking/presentation/widgets/leaderboard_list.dart';
import 'package:aurabus/l10n/app_localizations.dart';

void main() {
  Widget buildWidget({
    required List<User> users,
    User? meOutsideTop10,
    String? myId,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(
        body: SingleChildScrollView(
          child: LeaderboardList(
            users: users,
            meOutsideTop10: meOutsideTop10,
            myId: myId,
          ),
        ),
      ),
    );
  }

  final testUsers = [
    User(
      id: '1',
      firstName: 'Mario',
      lastName: 'Rossi',
      email: 'a@a.com',
      points: 2000,
      rank: 1,
    ),
    User(
      id: '2',
      firstName: 'Luigi',
      lastName: 'Verdi',
      email: 'b@b.com',
      points: 1500,
      rank: 2,
    ),
    User(
      id: '3',
      firstName: 'Anna',
      lastName: 'Bianchi',
      email: 'c@c.com',
      points: 1000,
      rank: 3,
    ),
    User(
      id: '4',
      firstName: 'Paolo',
      lastName: 'Neri',
      email: 'd@d.com',
      points: 500,
      rank: 4,
    ),
  ];

  group('LeaderboardList', () {
    testWidgets('renders all user names', (tester) async {
      await tester.pumpWidget(buildWidget(users: testUsers));
      await tester.pumpAndSettle();

      expect(find.text('Mario'), findsOneWidget);
      expect(find.text('Luigi'), findsOneWidget);
      expect(find.text('Anna'), findsOneWidget);
      expect(find.text('Paolo'), findsOneWidget);
    });

    testWidgets('renders rank numbers', (tester) async {
      await tester.pumpWidget(buildWidget(users: testUsers));
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('renders points for each user', (tester) async {
      await tester.pumpWidget(buildWidget(users: testUsers));
      await tester.pumpAndSettle();

      expect(find.textContaining('2000'), findsAtLeast(1));
      expect(find.textContaining('1500'), findsAtLeast(1));
      expect(find.textContaining('1000'), findsAtLeast(1));
      expect(find.textContaining('500'), findsAtLeast(1));
    });

    testWidgets('highlights current user with (You)', (tester) async {
      await tester.pumpWidget(buildWidget(users: testUsers, myId: '2'));
      await tester.pumpAndSettle();

      expect(find.textContaining('(You)'), findsOneWidget);
      expect(find.text('Luigi (You)'), findsOneWidget);
    });

    testWidgets('renders meOutsideTop10 with separator', (tester) async {
      final meOutside = User(
        id: '99',
        firstName: 'TestMe',
        lastName: 'Last',
        email: 'me@me.com',
        points: 50,
        rank: 42,
      );

      await tester.pumpWidget(
        buildWidget(users: testUsers, meOutsideTop10: meOutside, myId: '99'),
      );
      await tester.pumpAndSettle();

      expect(find.text('TestMe (You)'), findsOneWidget);
      expect(find.text('42'), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('does not show meOutsideTop10 section when null', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(users: testUsers));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.more_vert), findsNothing);
    });

    testWidgets('renders with empty users list', (tester) async {
      await tester.pumpWidget(buildWidget(users: []));
      await tester.pumpAndSettle();

      expect(find.byType(LeaderboardList), findsOneWidget);
    });

    testWidgets('renders ListTile for each user', (tester) async {
      await tester.pumpWidget(buildWidget(users: testUsers));
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsNWidgets(4));
    });
  });
}
