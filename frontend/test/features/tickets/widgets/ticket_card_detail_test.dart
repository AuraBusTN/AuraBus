import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/tickets/widgets/ticket_card.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:aurabus/theme.dart';

void main() {
  Widget buildWidget() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      theme: AppTheme.lightTheme,
      home: const Scaffold(body: SingleChildScrollView(child: TicketCard())),
    );
  }

  group('TicketCard', () {
    testWidgets('renders urban service text', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Urban Service'), findsOneWidget);
    });

    testWidgets('renders city name', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('TRENTO'), findsOneWidget);
    });

    testWidgets('renders validate action button', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Validate'), findsOneWidget);
    });

    testWidgets('renders ticket status', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('UNUSED'), findsOneWidget);
    });

    testWidgets('renders ticket duration pill', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('70 minutes'), findsOneWidget);
    });

    testWidgets('renders ticket price pill', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('€ 1.20'), findsOneWidget);
    });

    testWidgets('renders VAT text', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.textContaining('VAT'), findsOneWidget);
    });

    testWidgets('renders divider', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Divider), findsAtLeast(1));
    });

    testWidgets('renders logo image or fallback', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsAtLeast(1));
    });
  });
}
