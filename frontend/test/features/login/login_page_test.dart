import 'package:aurabus/features/login/presentation/login_page.dart';
import 'package:aurabus/common/widgets/generic_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../utils/test_app_wrapper.dart';
import '../../utils/device_definitions.dart';

void main() {
  group('LoginPage Functional Tests', () {
    testWidgets('Validation: Empty fields show errors', (tester) async {
      await tester.pumpWidget(createTestApp(child: const LoginPage()));
      await tester.pumpAndSettle();

      final loginButton = find.widgetWithText(Genericbutton, 'Login');
      await tester.ensureVisible(loginButton);
      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('Validation: Invalid email format', (tester) async {
      await tester.pumpWidget(createTestApp(child: const LoginPage()));
      await tester.pumpAndSettle();

      await tester.enterText(
        findCustomTextFieldByLabel('Email Address'),
        'bad_email',
      );

      final loginButton = find.widgetWithText(Genericbutton, 'Login');
      await tester.ensureVisible(loginButton);
      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text('Invalid email'), findsOneWidget);
    });

    testWidgets('Security: Password field is obscured', (tester) async {
      await tester.pumpWidget(createTestApp(child: const LoginPage()));
      await tester.pumpAndSettle();

      final passwordField = find.widgetWithText(TextField, 'Password');
      final TextField widget = tester.widget(passwordField);

      expect(widget.obscureText, isTrue);
    });
  });

  group('LoginPage Responsiveness Tests', () {
    for (var device in TestDevices.all) {
      testWidgets(
        'Renders correctly on ${device.name} (${device.size.width}x${device.size.height})',
        (tester) async {
          tester.view.physicalSize = device.size;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);

          await tester.pumpWidget(createTestApp(child: const LoginPage()));
          await tester.pumpAndSettle();

          expect(find.text('Welcome Back!'), findsOneWidget);

          expect(findCustomTextFieldByLabel('Email Address'), findsOneWidget);

          final loginButton = find.widgetWithText(Genericbutton, 'Login');
          await tester.ensureVisible(loginButton);
          expect(loginButton, findsOneWidget);

          final signUpText = find.text('Sign Up');
          await tester.ensureVisible(signUpText);
          expect(signUpText, findsOneWidget);
        },
      );
    }
  });
}
