import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/routing/router.dart';

void main() {
  group('AppRoute constants', () {
    test('tickets route is /tickets', () {
      expect(AppRoute.tickets, '/tickets');
    });

    test('map route is /map', () {
      expect(AppRoute.map, '/map');
    });

    test('account route is /account', () {
      expect(AppRoute.account, '/account');
    });

    test('login route is /login', () {
      expect(AppRoute.login, '/login');
    });

    test('signup route is /signup', () {
      expect(AppRoute.signup, '/signup');
    });

    test('ranking route is /ranking', () {
      expect(AppRoute.ranking, '/ranking');
    });

    test('termsOfService route is /terms-of-service', () {
      expect(AppRoute.termsOfService, '/terms-of-service');
    });

    test('privacyPolicy route is /privacy-policy', () {
      expect(AppRoute.privacyPolicy, '/privacy-policy');
    });

    test('all routes start with /', () {
      final routes = [
        AppRoute.tickets,
        AppRoute.map,
        AppRoute.account,
        AppRoute.login,
        AppRoute.signup,
        AppRoute.ranking,
        AppRoute.termsOfService,
        AppRoute.privacyPolicy,
      ];

      for (final route in routes) {
        expect(
          route.startsWith('/'),
          isTrue,
          reason: '$route should start with /',
        );
      }
    });

    test('all routes are unique', () {
      final routes = [
        AppRoute.tickets,
        AppRoute.map,
        AppRoute.account,
        AppRoute.login,
        AppRoute.signup,
        AppRoute.ranking,
        AppRoute.termsOfService,
        AppRoute.privacyPolicy,
      ];

      expect(routes.toSet().length, routes.length);
    });
  });
}
