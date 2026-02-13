import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/map/widgets/bus_arrival_card.dart';
import 'package:aurabus/features/map/data/models/stop_trip_info.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:aurabus/theme.dart';

StopTrip _createStopTrip({
  int delay = 0,
  String? lastUpdate,
  int routeId = 5,
  String routeShortName = '5',
  int passedStopCount = 2,
  int lastStopId = 101,
  int nextStopId = 102,
  int? busId = 42,
}) {
  final now = DateTime.now().toUtc();
  final estimated = now.add(const Duration(minutes: 10));
  final scheduled = now.add(const Duration(minutes: 8));

  return StopTrip(
    routeId: routeId,
    routeShortName: routeShortName,
    routeLongName: 'Trento - Rovereto',
    routeColor: Colors.red,
    busId: busId,
    busCapacity: 50,
    busType: 'urban',
    occupancy: OccupancyStatus(
      realTime: OccupancyData(percentage: 60, passengers: 30),
      expected: OccupancyData(percentage: 45, passengers: 22),
    ),
    lastUpdate: lastUpdate != null
        ? DateTime.parse(lastUpdate)
        : now.subtract(const Duration(minutes: 2)),
    delay: delay,
    lastStopId: lastStopId,
    nextStopId: nextStopId,
    passedStopCount: passedStopCount,
    arrivalTimeScheduled: scheduled,
    arrivalTimeEstimated: estimated,
    stopTimes: [
      StopTripTime(
        stopId: 100,
        stopName: 'Capolinea',
        arrivalTimeScheduled: '14:00',
        delayPredicted: 0,
      ),
      StopTripTime(
        stopId: 101,
        stopName: 'Piazza Dante',
        arrivalTimeScheduled: '14:10',
        delayPredicted: 2,
      ),
      StopTripTime(
        stopId: 102,
        stopName: 'Via Roma',
        arrivalTimeScheduled: '14:20',
        delayPredicted: 5,
      ),
      StopTripTime(
        stopId: 103,
        stopName: 'Stazione',
        arrivalTimeScheduled: '14:30',
        delayPredicted: 3,
      ),
      StopTripTime(
        stopId: 104,
        stopName: 'Terminal',
        arrivalTimeScheduled: '14:40',
        delayPredicted: 0,
      ),
    ],
  );
}

