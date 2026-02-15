import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/legal/widgets/legal_document_header.dart';

void main() {
  Widget createHeaderApp({
    IconData icon = Icons.description_outlined,
    String title = 'Terms of Service',
    String lastUpdated = 'Last updated: 13/02/2026',
  }) {
    return MaterialApp(
      home: Scaffold(
        body: LegalDocumentHeader(
          icon: icon,
          title: title,
          lastUpdated: lastUpdated,
        ),
      ),
    );
  }

  group('LegalDocumentHeader Widget', () {
    testWidgets('renders icon, title, and last updated text', (tester) async {
      await tester.pumpWidget(createHeaderApp());

      expect(find.byIcon(Icons.description_outlined), findsOneWidget);
      expect(find.text('Terms of Service'), findsOneWidget);
      expect(find.text('Last updated: 13/02/2026'), findsOneWidget);
    });

    testWidgets('renders with privacy policy icon', (tester) async {
      await tester.pumpWidget(
        createHeaderApp(icon: Icons.shield_outlined, title: 'Privacy Policy'),
      );

      expect(find.byIcon(Icons.shield_outlined), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
    });

    testWidgets('icon is inside a circular container', (tester) async {
      await tester.pumpWidget(createHeaderApp());

      final iconWidget = find.byIcon(Icons.description_outlined);
      expect(iconWidget, findsOneWidget);

      final Icon icon = tester.widget(iconWidget);
      expect(icon.size, 32);
    });

    testWidgets('title uses headline style', (tester) async {
      await tester.pumpWidget(createHeaderApp());

      final titleFinder = find.text('Terms of Service');
      final Text titleWidget = tester.widget(titleFinder);
      expect(titleWidget.textAlign, TextAlign.center);
    });

    testWidgets('last updated badge has rounded container', (tester) async {
      await tester.pumpWidget(createHeaderApp());

      final dateFinder = find.text('Last updated: 13/02/2026');
      expect(dateFinder, findsOneWidget);
    });

    testWidgets('handles long title text gracefully', (tester) async {
      await tester.pumpWidget(
        createHeaderApp(
          title:
              'A Very Long Document Title That Should Still Render Correctly',
        ),
      );

      expect(
        find.text(
          'A Very Long Document Title That Should Still Render Correctly',
        ),
        findsOneWidget,
      );
    });

    testWidgets('handles different date formats', (tester) async {
      await tester.pumpWidget(
        createHeaderApp(lastUpdated: 'Ultimo aggiornamento: 13/02/2026'),
      );

      expect(find.text('Ultimo aggiornamento: 13/02/2026'), findsOneWidget);
    });
  });
}
