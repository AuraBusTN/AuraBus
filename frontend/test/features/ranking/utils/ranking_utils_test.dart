import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/ranking/presentation/utils/ranking_utils.dart';
import 'package:aurabus/features/ranking/domain/rank_tier.dart';
import 'package:aurabus/l10n/app_localizations.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(body: child),
    );
  }

  group('RankingUtils.getTierName', () {
    testWidgets('returns Elite for TierType.elite', (tester) async {
      late String result;
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) {
              result = RankingUtils.getTierName(context, TierType.elite);
              return Text(result);
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(result, 'Elite');
    });

    testWidgets('returns Gold for TierType.gold', (tester) async {
      late String result;
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) {
              result = RankingUtils.getTierName(context, TierType.gold);
              return Text(result);
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(result, 'Gold');
    });

    testWidgets('returns Silver for TierType.silver', (tester) async {
      late String result;
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) {
              result = RankingUtils.getTierName(context, TierType.silver);
              return Text(result);
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(result, 'Silver');
    });

    testWidgets('returns Bronze for TierType.bronze', (tester) async {
      late String result;
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) {
              result = RankingUtils.getTierName(context, TierType.bronze);
              return Text(result);
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(result, 'Bronze');
    });

    testWidgets('returns Max for TierType.max', (tester) async {
      late String result;
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) {
              result = RankingUtils.getTierName(context, TierType.max);
              return Text(result);
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(result, 'Max');
    });
  });

  group('RankingUtils.getTierReward', () {
    testWidgets('returns Annual pass for elite', (tester) async {
      late String result;
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) {
              result = RankingUtils.getTierReward(context, TierType.elite);
              return Text(result);
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(result, 'Annual Subscription');
    });

    testWidgets('returns Monthly Subscription for gold', (tester) async {
      late String result;
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) {
              result = RankingUtils.getTierReward(context, TierType.gold);
              return Text(result);
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(result, 'Monthly Subscription');
    });

    testWidgets('returns 10 Free Rides for silver', (tester) async {
      late String result;
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) {
              result = RankingUtils.getTierReward(context, TierType.silver);
              return Text(result);
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(result, '10 Free Rides');
    });

    testWidgets('returns 2 Free Rides for bronze', (tester) async {
      late String result;
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) {
              result = RankingUtils.getTierReward(context, TierType.bronze);
              return Text(result);
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(result, '2 Free Rides');
    });

    testWidgets('returns empty string for max', (tester) async {
      late String result;
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) {
              result = RankingUtils.getTierReward(context, TierType.max);
              return Text(result);
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(result, '');
    });
  });
}
