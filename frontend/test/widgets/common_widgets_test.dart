import 'package:aurabus/common/widgets/custom_text_field.dart';
import 'package:aurabus/common/widgets/generic_button.dart';
import 'package:aurabus/common/widgets/clickable_text.dart';
import 'package:aurabus/common/widgets/fade_in_slide.dart';
import 'package:aurabus/common/widgets/google_button.dart';
import 'package:aurabus/l10n/app_localizations.dart';
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
            body: GenericButton(
              textLabel: 'Click Me',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);

      await tester.tap(find.byType(GenericButton));
      expect(pressed, isTrue);
    });

    testWidgets('ClickableText renders text and responds to tap', (
      tester,
    ) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClickableText(
              textLabel: 'Forgot Password?',
              fun: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Forgot Password?'), findsOneWidget);

      await tester.tap(find.text('Forgot Password?'));
      expect(pressed, isTrue);
    });

    testWidgets('FadeInSlide animates opacity and position over time', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FadeInSlide(delay: 0.1, child: Text('Animated Content')),
          ),
        ),
      );

      final fadeTransitionFinder = find.descendant(
        of: find.byType(FadeInSlide),
        matching: find.byType(FadeTransition),
      );

      expect(
        tester.widget<FadeTransition>(fadeTransitionFinder).opacity.value,
        0.0,
      );

      await tester.pump(const Duration(milliseconds: 150));

      await tester.pump(const Duration(milliseconds: 200));

      final fadeWidgetMid = tester.widget<FadeTransition>(fadeTransitionFinder);
      expect(fadeWidgetMid.opacity.value, greaterThan(0.0));
      expect(fadeWidgetMid.opacity.value, lessThan(1.0));

      await tester.pump(const Duration(milliseconds: 2000));

      expect(
        tester.widget<FadeTransition>(fadeTransitionFinder).opacity.value,
        1.0,
      );
    });

    testWidgets('GoogleButton renders localized text and responds to tap', (
      tester,
    ) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(body: GoogleButton(onPressed: () => pressed = true)),
        ),
      );

      expect(find.text('Sign in with Google'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      await tester.tap(find.byType(GoogleButton));
      expect(pressed, isTrue);
    });
  });
}
