import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/common/widgets/custom_text_field.dart';

void main() {
  group('CustomTextField', () {
    testWidgets('renders label text', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Email',
              icon: Icons.email_outlined,
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('renders icon', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Password',
              icon: Icons.lock_outline,
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('accepts text input', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Name',
              icon: Icons.person,
              controller: controller,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'John');
      expect(controller.text, 'John');
    });

    testWidgets('shows validation error', (tester) async {
      final controller = TextEditingController();
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: CustomTextField(
                label: 'Email',
                icon: Icons.email,
                controller: controller,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Required' : null,
              ),
            ),
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Required'), findsOneWidget);
    });

    testWidgets('obscures text when obscureText is true', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Password',
              icon: Icons.lock,
              controller: controller,
              obscureText: true,
            ),
          ),
        ),
      );

      final editableText = tester.widget<EditableText>(
        find.byType(EditableText),
      );
      expect(editableText.obscureText, isTrue);
    });

    testWidgets('uses specified keyboardType', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Email',
              icon: Icons.email,
              controller: controller,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        ),
      );

      final editableText = tester.widget<EditableText>(
        find.byType(EditableText),
      );
      expect(editableText.keyboardType, TextInputType.emailAddress);
    });
  });
}
