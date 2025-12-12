import 'package:aurabus/features/signup/presentation/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:aurabus/features/home/presentation/home_page.dart';
import 'package:aurabus/features/tickets/presentation/ticket_page.dart';
import 'package:aurabus/features/map/presentation/map_screen.dart';
import 'package:aurabus/features/account/presentation/account_page.dart';
import 'package:aurabus/features/login/presentation/login_page.dart';

final _rootKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

class AppRoute {
  static const String tickets = '/tickets';
  static const String map = '/map';
  static const String account = '/account';
  static const String login = '/login';
  static const String signup = '/signup';

}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: AppRoute.map,
    routes: [
      GoRoute(
        path: AppRoute.login,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: LoginPage()),
      ),
      GoRoute(
        path: AppRoute.signup,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SignupPage()),
      ),
      ShellRoute(
        navigatorKey: _shellKey,
        builder: (context, state, child) {
          return HomePage(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoute.tickets,
            builder: (_, _) => const TicketPage(),
          ),
          GoRoute(
            path: AppRoute.map, 
            builder: (_, _) => const MapScreen()
          ),
          GoRoute(
            path: AppRoute.account,
            builder: (_, _) => const AccountPage(),
          ),

        ],
      ),
    ],
  );
});
