import 'package:aurabus/features/signup/presentation/signup_page.dart';
import 'package:aurabus/common/widgets/generic_button.dart';
import 'package:aurabus/features/signup/widgets/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../utils/test_app_wrapper.dart';

void main() {
  group('Terms Acceptance FormField<bool> Validator', () {
    testWidgets(
      'Validator blocks signup when terms checkbox is unchecked',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(createTestApp(child: const SignupPage()));
        await tester.pumpAndSettle();

        // Fill all required fields
        await tester.enterText(
          findTextFormFieldByLabel('First Name'),
          'John',
        );
        await tester.enterText(
          findTextFormFieldByLabel('Last Name'),
          'Doe',
        );
        await tester.enterText(
          findTextFormFieldByLabel('Email Address'),
          'john.doe@example.com',
        );
        await tester.enterText(
          findTextFormFieldByLabel('Password'),
          'password123',
        );
        await tester.enterText(
          findTextFormFieldByLabel('Confirm Password'),
          'password123',
        );

        // Verify terms checkbox is initially unchecked
        final termsWidget = find.byType(TermsAndConditions);
        expect(termsWidget, findsOneWidget);

        // Attempt to submit form without accepting terms
        final signUpButton = find.widgetWithText(GenericButton, 'Sign Up');
        await tester.ensureVisible(signUpButton);
        await tester.tap(signUpButton);
        await tester.pump();

        // Verify error message is displayed
        expect(
          find.text('Please accept terms and conditions'),
          findsOneWidget,
          reason:
              'Error message should appear when terms are not accepted during form submission',
        );
      },
    );

    testWidgets(
      'Error text is shown when form is validated with unchecked terms',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(createTestApp(child: const SignupPage()));
        await tester.pumpAndSettle();

        // Fill all required fields
        await tester.enterText(
          findTextFormFieldByLabel('First Name'),
          'Jane',
        );
        await tester.enterText(
          findTextFormFieldByLabel('Last Name'),
          'Smith',
        );
        await tester.enterText(
          findTextFormFieldByLabel('Email Address'),
          'jane.smith@example.com',
        );
        await tester.enterText(
          findTextFormFieldByLabel('Password'),
          'securepass123',
        );
        await tester.enterText(
          findTextFormFieldByLabel('Confirm Password'),
          'securepass123',
        );

        // Find and tap sign up button without accepting terms
        final signUpButton = find.widgetWithText(GenericButton, 'Sign Up');
        await tester.ensureVisible(signUpButton);
        await tester.tap(signUpButton);
        await tester.pump();

        // Verify error text appears
        final errorText = find.text('Please accept terms and conditions');
        expect(errorText, findsOneWidget);

        // Verify error text styling (red color)
        final errorWidget = tester.widget<Text>(
          find.ancestor(
            of: errorText,
            matching: find.byType(Text),
          ),
        );
        expect(errorWidget.style?.color, Colors.red);
      },
    );

    testWidgets(
      'Error text is cleared when terms checkbox is checked',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(createTestApp(child: const SignupPage()));
        await tester.pumpAndSettle();

        // Fill all required fields
        await tester.enterText(
          findTextFormFieldByLabel('First Name'),
          'Alice',
        );
        await tester.enterText(
          findTextFormFieldByLabel('Last Name'),
          'Johnson',
        );
        await tester.enterText(
          findTextFormFieldByLabel('Email Address'),
          'alice.johnson@example.com',
        );
        await tester.enterText(
          findTextFormFieldByLabel('Password'),
          'mypass123',
        );
        await tester.enterText(
          findTextFormFieldByLabel('Confirm Password'),
          'mypass123',
        );

        // Submit form without accepting terms to trigger error
        final signUpButton = find.widgetWithText(GenericButton, 'Sign Up');
        await tester.ensureVisible(signUpButton);
        await tester.tap(signUpButton);
        await tester.pump();

        // Verify error is displayed
        expect(
          find.text('Please accept terms and conditions'),
          findsOneWidget,
        );

        // Now check the terms checkbox
        final termsWidget = find.byType(TermsAndConditions);
        await tester.tap(termsWidget);
        await tester.pump();

        // Verify error text is cleared
        expect(
          find.text('Please accept terms and conditions'),
          findsNothing,
          reason:
              'Error message should disappear after accepting terms',
        );
      },
    );

    testWidgets(
      'Error text is shown again when terms checkbox is unchecked after being checked',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(createTestApp(child: const SignupPage()));
        await tester.pumpAndSettle();

        // Fill all required fields
        await tester.enterText(
          findTextFormFieldByLabel('First Name'),
          'Bob',
        );
        await tester.enterText(
          findTextFormFieldByLabel('Last Name'),
          'Wilson',
        );
        await tester.enterText(
          findTextFormFieldByLabel('Email Address'),
          'bob.wilson@example.com',
        );
        await tester.enterText(
          findTextFormFieldByLabel('Password'),
          'bobpass123',
        );
        await tester.enterText(
          findTextFormFieldByLabel('Confirm Password'),
          'bobpass123',
        );

        // Check the terms checkbox
        final termsWidget = find.byType(TermsAndConditions);
        await tester.tap(termsWidget);
        await tester.pump();

        // Verify no error message is shown
        expect(
          find.text('Please accept terms and conditions'),
          findsNothing,
        );

        // Uncheck the terms checkbox
        await tester.tap(termsWidget);
        await tester.pump();

        // Submit form to trigger validation
        final signUpButton = find.widgetWithText(GenericButton, 'Sign Up');
        await tester.ensureVisible(signUpButton);
        await tester.tap(signUpButton);
        await tester.pump();

        // Verify error is displayed again
        expect(
          find.text('Please accept terms and conditions'),
          findsOneWidget,
          reason:
              'Error should reappear after unchecking terms',
        );
      },
    );

    testWidgets(
      'Validator correctly validates when terms are accepted',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(createTestApp(child: const SignupPage()));
        await tester.pumpAndSettle();

        // Fill all required fields
        await tester.enterText(
          findTextFormFieldByLabel('First Name'),
          'Charlie',
        );
        await tester.enterText(
          findTextFormFieldByLabel('Last Name'),
          'Brown',
        );
        await tester.enterText(
          findTextFormFieldByLabel('Email Address'),
          'charlie.brown@example.com',
        );
        await tester.enterText(
          findTextFormFieldByLabel('Password'),
          'charlie123',
        );
        await tester.enterText(
          findTextFormFieldByLabel('Confirm Password'),
          'charlie123',
        );

        // Check the terms checkbox
        final termsWidget = find.byType(TermsAndConditions);
        await tester.tap(termsWidget);
        await tester.pump();

        // Submit form with terms accepted
        final signUpButton = find.widgetWithText(GenericButton, 'Sign Up');
        await tester.ensureVisible(signUpButton);
        await tester.tap(signUpButton);
        await tester.pumpAndSettle();

        // Verify no error message for terms
        expect(
          find.text('Please accept terms and conditions'),
          findsNothing,
          reason:
              'No error should appear when terms are accepted',
        );
      },
    );

    testWidgets(
      'FormField maintains state consistency during interactions',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(createTestApp(child: const SignupPage()));
        await tester.pumpAndSettle();

        final termsWidget = find.byType(TermsAndConditions);

        // Initial state: unchecked, no error (until form submission)
        expect(termsWidget, findsOneWidget);

        // Check terms
        await tester.tap(termsWidget);
        await tester.pump();

        // Uncheck terms
        await tester.tap(termsWidget);
        await tester.pump();

        // Check terms again for good measure
        await tester.tap(termsWidget);
        await tester.pump();

        // Fill all fields
        await tester.enterText(
          findTextFormFieldByLabel('First Name'),
          'Diana',
        );
        await tester.enterText(
          findTextFormFieldByLabel('Last Name'),
          'Prince',
        );
        await tester.enterText(
          findTextFormFieldByLabel('Email Address'),
          'diana.prince@example.com',
        );
        await tester.enterText(
          findTextFormFieldByLabel('Password'),
          'diana123',
        );
        await tester.enterText(
          findTextFormFieldByLabel('Confirm Password'),
          'diana123',
        );

        // After multiple toggles, terms should still be checked and no error shown
        final signUpButton = find.widgetWithText(GenericButton, 'Sign Up');
        await tester.ensureVisible(signUpButton);
        await tester.tap(signUpButton);
        await tester.pump();

        expect(
          find.text('Please accept terms and conditions'),
          findsNothing,
          reason:
              'Terms should remain in checked state after multiple interactions',
        );
      },
    );
  });
}
