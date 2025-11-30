import 'package:aurabus/features/signup/presentation/signup_page.dart';
import 'package:aurabus/common/widgets/generic_button.dart';
import 'package:aurabus/features/signup/widgets/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../utils/test_app_wrapper.dart';
import '../../utils/device_definitions.dart';

void main() {
  group('SignupPage Functional Tests', () {
    testWidgets('Validation: Required fields check', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestApp(child: const SignupPage()));
      await tester.pumpAndSettle();

      final signUpButton = find.widgetWithText(GenericButton, 'Sign Up');
      await tester.ensureVisible(signUpButton);
      await tester.tap(signUpButton);
      await tester.pump();

      expect(find.text('Required'), findsAtLeastNWidgets(2));

      if (find.text('Invalid Email').evaluate().isNotEmpty) {
        expect(find.text('Invalid Email'), findsOneWidget);
      }
    });

    testWidgets('Logic: Password Mismatch & Terms Check', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestApp(child: const SignupPage()));
      await tester.pumpAndSettle();

      await tester.enterText(findTextFormFieldByLabel('First Name'), 'Test');
      await tester.enterText(findTextFormFieldByLabel('Last Name'), 'User');
      await tester.enterText(
        findTextFormFieldByLabel('Email Address'),
        'test@email.com',
      );

      await tester.enterText(findTextFormFieldByLabel('Password'), '123456');
      await tester.enterText(
        findTextFormFieldByLabel('Confirm Password'),
        '654321',
      );

      final signUpButton = find.widgetWithText(GenericButton, 'Sign Up');
      await tester.ensureVisible(signUpButton);
      await tester.tap(signUpButton);
      await tester.pump();

      expect(find.text('Mismatch'), findsOneWidget);

      await tester.enterText(
        findTextFormFieldByLabel('Confirm Password'),
        '123456',
      );

      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      expect(find.text('Please accept terms and conditions'), findsOneWidget);
    });
  });

  group('SignupPage Responsiveness Tests', () {
    for (var device in TestDevices.all) {
      testWidgets('Renders fully interactable on ${device.name}', (
        tester,
      ) async {
        tester.view.physicalSize = device.size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(createTestApp(child: const SignupPage()));
        await tester.pumpAndSettle();

        expect(find.text('Create Account'), findsOneWidget);

        final loginLink = find.text('Login');
        await tester.ensureVisible(loginLink);
        expect(loginLink, findsOneWidget);

        final termsWidget = find.byType(TermsAndConditions);
        await tester.ensureVisible(termsWidget);
        expect(termsWidget, findsOneWidget);

        await tester.tap(termsWidget);
        await tester.pumpAndSettle();
      });
    }
  });
}
