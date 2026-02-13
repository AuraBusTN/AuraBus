import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/common/widgets/generic_button.dart';

void main() {
  group('GenericButton', () {
    testWidgets('renders the text label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: GenericButton(textLabel: 'Login')),
        ),
      );

      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('calls onPressed on tap', (tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GenericButton(
              textLabel: 'Submit',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Submit'));
      expect(pressed, isTrue);
    });

    testWidgets('uses ElevatedButton', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: GenericButton(textLabel: 'Test')),
        ),
      );

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('has full width', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: GenericButton(textLabel: 'Wide')),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, double.infinity);
      expect(sizedBox.height, 55);
    });

    testWidgets('works with null onPressed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: GenericButton(textLabel: 'Default')),
        ),
      );

      await tester.tap(find.text('Default'));
    });
  });
}
