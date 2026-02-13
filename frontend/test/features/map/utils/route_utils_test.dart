import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/map/data/models/route_info.dart';
import 'package:aurabus/features/map/presentation/utils/route_utils.dart';

void main() {
  group('RouteUtils.compareRoutes', () {
    RouteInfo makeRoute(String shortName) => RouteInfo(
      routeColor: null,
      routeId: shortName.hashCode,
      routeLongName: 'Route $shortName',
      routeShortName: shortName,
    );

    test('numeric routes are sorted numerically', () {
      final r1 = makeRoute('1');
      final r5 = makeRoute('5');
      final r10 = makeRoute('10');

      expect(RouteUtils.compareRoutes(r1, r5), lessThan(0));
      expect(RouteUtils.compareRoutes(r5, r10), lessThan(0));
      expect(RouteUtils.compareRoutes(r10, r1), greaterThan(0));
    });

    test('same numeric prefix sorts by full name', () {
      final r5 = makeRoute('5');
      final r5a = makeRoute('5A');

      expect(RouteUtils.compareRoutes(r5, r5a), lessThan(0));
    });

    test('numeric routes come before non-numeric routes', () {
      final r3 = makeRoute('3');
      final rA = makeRoute('A');

      expect(RouteUtils.compareRoutes(r3, rA), lessThan(0));
    });

    test('non-numeric routes come after numeric routes', () {
      final rA = makeRoute('A');
      final r10 = makeRoute('10');

      expect(RouteUtils.compareRoutes(rA, r10), greaterThan(0));
    });

    test('non-numeric routes are sorted alphabetically', () {
      final rA = makeRoute('A');
      final rB = makeRoute('B');
      final rC = makeRoute('C');

      expect(RouteUtils.compareRoutes(rA, rB), lessThan(0));
      expect(RouteUtils.compareRoutes(rB, rC), lessThan(0));
    });

    test('same routes return 0', () {
      final r5 = makeRoute('5');
      expect(RouteUtils.compareRoutes(r5, r5), 0);
    });

    test('complex sorting scenario', () {
      final routes = [
        makeRoute('B'),
        makeRoute('10'),
        makeRoute('3'),
        makeRoute('1'),
        makeRoute('A'),
        makeRoute('5A'),
        makeRoute('5'),
      ];

      routes.sort(RouteUtils.compareRoutes);

      expect(routes.map((r) => r.routeShortName).toList(), [
        '1',
        '3',
        '5',
        '5A',
        '10',
        'A',
        'B',
      ]);
    });
  });
}
