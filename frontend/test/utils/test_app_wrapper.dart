import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_test/flutter_test.dart';

Widget createTestApp({required Widget child, GoRouter? router}) {
  return ProviderScope(
    child: MaterialApp.router(
      debugShowCheckedModeBanner: false,
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
            ],
          ),
    ),
  );
}

Finder findCustomTextFieldByLabel(String label) {
  return find.widgetWithText(TextFormField, label);
}
