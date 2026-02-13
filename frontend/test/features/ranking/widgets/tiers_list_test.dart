import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/ranking/presentation/widgets/tiers_list.dart';
import 'package:aurabus/l10n/app_localizations.dart';

void main() {
  Widget buildWidget({required int userPoints}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(
        body: SingleChildScrollView(child: TiersList(userPoints: userPoints)),
      ),
    );
  }

  group('TiersList', () {
    testWidgets('renders all 4 tier names', (tester) async {
      await tester.pumpWidget(buildWidget(userPoints: 0));
      await tester.pumpAndSettle();

      expect(find.text('Elite'), findsOneWidget);
      expect(find.text('Gold'), findsOneWidget);
      expect(find.text('Silver'), findsOneWidget);
      expect(find.text('Bronze'), findsOneWidget);
    });

    testWidgets('renders rewards for each tier', (tester) async {
      await tester.pumpWidget(buildWidget(userPoints: 0));
      await tester.pumpAndSettle();

      expect(find.text('Annual Subscription'), findsOneWidget);
      expect(find.text('Monthly Subscription'), findsOneWidget);
      expect(find.text('10 Free Rides'), findsOneWidget);
      expect(find.text('2 Free Rides'), findsOneWidget);
    });

    testWidgets('shows check_circle for achieved tiers', (tester) async {
      await tester.pumpWidget(buildWidget(userPoints: 1500));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle), findsNWidgets(3));
    });

    testWidgets('shows lock_outline for unachieved tiers', (tester) async {
      await tester.pumpWidget(buildWidget(userPoints: 1500));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('0 points shows only bronze achieved', (tester) async {
      await tester.pumpWidget(buildWidget(userPoints: 0));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsNWidgets(3));
    });

    testWidgets('all tiers achieved at 2000+ points', (tester) async {
      await tester.pumpWidget(buildWidget(userPoints: 2000));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle), findsNWidgets(4));
      expect(find.byIcon(Icons.lock_outline), findsNothing);
    });

    testWidgets('renders 4 tier containers', (tester) async {
      await tester.pumpWidget(buildWidget(userPoints: 0));
      await tester.pumpAndSettle();

      expect(find.text('Elite'), findsOneWidget);
      expect(find.text('Gold'), findsOneWidget);
      expect(find.text('Silver'), findsOneWidget);
      expect(find.text('Bronze'), findsOneWidget);
    });
  });
}
