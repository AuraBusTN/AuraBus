import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aurabus/features/map/presentation/stop_details_modal.dart';
import 'package:aurabus/features/map/data/map_providers.dart';
import 'package:aurabus/features/map/data/models/stop_info.dart';
import 'package:aurabus/features/map/data/models/stop_trip_info.dart';
import 'package:aurabus/features/map/data/models/route_info.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:aurabus/theme.dart';

StopInfo _createStopInfo({int stopId = 123, String stopName = 'Piazza Dante'}) {
  return StopInfo(
    stopId: stopId,
    stopName: stopName,
    routes: [
      RouteInfo(
        routeId: 5,
        routeShortName: '5',
        routeLongName: 'Trento - Rovereto',
        routeColor: '#FF0000',
      ),
      RouteInfo(
        routeId: 3,
        routeShortName: '3',
        routeLongName: 'Trento - Sardagna',
        routeColor: '#0000FF',
      ),
    ],
    distance: 100,
    stopCode: '20000z',
    stopDesc: '',
    stopLat: 46.0,
    stopLon: 11.0,
    stopLevel: 0,
    street: 'Via Roma',
    town: 'Trento',
    type: 'U',
    wheelchairBoarding: 0,
  );
}

List<StopTrip> _createStopTrips() {
  final now = DateTime.now().toUtc();
  return [
    StopTrip(
      routeId: 5,
      routeShortName: '5',
      routeLongName: 'Trento - Rovereto',
      routeColor: Colors.red,
      busId: 42,
      busCapacity: 50,
      busType: 'urban',
      occupancy: OccupancyStatus(
        realTime: OccupancyData(percentage: 60, passengers: 30),
        expected: OccupancyData(percentage: 45, passengers: 22),
      ),
      lastUpdate: now.subtract(const Duration(minutes: 2)),
      delay: 0,
      lastStopId: 101,
      nextStopId: 102,
      passedStopCount: 2,
      arrivalTimeScheduled: now.add(const Duration(minutes: 10)),
      arrivalTimeEstimated: now.add(const Duration(minutes: 10)),
      stopTimes: [
        StopTripTime(
          stopId: 100,
          stopName: 'Start',
          arrivalTimeScheduled: '14:00',
          delayPredicted: 0,
        ),
        StopTripTime(
          stopId: 123,
          stopName: 'Piazza Dante',
          arrivalTimeScheduled: '14:15',
          delayPredicted: 0,
        ),
        StopTripTime(
          stopId: 200,
          stopName: 'End',
          arrivalTimeScheduled: '14:30',
          delayPredicted: 0,
        ),
      ],
    ),
  ];
}

void main() {
  Widget buildModal({StopInfo? stopInfo, List<StopTrip>? arrivals}) {
    final stop = stopInfo ?? _createStopInfo();
    final trips = arrivals ?? _createStopTrips();

    return ProviderScope(
      overrides: [
        stopDetailsProvider(stop.stopId).overrideWith((ref) async => trips),
        stopsMapProvider.overrideWith((ref) => {stop.stopId: stop}),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: SizedBox(height: 800, child: StopDetailsModal(stopInfo: stop)),
        ),
      ),
    );
  }

  group('StopDetailsModal', () {
    testWidgets('shows loading indicator initially', (tester) async {
      final stop = _createStopInfo();
      final completer = Completer<List<StopTrip>>();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            stopDetailsProvider(
              stop.stopId,
            ).overrideWith((ref) => completer.future),
            stopsMapProvider.overrideWith((ref) => {stop.stopId: stop}),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: SizedBox(
                height: 800,
                child: StopDetailsModal(stopInfo: stop),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(<StopTrip>[]);
      await tester.pump();
    });

    testWidgets('shows stop name after loading', (tester) async {
      await tester.pumpWidget(buildModal());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Piazza Dante'), findsAtLeast(1));
    });

    testWidgets('shows DragHandle at top', (tester) async {
      await tester.pumpWidget(buildModal());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(DraggableScrollableSheet), findsOneWidget);
    });

    testWidgets('shows BusArrivalCard for arrivals', (tester) async {
      await tester.pumpWidget(buildModal());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('End'), findsAtLeast(1));
    });

    testWidgets('shows Clear button text', (tester) async {
      await tester.pumpWidget(buildModal());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Clear'), findsOneWidget);
    });

    testWidgets('shows empty list when no arrivals', (tester) async {
      await tester.pumpWidget(buildModal(arrivals: []));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Piazza Dante'), findsAtLeast(1));
    });
  });
}
