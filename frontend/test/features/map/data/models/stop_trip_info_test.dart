import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/map/data/models/stop_trip_info.dart';

void main() {
  group('OccupancyData', () {
    test('fromJson creates OccupancyData correctly', () {
      final json = {'percentage': 75, 'passengers': 30};
      final data = OccupancyData.fromJson(json);

      expect(data.percentage, 75);
      expect(data.passengers, 30);
    });
  });

  group('OccupancyStatus', () {
    test('fromJson creates OccupancyStatus with realTime and expected', () {
      final json = {
        'realTime': {'percentage': 60, 'passengers': 24},
        'expected': {'percentage': 50, 'passengers': 20},
      };

      final status = OccupancyStatus.fromJson(json);

      expect(status.realTime.percentage, 60);
      expect(status.realTime.passengers, 24);
      expect(status.expected.percentage, 50);
      expect(status.expected.passengers, 20);
    });
  });

  group('StopTripTime', () {
    test('fromJson creates StopTripTime with all fields', () {
      final json = {
        'stopId': 100,
        'stopName': 'Piazza Dante',
        'arrivalTimeScheduled': '14:30',
        'delayPredicted': 5,
      };

      final stopTime = StopTripTime.fromJson(json);

      expect(stopTime.stopId, 100);
      expect(stopTime.stopName, 'Piazza Dante');
      expect(stopTime.arrivalTimeScheduled, '14:30');
      expect(stopTime.delayPredicted, 5);
    });

    test('fromJson defaults delayPredicted to 0 when null', () {
      final json = {
        'stopId': 200,
        'stopName': 'Via Roma',
        'arrivalTimeScheduled': '15:00',
        'delayPredicted': null,
      };

      final stopTime = StopTripTime.fromJson(json);
      expect(stopTime.delayPredicted, 0);
    });

    test('fromJson defaults delayPredicted to 0 when missing', () {
      final json = {
        'stopId': 300,
        'stopName': 'Via Manci',
        'arrivalTimeScheduled': '16:00',
      };

      final stopTime = StopTripTime.fromJson(json);
      expect(stopTime.delayPredicted, 0);
    });
  });

  group('StopTrip', () {
    Map<String, dynamic> createValidStopTripJson({
      String? routeColor,
      int? busId,
      String? lastUpdate,
      int? delay,
    }) {
      return {
        'routeId': 5,
        'routeShortName': '5',
        'routeLongName': 'Trento - Rovereto',
        'routeColor': routeColor,
        'busId': busId,
        'busCapacity': 50,
        'busType': 'urban',
        'occupancy': {
          'realTime': {'percentage': 60, 'passengers': 30},
          'expected': {'percentage': 45, 'passengers': 22},
        },
        'lastUpdate': lastUpdate,
        'delay': delay,
        'lastStopId': 10,
        'nextStopId': 11,
        'passedStopCount': 3,
        'arrivalTimeScheduled': '2025-01-15T14:30:00',
        'arrivalTimeEstimated': '2025-01-15T14:35:00',
        'stopTimes': [
          {
            'stopId': 10,
            'stopName': 'Piazza Dante',
            'arrivalTimeScheduled': '14:25',
            'delayPredicted': 2,
          },
          {
            'stopId': 11,
            'stopName': 'Via Roma',
            'arrivalTimeScheduled': '14:30',
            'delayPredicted': 5,
          },
        ],
      };
    }

    test('fromJson creates StopTrip with all fields', () {
      final json = createValidStopTripJson(
        routeColor: '#FF0000',
        busId: 42,
        lastUpdate: '2025-01-15T14:20:00',
        delay: 5,
      );

      final trip = StopTrip.fromJson(json);

      expect(trip.routeId, 5);
      expect(trip.routeShortName, '5');
      expect(trip.routeLongName, 'Trento - Rovereto');
      expect(trip.routeColor, isNotNull);
      expect(trip.routeColor, isA<Color>());
      expect(trip.busId, 42);
      expect(trip.busCapacity, 50);
      expect(trip.busType, 'urban');
      expect(trip.occupancy.realTime.percentage, 60);
      expect(trip.occupancy.expected.passengers, 22);
      expect(trip.lastUpdate, isNotNull);
      expect(trip.delay, 5);
      expect(trip.lastStopId, 10);
      expect(trip.nextStopId, 11);
      expect(trip.passedStopCount, 3);
      expect(trip.arrivalTimeScheduled, DateTime.parse('2025-01-15T14:30:00'));
      expect(trip.arrivalTimeEstimated, DateTime.parse('2025-01-15T14:35:00'));
      expect(trip.stopTimes.length, 2);
      expect(trip.stopTimes[0].stopName, 'Piazza Dante');
      expect(trip.stopTimes[1].stopName, 'Via Roma');
    });

    test('fromJson handles null routeColor', () {
      final json = createValidStopTripJson(routeColor: null);
      final trip = StopTrip.fromJson(json);
      expect(trip.routeColor, isNull);
    });

    test('fromJson handles null busId', () {
      final json = createValidStopTripJson(busId: null);
      final trip = StopTrip.fromJson(json);
      expect(trip.busId, isNull);
    });

    test('fromJson handles null lastUpdate', () {
      final json = createValidStopTripJson(lastUpdate: null);
      final trip = StopTrip.fromJson(json);
      expect(trip.lastUpdate, isNull);
    });

    test('fromJson handles null delay', () {
      final json = createValidStopTripJson(delay: null);
      final trip = StopTrip.fromJson(json);
      expect(trip.delay, isNull);
    });

    test('fromJson parses empty stopTimes list', () {
      final json = createValidStopTripJson();
      json['stopTimes'] = <Map<String, dynamic>>[];

      final trip = StopTrip.fromJson(json);
      expect(trip.stopTimes, isEmpty);
    });
  });
}