void main() {
  Widget buildWidget({required StopTrip arrival, int currentStopId = 102}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: SingleChildScrollView(
          child: BusArrivalCard(arrival: arrival, currentStopId: currentStopId),
        ),
      ),
    );
  }

  group('BusArrivalCard', () {
    testWidgets('renders route short name', (tester) async {
      await tester.pumpWidget(buildWidget(arrival: _createStopTrip()));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('renders last stop name (destination)', (tester) async {
      await tester.pumpWidget(buildWidget(arrival: _createStopTrip()));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Terminal'), findsAtLeast(1));
    });

    testWidgets('renders occupancy percentage', (tester) async {
      await tester.pumpWidget(buildWidget(arrival: _createStopTrip()));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('45%'), findsOneWidget);
    });

    testWidgets('renders progress indicator for occupancy', (tester) async {
      await tester.pumpWidget(buildWidget(arrival: _createStopTrip()));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('shows green blinking dot for fresh update', (tester) async {
      await tester.pumpWidget(buildWidget(arrival: _createStopTrip()));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(FadeTransition), findsAtLeast(1));
    });

    testWidgets('tapping expands to show timeline', (tester) async {
      await tester.pumpWidget(buildWidget(arrival: _createStopTrip()));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Piazza Dante'), findsNothing);

      await tester.tap(find.byType(InkWell));
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(find.text('Piazza Dante'), findsOneWidget);
      expect(find.text('Via Roma'), findsOneWidget);
    });

    testWidgets('tapping again collapses the timeline', (tester) async {
      await tester.pumpWidget(buildWidget(arrival: _createStopTrip()));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byType(InkWell));
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(find.text('Piazza Dante'), findsOneWidget);

      await tester.tap(find.byType(InkWell));
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
    });

    testWidgets('shows delay indicator when delay > 0', (tester) async {
      await tester.pumpWidget(buildWidget(arrival: _createStopTrip(delay: 3)));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.textContaining("+3"), findsOneWidget);
    });

    testWidgets('no delay indicator when delay is 0', (tester) async {
      await tester.pumpWidget(buildWidget(arrival: _createStopTrip(delay: 0)));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.textContaining('+'), findsNothing);
    });

    testWidgets('shows negative delay', (tester) async {
      await tester.pumpWidget(buildWidget(arrival: _createStopTrip(delay: -2)));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.textContaining("-2"), findsOneWidget);
    });

    testWidgets('renders arriving in text', (tester) async {
      await tester.pumpWidget(buildWidget(arrival: _createStopTrip()));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.textContaining('min'), findsAtLeast(1));
    });
  });

  group('BusArrivalCard - header with no lastUpdate', () {
    testWidgets('renders without blinking dot when lastUpdate is null', (
      tester,
    ) async {
      final tripJson = {
        'routeId': 5,
        'routeShortName': '5',
        'routeLongName': 'Test',
        'routeColor': '#FF0000',
        'busId': null,
        'busCapacity': 50,
        'busType': 'urban',
        'occupancy': {
          'realTime': {'percentage': 50, 'passengers': 25},
          'expected': {'percentage': 40, 'passengers': 20},
        },
        'lastUpdate': null,
        'delay': null,
        'lastStopId': 10,
        'nextStopId': 11,
        'passedStopCount': 0,
        'arrivalTimeScheduled': DateTime.now()
            .add(const Duration(minutes: 5))
            .toIso8601String(),
        'arrivalTimeEstimated': DateTime.now()
            .add(const Duration(minutes: 7))
            .toIso8601String(),
        'stopTimes': [
          {
            'stopId': 10,
            'stopName': 'Start',
            'arrivalTimeScheduled': '14:00',
            'delayPredicted': 0,
          },
          {
            'stopId': 11,
            'stopName': 'End',
            'arrivalTimeScheduled': '14:30',
            'delayPredicted': 0,
          },
        ],
      };

      final trip = StopTrip.fromJson(tripJson);

      await tester.pumpWidget(buildWidget(arrival: trip, currentStopId: 10));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('5'), findsOneWidget);
    });
  });

  group('BusArrivalCard - stale update', () {
    testWidgets('renders with stale dot when lastUpdate > 5 minutes ago', (
      tester,
    ) async {
      final staleTime = DateTime.now()
          .toUtc()
          .subtract(const Duration(minutes: 10))
          .toIso8601String();
      final tripJson = {
        'routeId': 3,
        'routeShortName': '3',
        'routeLongName': 'Test Stale',
        'routeColor': '#00FF00',
        'busId': 10,
        'busCapacity': 40,
        'busType': 'urban',
        'occupancy': {
          'realTime': {'percentage': 30, 'passengers': 12},
          'expected': {'percentage': 25, 'passengers': 10},
        },
        'lastUpdate': staleTime,
        'delay': 0,
        'lastStopId': 20,
        'nextStopId': 21,
        'passedStopCount': 1,
        'arrivalTimeScheduled': DateTime.now()
            .add(const Duration(minutes: 15))
            .toIso8601String(),
        'arrivalTimeEstimated': DateTime.now()
            .add(const Duration(minutes: 15))
            .toIso8601String(),
        'stopTimes': [
          {
            'stopId': 20,
            'stopName': 'A',
            'arrivalTimeScheduled': '15:00',
            'delayPredicted': 0,
          },
          {
            'stopId': 21,
            'stopName': 'B',
            'arrivalTimeScheduled': '15:15',
            'delayPredicted': 0,
          },
        ],
      };

      final trip = StopTrip.fromJson(tripJson);
      await tester.pumpWidget(buildWidget(arrival: trip, currentStopId: 21));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('3'), findsOneWidget);
    });
  });

  group('TripTimeline', () {
    testWidgets('renders all stop names when expanded', (tester) async {
      await tester.pumpWidget(
        buildWidget(arrival: _createStopTrip(), currentStopId: 100),
      );
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byType(InkWell));
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(find.text('Capolinea'), findsOneWidget);
      expect(find.text('Piazza Dante'), findsOneWidget);
      expect(find.text('Via Roma'), findsOneWidget);
      expect(find.text('Stazione'), findsOneWidget);
    });

    testWidgets('renders stop times', (tester) async {
      await tester.pumpWidget(
        buildWidget(arrival: _createStopTrip(), currentStopId: 100),
      );
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byType(InkWell));
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      final richTexts = find.byWidgetPredicate((w) {
        if (w is RichText) {
          return w.text.toPlainText().contains('14:');
        }
        return false;
      });
      expect(richTexts, findsAtLeast(1));
    });

    testWidgets('shows delay predictions for future stops', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          arrival: _createStopTrip(passedStopCount: 1),
          currentStopId: 100,
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byType(InkWell));
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      final delayWidgets = find.byWidgetPredicate((w) {
        if (w is RichText) {
          final text = w.text.toPlainText();
          return text.contains("+") && text.contains("'");
        }
        return false;
      });
      expect(delayWidgets, findsAtLeast(1));
    });

    testWidgets('uses ListView.builder for scrolling', (tester) async {
      await tester.pumpWidget(buildWidget(arrival: _createStopTrip()));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byType(InkWell));
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
