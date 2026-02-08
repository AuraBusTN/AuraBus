import 'package:aurabus/features/favorites/presentation/favorites_page.dart';
import 'package:aurabus/features/ranking/presentation/ranking_page.dart';
import 'package:aurabus/features/signup/presentation/signup_page.dart';
import 'package:aurabus/features/signup/widgets/privacy_page.dart';
import 'package:aurabus/features/signup/widgets/tems_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:aurabus/features/home/presentation/home_page.dart';
import 'package:aurabus/features/tickets/presentation/ticket_page.dart';
import 'package:aurabus/features/map/presentation/map_screen.dart';
import 'package:aurabus/features/account/presentation/account_page.dart';
import 'package:aurabus/features/login/presentation/login_page.dart';
import 'package:aurabus/features/auth/presentation/providers/auth_provider.dart';

final _rootKey = GlobalKey<NavigatorState>();

class AppRoute {
  static const String tickets = '/tickets';
  static const String map = '/map';
  static const String account = '/account';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String ranking = '/ranking';
  static const String favorites = '/favorites';
  static const String privacy = '/privacy';
  static const String terms = '/terms';



}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authListenable = AuthListenable(ref);

  ref.onDispose(authListenable.dispose);

  return GoRouter(
    refreshListenable: authListenable,
    navigatorKey: _rootKey,
    initialLocation: AppRoute.map,
    routes: [
      GoRoute(
        path: AppRoute.login,
        parentNavigatorKey: _rootKey,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: AppRoute.signup,
        parentNavigatorKey: _rootKey,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SignupPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: AppRoute.ranking,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const RankingPage(),
      ),
      GoRoute(
        path: AppRoute.favorites,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const FavoritesPage(),
      ),
      GoRoute(
        path: AppRoute.terms,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const TermsPage(),
      ),
      GoRoute(
        path: AppRoute.privacy,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const PrivacyPage(),
      ),


      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomePage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.tickets,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: TicketPage()),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.map,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: MapScreen()),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.account,
                redirect: (context, state) {
                  final authState = ref.read(authProvider);
                  if (!authState.isAuthenticated) {
                    return AppRoute.login;
                  }
                  return null;
                },
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: AccountPage()),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class AuthListenable extends ChangeNotifier {
  final Ref ref;
  ProviderSubscription? _subscription;

  AuthListenable(this.ref) {
    _subscription = ref.listen<AuthState>(authProvider, (previous, next) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.close();
    super.dispose();
  }
}
