import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/account/widgets/account_info_body.dart';
import 'package:aurabus/l10n/app_localizations.dart';

void main() {
  Widget buildWidget({
    bool busNotificationEnabled = true,
    ValueChanged<bool>? onNotificationToggle,
    String firstName = 'Mario',
    String lastName = 'Rossi',
    String email = 'mario@test.com',
    String? profilePictureUrl,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(
        body: AccountInfoBody(
          busNotificationEnabled: busNotificationEnabled,
          onNotificationToggle: onNotificationToggle ?? (_) {},
          firstName: firstName,
          lastName: lastName,
          email: email,
          profilePictureUrl: profilePictureUrl,
        ),
      ),
    );
  }

  group('AccountInfoBody', () {
    testWidgets('renders full name', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Mario Rossi'), findsOneWidget);
    });

    testWidgets('renders email', (tester) async {
      await tester.pumpWidget(buildWidget(email: 'test@example.com'));
      await tester.pumpAndSettle();

      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('shows "Edit your profile picture" when email is empty', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(email: ''));
      await tester.pumpAndSettle();

      expect(find.text('Edit your profile picture'), findsOneWidget);
    });

    testWidgets('renders CircleAvatar', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('renders settings title', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('renders notification switch', (tester) async {
      await tester.pumpWidget(buildWidget(busNotificationEnabled: true));
      await tester.pumpAndSettle();

      expect(find.byType(Switch), findsOneWidget);
      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isTrue);
    });

    testWidgets('notification switch is off when disabled', (tester) async {
      await tester.pumpWidget(buildWidget(busNotificationEnabled: false));
      await tester.pumpAndSettle();

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isFalse);
    });

    testWidgets('toggling switch calls onNotificationToggle', (tester) async {
      bool? toggledValue;
      await tester.pumpWidget(
        buildWidget(
          busNotificationEnabled: true,
          onNotificationToggle: (v) => toggledValue = v,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch));
      expect(toggledValue, isFalse);
    });

    testWidgets('renders bus notification label', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Bus Coming Notification'), findsOneWidget);
    });

    testWidgets('renders with default firstName and lastName', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(
            body: AccountInfoBody(
              busNotificationEnabled: false,
              onNotificationToggle: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('John Doe'), findsOneWidget);
    });
  });
}
