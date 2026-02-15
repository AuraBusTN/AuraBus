import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/common/widgets/clickable_text.dart';

void main() {
  group('ClickableText', () {
    testWidgets('renders the text label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClickableText(textLabel: 'Forgot Password?', fun: () {}),
          ),
        ),
      );

      expect(find.text('Forgot Password?'), findsOneWidget);
    });

    testWidgets('calls fun on tap', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClickableText(
              textLabel: 'Click me',
              fun: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Click me'));
      expect(tapped, isTrue);
    });

    testWidgets('has GestureDetector', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClickableText(textLabel: 'Test', fun: () {}),
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsOneWidget);
    });
  });
}
