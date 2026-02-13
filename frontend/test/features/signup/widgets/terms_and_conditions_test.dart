import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/signup/widgets/terms_and_conditions.dart';
import '../../../utils/test_app_wrapper.dart';

void main() {
  group('TermsAndConditions Widget Tests', () {
    testWidgets('renders widget and RichText with terms content', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createTestApp(
          child: TermsAndConditions(isChecked: false, onChanged: (_) {}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TermsAndConditions), findsOneWidget);
      expect(find.byType(RichText), findsAtLeastNWidgets(1));
    });

    testWidgets('renders check icon when checked', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createTestApp(
          child: TermsAndConditions(isChecked: true, onChanged: (_) {}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('does not render check icon when unchecked', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createTestApp(
          child: TermsAndConditions(isChecked: false, onChanged: (_) {}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('tapping the widget area calls onChanged with toggled value', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      dynamic changedValue;
      await tester.pumpWidget(
        createTestApp(
          child: TermsAndConditions(
            isChecked: false,
            onChanged: (v) => changedValue = v,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final rect = tester.getRect(find.byType(TermsAndConditions));
      await tester.tapAt(Offset(rect.left + 20, rect.center.dy));
      expect(changedValue, isTrue);
    });

    testWidgets('has animated containers for styling', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createTestApp(
          child: TermsAndConditions(isChecked: false, onChanged: (_) {}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AnimatedContainer), findsAtLeastNWidgets(2));
    });

    testWidgets('checked state changes checkbox circle appearance', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createTestApp(
          child: TermsAndConditions(isChecked: false, onChanged: (_) {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.check), findsNothing);

      await tester.pumpWidget(
        createTestApp(
          child: TermsAndConditions(isChecked: true, onChanged: (_) {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('tapping checked widget calls onChanged with false', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      dynamic changedValue;
      await tester.pumpWidget(
        createTestApp(
          child: TermsAndConditions(
            isChecked: true,
            onChanged: (v) => changedValue = v,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final rect = tester.getRect(find.byType(TermsAndConditions));
      await tester.tapAt(Offset(rect.left + 20, rect.center.dy));
      expect(changedValue, isFalse);
    });

    testWidgets('RichText contains Terms and Privacy text spans', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createTestApp(
          child: TermsAndConditions(isChecked: false, onChanged: (_) {}),
        ),
      );
      await tester.pumpAndSettle();

      final richTextFinder = find.descendant(
        of: find.byType(TermsAndConditions),
        matching: find.byType(RichText),
      );
      expect(richTextFinder, findsOneWidget);

      final RichText richText = tester.widget(richTextFinder);
      final TextSpan span = richText.text as TextSpan;
      expect(span.children, isNotNull);
      expect(
        span.children!.length,
        4,
      ); // termsText, termsLink, andText, privacyLink

      final termsSpan = span.children![1] as TextSpan;
      final privacySpan = span.children![3] as TextSpan;
      expect(termsSpan.text, 'Terms & Conditions');
      expect(privacySpan.text, 'Privacy Policy');

      expect(termsSpan.style?.decoration, TextDecoration.underline);
      expect(privacySpan.style?.decoration, TextDecoration.underline);

      expect(termsSpan.style?.fontWeight, FontWeight.bold);
      expect(privacySpan.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('Terms and Privacy links have TapGestureRecognizer', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createTestApp(
          child: TermsAndConditions(isChecked: false, onChanged: (_) {}),
        ),
      );
      await tester.pumpAndSettle();

      final richTextFinder = find.descendant(
        of: find.byType(TermsAndConditions),
        matching: find.byType(RichText),
      );
      final RichText richText = tester.widget(richTextFinder);
      final TextSpan span = richText.text as TextSpan;

      final termsSpan = span.children![1] as TextSpan;
      expect(termsSpan.recognizer, isNotNull);

      final privacySpan = span.children![3] as TextSpan;
      expect(privacySpan.recognizer, isNotNull);
    });

    testWidgets('widget structure is correct with Row layout', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createTestApp(
          child: TermsAndConditions(isChecked: false, onChanged: (_) {}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(GestureDetector), findsAtLeastNWidgets(1));
      expect(
        find.descendant(
          of: find.byType(TermsAndConditions),
          matching: find.byType(Row),
        ),
        findsOneWidget,
      );
    });
  });
}
