import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aurabus/common/widgets/google_button.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:aurabus/theme.dart';

void main() {
  group('GoogleButton (non-web)', () {
    testWidgets('renders OutlinedButton on non-web', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            theme: AppTheme.lightTheme,
            home: Scaffold(body: GoogleButton(onPressed: () {})),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('shows Google sign in text', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            theme: AppTheme.lightTheme,
            home: Scaffold(body: GoogleButton(onPressed: () {})),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Google'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            theme: AppTheme.lightTheme,
            home: Scaffold(body: GoogleButton(onPressed: () => pressed = true)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byType(OutlinedButton));
      expect(pressed, isTrue);
    });

    testWidgets('renders with null onPressed', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            theme: AppTheme.lightTheme,
            home: Scaffold(body: GoogleButton(onPressed: null)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(OutlinedButton), findsOneWidget);
    });
  });
}
