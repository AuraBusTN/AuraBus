import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/l10n/app_localizations.dart';

Widget createTestApp({
  required Widget child,
  GoRouter? router,
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      routerConfig:
          router ??
          GoRouter(
            initialLocation: '/',
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => Scaffold(body: child),
              ),
              GoRoute(
                path: '/signup',
                builder: (context, state) =>
                    const Scaffold(body: Text('Signup Screen Reached')),
              ),
              GoRoute(
                path: '/login',
                builder: (context, state) =>
                    const Scaffold(body: Text('Login Screen Reached')),
              ),
              GoRoute(
                path: '/map',
                builder: (context, state) =>
                    const Scaffold(body: Text('Map Screen Reached')),
              ),
              GoRoute(
                path: '/tickets',
                builder: (context, state) =>
                    const Scaffold(body: Text('Tickets Screen Reached')),
              ),
              GoRoute(
                path: '/account',
                builder: (context, state) =>
                    const Scaffold(body: Text('Account Screen Reached')),
              ),
              GoRoute(
                path: '/ranking',
                builder: (context, state) =>
                    const Scaffold(body: Text('Ranking Screen Reached')),
              ),
              GoRoute(
                path: '/terms-of-service',
                builder: (context, state) =>
                    const Scaffold(body: Text('Terms Screen Reached')),
              ),
              GoRoute(
                path: '/privacy-policy',
                builder: (context, state) =>
                    const Scaffold(body: Text('Privacy Screen Reached')),
              ),
            ],
          ),
    ),
  );
}

Finder findTextFormFieldByLabel(String label) {
  return find.widgetWithText(TextFormField, label);
}
