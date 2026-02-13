import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/map/data/models/stop_info.dart';

void main() {
  group('StopInfo', () {
    test('fromJson creates StopInfo with all fields', () {
      final json = {
        'distance': 1.5,
        'routes': [
          {
            'routeColor': '#FF0000',
            'routeId': 5,
            'routeLongName': 'Trento - Rovereto',
            'routeShortName': '5',
          },
        ],
        'stopCode': 'S001',
        'stopDesc': 'Fermata Centrale',
        'stopId': 100,
        'stopLat': 46.0667,
        'stopLevel': 0,
        'stopLon': 11.1167,
        'stopName': 'Trento Centro',
        'street': 'Via Roma',
        'town': 'Trento',
        'type': 'urban',
        'wheelchairBoarding': 1,
      };

      final stop = StopInfo.fromJson(json);

      expect(stop.distance, 1.5);
      expect(stop.routes.length, 1);
      expect(stop.routes.first.routeId, 5);
      expect(stop.stopCode, 'S001');
      expect(stop.stopDesc, 'Fermata Centrale');
      expect(stop.stopId, 100);
      expect(stop.stopLat, 46.0667);
      expect(stop.stopLevel, 0);
      expect(stop.stopLon, 11.1167);
      expect(stop.stopName, 'Trento Centro');
      expect(stop.street, 'Via Roma');
      expect(stop.town, 'Trento');
      expect(stop.type, 'urban');
      expect(stop.wheelchairBoarding, 1);
    });

    test('fromJson handles null distance', () {
      final json = {
        'distance': null,
        'routes': <Map<String, dynamic>>[],
        'stopCode': 'S002',
        'stopDesc': 'Test',
        'stopId': 200,
        'stopLat': 46.0,
        'stopLevel': 0,
        'stopLon': 11.0,
        'stopName': 'Test Stop',
        'street': 'Via Test',
        'type': 'urban',
        'wheelchairBoarding': 0,
      };

      final stop = StopInfo.fromJson(json);
      expect(stop.distance, isNull);
      expect(stop.town, isNull);
    });

    test('fromJson handles empty routes list', () {
      final json = {
        'distance': 0.0,
        'routes': <Map<String, dynamic>>[],
        'stopCode': 'S003',
        'stopDesc': 'Empty',
        'stopId': 300,
        'stopLat': 46.0,
        'stopLevel': 0,
        'stopLon': 11.0,
        'stopName': 'Empty Stop',
        'street': 'Via Empty',
        'type': 'urban',
        'wheelchairBoarding': 2,
      };

      final stop = StopInfo.fromJson(json);
      expect(stop.routes, isEmpty);
    });

    test('fromJson parses multiple routes', () {
      final json = {
        'distance': 0.5,
        'routes': [
          {
            'routeColor': '#FF0000',
            'routeId': 1,
            'routeLongName': 'Route 1',
            'routeShortName': '1',
          },
          {
            'routeColor': '#00FF00',
            'routeId': 2,
            'routeLongName': 'Route 2',
            'routeShortName': '2',
          },
          {
            'routeColor': '#0000FF',
            'routeId': 3,
            'routeLongName': 'Route 3',
            'routeShortName': '3',
          },
        ],
        'stopCode': 'S004',
        'stopDesc': 'Multi',
        'stopId': 400,
        'stopLat': 46.0,
        'stopLevel': 1,
        'stopLon': 11.0,
        'stopName': 'Multi Stop',
        'street': 'Via Multi',
        'town': 'Trento',
        'type': 'extraurban',
        'wheelchairBoarding': 1,
      };

      final stop = StopInfo.fromJson(json);
      expect(stop.routes.length, 3);
      expect(stop.routes[0].routeId, 1);
      expect(stop.routes[1].routeId, 2);
      expect(stop.routes[2].routeId, 3);
    });
  });
}
