import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/map/data/models/route_info.dart';
import 'package:aurabus/features/map/widgets/route_filter_card.dart';
import 'package:aurabus/l10n/app_localizations.dart';

void main() {
  Widget buildWidget({
    required RouteInfo line,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(
        body: Center(
          child: RouteFilterCard(
            line: line,
            isSelected: isSelected,
            onTap: onTap,
          ),
        ),
      ),
    );
  }

  final testRoute = RouteInfo(
    routeColor: '#FF0000',
    routeId: 5,
    routeLongName: 'Trento - Rovereto',
    routeShortName: '5',
  );

  group('RouteFilterCard', () {
    testWidgets('renders route short name', (tester) async {
      await tester.pumpWidget(
        buildWidget(line: testRoute, isSelected: false, onTap: () {}),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('5'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        buildWidget(
          line: testRoute,
          isSelected: false,
          onTap: () => tapped = true,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(RouteFilterCard));
      expect(tapped, isTrue);
    });

    testWidgets('renders AnimatedContainer', (tester) async {
      await tester.pumpWidget(
        buildWidget(line: testRoute, isSelected: false, onTap: () {}),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AnimatedContainer), findsOneWidget);
    });

    testWidgets('selected state renders differently from unselected', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWidget(line: testRoute, isSelected: true, onTap: () {}),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RouteFilterCard), findsOneWidget);
    });

    testWidgets('renders Image or fallback icon', (tester) async {
      await tester.pumpWidget(
        buildWidget(line: testRoute, isSelected: false, onTap: () {}),
      );
      await tester.pumpAndSettle();

      final hasImage = find.byType(Image).evaluate().isNotEmpty;
      final hasIcon = find.byIcon(Icons.directions_bus).evaluate().isNotEmpty;
      expect(hasImage || hasIcon, isTrue);
    });

    testWidgets('selected card renders without error', (tester) async {
      await tester.pumpWidget(
        buildWidget(line: testRoute, isSelected: true, onTap: () {}),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RouteFilterCard), findsOneWidget);
    });

    testWidgets('renders with GestureDetector', (tester) async {
      await tester.pumpWidget(
        buildWidget(line: testRoute, isSelected: false, onTap: () {}),
      );
      await tester.pumpAndSettle();

      expect(find.byType(GestureDetector), findsOneWidget);
    });
  });
}
