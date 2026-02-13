import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/routing/router.dart';

void main() {
  group('Legal Routes Constants', () {
    test('termsOfService route path is correct', () {
      expect(AppRoute.termsOfService, '/terms-of-service');
    });

    test('privacyPolicy route path is correct', () {
      expect(AppRoute.privacyPolicy, '/privacy-policy');
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

    test('legal routes start with /', () {
      expect(AppRoute.termsOfService.startsWith('/'), isTrue);
      expect(AppRoute.privacyPolicy.startsWith('/'), isTrue);
    });

    test('legal routes use kebab-case naming convention', () {
      expect(AppRoute.termsOfService, matches(RegExp(r'^/[a-z\-]+$')));
      expect(AppRoute.privacyPolicy, matches(RegExp(r'^/[a-z\-]+$')));
    });
  });
}
