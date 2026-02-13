import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aurabus/features/tickets/presentation/ticket_page.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:aurabus/theme.dart';

void main() {
  Widget buildWidget() {
    return ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: AppTheme.lightTheme,
        home: const TicketPage(),
      ),
    );
  }

  group('TicketPage', () {
    testWidgets('renders title "My Tickets"', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('My Tickets'), findsOneWidget);
    });

    testWidgets('renders 3 TicketCard widgets', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('TRENTO'), findsNWidgets(3));
    });

    testWidgets('renders in a scrollable view', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('renders Scaffold', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('renders SafeArea', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SafeArea), findsOneWidget);
    });
  });
}
