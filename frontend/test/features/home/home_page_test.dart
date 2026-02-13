import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/home/presentation/home_page.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:aurabus/features/auth/presentation/providers/auth_provider.dart';

void main() {
  Widget buildHomePage({AuthState? authState}) {
    final router = GoRouter(
      initialLocation: '/map',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              HomePage(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/tickets',
                  builder: (context, state) =>
                      const Center(child: Text('Tickets Content')),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/map',
                  builder: (context, state) =>
                      const Center(child: Text('Map Content')),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/account',
                  builder: (context, state) =>
                      const Center(child: Text('Account Content')),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Login Screen'))),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        if (authState != null)
          authProvider.overrideWith(() => _FakeAuthNotifier(authState)),
      ],
      child: MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        routerConfig: router,
      ),
    );
  }

  group('HomePage', () {
    testWidgets('renders bottom navigation bar with 3 items', (tester) async {
      await tester.pumpWidget(
        buildHomePage(authState: const AuthState(isAuthenticated: true)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(BottomNavigationBar), findsOneWidget);

      expect(find.text('Tickets'), findsOneWidget);
      expect(find.text('Map'), findsOneWidget);
      expect(find.text('Account'), findsOneWidget);
    });

    testWidgets('renders bottom nav icons', (tester) async {
      await tester.pumpWidget(
        buildHomePage(authState: const AuthState(isAuthenticated: true)),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.confirmation_number_outlined), findsOneWidget);
      expect(find.byIcon(Icons.map_outlined), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('starts on map tab (index 1)', (tester) async {
      await tester.pumpWidget(
        buildHomePage(authState: const AuthState(isAuthenticated: true)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Map Content'), findsOneWidget);
    });

    testWidgets('tapping tickets tab navigates', (tester) async {
      await tester.pumpWidget(
        buildHomePage(authState: const AuthState(isAuthenticated: true)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tickets'));
      await tester.pumpAndSettle();

      expect(find.text('Tickets Content'), findsOneWidget);
    });

    testWidgets('tapping account tab when authenticated navigates', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildHomePage(authState: const AuthState(isAuthenticated: true)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Account'));
      await tester.pumpAndSettle();

      expect(find.text('Account Content'), findsOneWidget);
    });

    testWidgets(
      'tapping account tab when not authenticated redirects to login',
      (tester) async {
        await tester.pumpWidget(
          buildHomePage(authState: const AuthState(isAuthenticated: false)),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Account'));
        await tester.pumpAndSettle();

        expect(find.text('Login Screen'), findsOneWidget);
      },
    );
  });
}

class _FakeAuthNotifier extends AuthNotifier {
  final AuthState _initialState;
  _FakeAuthNotifier(this._initialState);

  @override
  AuthState build() => _initialState;
}
