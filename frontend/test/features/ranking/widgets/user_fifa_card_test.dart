import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/ranking/domain/rank_tier.dart';
import 'package:aurabus/features/ranking/presentation/widgets/user_fifa_card.dart';
import 'package:aurabus/l10n/app_localizations.dart';

void main() {
  Widget buildWidget({
    required RankTier current,
    required RankTier next,
    required int points,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(
        body: SingleChildScrollView(
          child: UserFifaCard(current: current, next: next, points: points),
        ),
      ),
    );
  }

  group('UserFifaCard', () {
    testWidgets('renders with bronze tier', (tester) async {
      final info = RankTier.getTierInfo(500);
      await tester.pumpWidget(
        buildWidget(current: info.current, next: info.next, points: 500),
      );
      await tester.pumpAndSettle();

      expect(find.text('BRONZE'), findsOneWidget);
      expect(find.text('500'), findsOneWidget);
    });

    testWidgets('renders with silver tier', (tester) async {
      final info = RankTier.getTierInfo(1200);
      await tester.pumpWidget(
        buildWidget(current: info.current, next: info.next, points: 1200),
      );
      await tester.pumpAndSettle();

      expect(find.text('SILVER'), findsOneWidget);
      expect(find.text('1200'), findsOneWidget);
    });

    testWidgets('renders with gold tier', (tester) async {
      final info = RankTier.getTierInfo(1700);
      await tester.pumpWidget(
        buildWidget(current: info.current, next: info.next, points: 1700),
      );
      await tester.pumpAndSettle();

      expect(find.text('GOLD'), findsOneWidget);
      expect(find.text('1700'), findsOneWidget);
    });

    testWidgets('shows next tier info when not max', (tester) async {
      final info = RankTier.getTierInfo(500);
      await tester.pumpWidget(
        buildWidget(current: info.current, next: info.next, points: 500),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('500'), findsAtLeast(1));
    });

    testWidgets('shows max level reached at elite', (tester) async {
      final info = RankTier.getTierInfo(2500);
      await tester.pumpWidget(
        buildWidget(current: info.current, next: info.next, points: 2500),
      );
      await tester.pumpAndSettle();

      expect(find.text('ELITE'), findsOneWidget);
      expect(find.text('Max level reached!'), findsOneWidget);
    });

    testWidgets('renders progress bar when not max', (tester) async {
      final info = RankTier.getTierInfo(750);
      await tester.pumpWidget(
        buildWidget(current: info.current, next: info.next, points: 750),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('does not render progress bar at max level', (tester) async {
      final info = RankTier.getTierInfo(3000);
      await tester.pumpWidget(
        buildWidget(current: info.current, next: info.next, points: 3000),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LinearProgressIndicator), findsNothing);
    });

    testWidgets('renders shield icon', (tester) async {
      final info = RankTier.getTierInfo(0);
      await tester.pumpWidget(
        buildWidget(current: info.current, next: info.next, points: 0),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.shield), findsOneWidget);
    });

    testWidgets('renders YOUR TIER label', (tester) async {
      final info = RankTier.getTierInfo(100);
      await tester.pumpWidget(
        buildWidget(current: info.current, next: info.next, points: 100),
      );
      await tester.pumpAndSettle();

      expect(find.text('YOUR TIER'), findsOneWidget);
    });

    testWidgets('renders POINTS label', (tester) async {
      final info = RankTier.getTierInfo(100);
      await tester.pumpWidget(
        buildWidget(current: info.current, next: info.next, points: 100),
      );
      await tester.pumpAndSettle();

      expect(find.text('POINTS'), findsOneWidget);
    });
  });
}
