import 'package:aurabus/features/login/widgets/custom_text_field.dart';
import 'package:aurabus/features/login/widgets/generic_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Common Widgets Tests', () {
    testWidgets('CustomTextField renders label and accepts input', (
      tester,
    ) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              label: 'Test Label',
              icon: Icons.person,
            ),
          ),
        ),
      );

      expect(find.text('Test Label'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'Hello World');
      expect(controller.text, 'Hello World');
    });

    testWidgets('CustomTextField shows validation error', (tester) async {
      final controller = TextEditingController();
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: CustomTextField(
                controller: controller,
                label: 'Email',
                icon: Icons.email,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Error Required' : null,
              ),
            ),
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Error Required'), findsOneWidget);
    });

    testWidgets('GenericButton renders text and responds to tap', (
      tester,
    ) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Genericbutton(
              textlabel: 'Click Me',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);

      await tester.tap(find.byType(Genericbutton));
      expect(pressed, isTrue);
    });
  });
}
