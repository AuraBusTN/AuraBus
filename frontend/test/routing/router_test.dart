import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:aurabus/routing/router.dart';
import 'package:aurabus/features/auth/presentation/providers/auth_provider.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:aurabus/theme.dart';

void main() {
  group('GoRouter Configuration', () {
    testWidgets('goRouterProvider creates a valid router', (tester) async {
      late GoRouter router;

      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, ref, _) {
              router = ref.read(goRouterProvider);
              return MaterialApp.router(
                routerConfig: router,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: const Locale('en'),
                theme: AppTheme.lightTheme,
              );
            },
          ),
        ),
      );

      expect(router, isNotNull);
      expect(router.routeInformationProvider.value.uri.path, AppRoute.map);
    });

    testWidgets('initial location is map', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, ref, _) {
              final router = ref.read(goRouterProvider);
              return MaterialApp.router(
                routerConfig: router,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: const Locale('en'),
                theme: AppTheme.lightTheme,
              );
            },
          ),
        ),
      );

      await tester.pump();
    });
  });

  group('AuthListenable', () {
    test('AuthListenable notifies on auth state changes', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(authProvider);

      bool notified = false;
      late AuthListenable listenable;

      final testProvider = Provider<AuthListenable>((ref) {
        return AuthListenable(ref);
      });

      listenable = container.read(testProvider);
      listenable.addListener(() => notified = true);

      container.read(authProvider.notifier).setAuthError('test');

      expect(notified, isTrue);

      listenable.dispose();
    });

    test('AuthListenable disposes subscription', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(authProvider);

      final testProvider = Provider<AuthListenable>((ref) {
        return AuthListenable(ref);
      });

      final listenable = container.read(testProvider);

      listenable.dispose();
    });
  });
}
