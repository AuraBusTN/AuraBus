import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/map/data/models/route_info.dart';

void main() {
  group('RouteInfo', () {
    test('fromJson creates RouteInfo with all fields', () {
      final json = {
        'routeColor': '#FF0000',
        'routeId': 5,
        'routeLongName': 'Trento - Rovereto',
        'routeShortName': '5',
      };

      final route = RouteInfo.fromJson(json);

      expect(route.routeColor, '#FF0000');
      expect(route.routeId, 5);
      expect(route.routeLongName, 'Trento - Rovereto');
      expect(route.routeShortName, '5');
    });

    test('fromJson handles null routeColor', () {
      final json = {
        'routeColor': null,
        'routeId': 1,
        'routeLongName': 'Test Route',
        'routeShortName': 'T1',
      };

      final route = RouteInfo.fromJson(json);
      expect(route.routeColor, isNull);
    });

    test('equality is based on routeId', () {
      final route1 = RouteInfo(
        routeColor: '#FF0000',
        routeId: 5,
        routeLongName: 'Route A',
        routeShortName: '5',
      );
      final route2 = RouteInfo(
        routeColor: '#00FF00',
        routeId: 5,
        routeLongName: 'Route B',
        routeShortName: '5B',
      );

      expect(route1, equals(route2));
    });

    test('different routeId means not equal', () {
      final route1 = RouteInfo(
        routeColor: '#FF0000',
        routeId: 5,
        routeLongName: 'Route A',
        routeShortName: '5',
      );
      final route2 = RouteInfo(
        routeColor: '#FF0000',
        routeId: 10,
        routeLongName: 'Route A',
        routeShortName: '5',
      );

      expect(route1, isNot(equals(route2)));
    });

    test('hashCode is based on routeId', () {
      final route = RouteInfo(
        routeColor: null,
        routeId: 42,
        routeLongName: 'Test',
        routeShortName: '42',
      );

      expect(route.hashCode, 42.hashCode);
    });
  });
}
