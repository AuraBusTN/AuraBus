import 'package:aurabus/features/signup/presentation/signup_page.dart';
import 'package:aurabus/common/widgets/generic_button.dart';
import 'package:aurabus/features/signup/widgets/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../utils/test_app_wrapper.dart';

void main() {
  group('Terms Acceptance FormField<bool> Validator', () {
    Future<void> fillSignupForm(
      WidgetTester tester, {
      String firstName = 'John',
      String lastName = 'Doe',
      String email = 'john.doe@example.com',
      String password = 'password123',
      String confirmPassword = 'password123',
    }) async {
      await tester.enterText(find.byKey(const Key('firstNameField')), firstName);
      await tester.enterText(find.byKey(const Key('lastNameField')), lastName);
      await tester.enterText(find.byKey(const Key('emailField')), email);
      await tester.enterText(find.byKey(const Key('passwordField')), password);
      await tester.enterText(find.byKey(const Key('confirmPasswordField')), confirmPassword);
    }

    Future<void> tapTermsCheckbox(WidgetTester tester) async {
      final termsWidget = find.byType(TermsAndConditions);
      expect(termsWidget, findsOneWidget);
      await tester.tap(termsWidget);
      await tester.pump();
    }

    Future<void> tapSignUpButton(WidgetTester tester) async {
      final button = find.widgetWithText(GenericButton, 'Sign Up');
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pump();
    }

    Future<void> prepareTester(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
    }

    testWidgets('Blocks signup when terms checkbox is unchecked', (tester) async {
      await prepareTester(tester);
      await tester.pumpWidget(createTestApp(child: const SignupPage()));
      await tester.pumpAndSettle();

      await fillSignupForm(tester);
      await tapSignUpButton(tester);

      expect(find.text('Please accept terms and conditions'), findsOneWidget);
    });

    testWidgets('Error text is shown with unchecked terms', (tester) async {
      await prepareTester(tester);
      await tester.pumpWidget(createTestApp(child: const SignupPage()));
      await tester.pumpAndSettle();

      await fillSignupForm(tester,
          firstName: 'Jane',
          lastName: 'Smith',
          email: 'jane.smith@example.com',
          password: 'securepass123',
          confirmPassword: 'securepass123');

      await tapSignUpButton(tester);

      final errorText = find.text('Please accept terms and conditions');
      expect(errorText, findsOneWidget);

      final textWidget = tester.widget<Text>(errorText);
      expect(textWidget.style?.color, Colors.red);
    });

    testWidgets('Error disappears when terms checkbox is checked', (tester) async {
      await prepareTester(tester);
      await tester.pumpWidget(createTestApp(child: const SignupPage()));
      await tester.pumpAndSettle();

      await fillSignupForm(tester);
      await tapSignUpButton(tester);
      expect(find.text('Please accept terms and conditions'), findsOneWidget);

      await tapTermsCheckbox(tester);
      expect(find.text('Please accept terms and conditions'), findsNothing);
    });

    testWidgets('Error reappears if terms checkbox is unchecked after being checked', (tester) async {
      await prepareTester(tester);
      await tester.pumpWidget(createTestApp(child: const SignupPage()));
      await tester.pumpAndSettle();

      await fillSignupForm(tester);
      await tapTermsCheckbox(tester);
      expect(find.text('Please accept terms and conditions'), findsNothing);

      await tapTermsCheckbox(tester);
      await tapSignUpButton(tester);

      expect(find.text('Please accept terms and conditions'), findsOneWidget);
    });

    testWidgets('Form validates successfully when terms accepted', (tester) async {
      await prepareTester(tester);
      await tester.pumpWidget(createTestApp(child: const SignupPage()));
      await tester.pumpAndSettle();

      await fillSignupForm(tester);
      await tapTermsCheckbox(tester);
      await tapSignUpButton(tester);

      expect(find.text('Please accept terms and conditions'), findsNothing);
      expect(find.widgetWithText(GenericButton, 'Sign Up'), findsOneWidget);
    });

    testWidgets('FormField maintains state consistency', (tester) async {
      await prepareTester(tester);
      await tester.pumpWidget(createTestApp(child: const SignupPage()));
      await tester.pumpAndSettle();

      await fillSignupForm(tester);
      await tapTermsCheckbox(tester);
      await tapTermsCheckbox(tester);
      await tapTermsCheckbox(tester);

      await tapSignUpButton(tester);

      expect(find.text('Please accept terms and conditions'), findsNothing);
    });
  });
}
