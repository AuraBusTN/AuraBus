import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/account/widgets/subscription_body.dart';
import 'package:aurabus/l10n/app_localizations.dart';

void main() {
  Widget buildWidget() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: const Scaffold(body: SubscriptionBody()),
    );
  }

  group('SubscriptionBody', () {
    testWidgets('renders subscription card title', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('LIBERA CIRCOLAZIONE UNITN'), findsAtLeast(1));
    });

    testWidgets('renders QR code icon', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.qr_code_2_rounded), findsOneWidget);
    });

    testWidgets('renders subscription code', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('00000'), findsOneWidget);
    });

    testWidgets('renders status label and valid status', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Valid'), findsOneWidget);
      expect(find.text('Status:'), findsOneWidget);
    });

    testWidgets('renders start date', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('01/09/2025'), findsOneWidget);
    });

    testWidgets('renders expiration date', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('31/08/2026'), findsOneWidget);
    });

    testWidgets('renders all info rows', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Row), findsAtLeast(4));
    });
  });
}
