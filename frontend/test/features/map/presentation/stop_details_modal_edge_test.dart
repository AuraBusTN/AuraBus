import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:aurabus/features/map/presentation/stop_details_modal.dart';
import 'package:aurabus/features/map/data/map_providers.dart';
import 'package:aurabus/features/map/data/models/stop_info.dart';
import 'package:aurabus/features/map/data/models/stop_trip_info.dart';
import 'package:aurabus/features/map/data/models/route_info.dart';
import 'package:aurabus/features/map/widgets/route_filter_card.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:aurabus/theme.dart';

StopInfo _createStopInfo() {
  return StopInfo(
    stopId: 123,
    stopName: 'Piazza Dante',
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
    StopTrip(
      routeId: 3,
      routeShortName: '3',
      routeLongName: 'Trento - Sardagna',
      routeColor: Colors.blue,
      busId: 43,
      busCapacity: 40,
      busType: 'urban',
      occupancy: OccupancyStatus(
        realTime: OccupancyData(percentage: 30, passengers: 12),
        expected: OccupancyData(percentage: 25, passengers: 10),
      ),
      lastUpdate: now.subtract(const Duration(minutes: 1)),
      delay: 0,
      lastStopId: 201,
      nextStopId: 202,
      passedStopCount: 1,
      arrivalTimeScheduled: now.add(const Duration(minutes: 5)),
      arrivalTimeEstimated: now.add(const Duration(minutes: 5)),
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
          arrivalTimeScheduled: '14:10',
          delayPredicted: 0,
        ),
        StopTripTime(
          stopId: 300,
          stopName: 'Sardagna',
          arrivalTimeScheduled: '14:20',
          delayPredicted: 0,
        ),
      ],
    ),
  ];
}

void main() {
  final stop = _createStopInfo();

  Widget buildModalWidget({required List<Override> overrides}) {
    return ProviderScope(
      overrides: [
        stopsMapProvider.overrideWith((ref) => {stop.stopId: stop}),
        ...overrides,
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

  group('StopDetailsModal edge cases', () {
    testWidgets('tapping a RouteFilterCard toggles filtering', (tester) async {
      final trips = _createStopTrips();
      await tester.pumpWidget(
        buildModalWidget(
          overrides: [
            stopDetailsProvider(stop.stopId).overrideWith((ref) async => trips),
          ],
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(RouteFilterCard), findsNWidgets(2));

      await tester.tap(find.byType(RouteFilterCard).first);
      await tester.pump();

      expect(find.byType(RouteFilterCard), findsNWidgets(2));
    });

    testWidgets('Clear button clears selected lines', (tester) async {
      final trips = _createStopTrips();
      await tester.pumpWidget(
        buildModalWidget(
          overrides: [
            stopDetailsProvider(stop.stopId).overrideWith((ref) async => trips),
          ],
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byType(RouteFilterCard).first);
      await tester.pump();

      final clearButton = find.text('Clear');
      await tester.tap(clearButton);
      await tester.pump();

      expect(find.byType(RouteFilterCard), findsNWidgets(2));
    });
  });
}
