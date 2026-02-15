import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/map/data/map_providers.dart';
import 'package:aurabus/features/map/data/models/route_info.dart';
import 'package:aurabus/features/map/data/models/stop_info.dart';
import 'package:aurabus/features/map/data/models/stop_trip_info.dart';

final _stops = [
  StopInfo(
    stopId: 1,
    stopName: 'Stop A',
    routes: [],
    distance: 100,
    stopCode: 'A',
    stopDesc: '',
    stopLat: 46.0,
    stopLon: 11.0,
    stopLevel: 0,
    street: 'Via A',
    town: 'Trento',
    type: 'U',
    wheelchairBoarding: 0,
  ),
  StopInfo(
    stopId: 2,
    stopName: 'Stop B',
    routes: [],
    distance: 200,
    stopCode: 'B',
    stopDesc: '',
    stopLat: 46.1,
    stopLon: 11.1,
    stopLevel: 0,
    street: 'Via B',
    town: 'Trento',
    type: 'U',
    wheelchairBoarding: 0,
  ),
];

void main() {
  group('map_providers unit tests', () {
    test('stopsListProvider returns stops', () async {
      final container = ProviderContainer(
        overrides: [stopsListProvider.overrideWith((ref) async => _stops)],
      );
      addTearDown(container.dispose);

      final stops = await container.read(stopsListProvider.future);
      expect(stops.length, 2);
      expect(stops[0].stopName, 'Stop A');
      expect(stops[1].stopName, 'Stop B');
    });

    test('allRoutesProvider returns routes', () async {
      final container = ProviderContainer(
        overrides: [
          allRoutesProvider.overrideWith(
            (ref) async => [
              RouteInfo(
                routeId: 5,
                routeShortName: '5',
                routeLongName: 'Route 5',
                routeColor: '#FF0000',
              ),
            ],
          ),
        ],
      );
      addTearDown(container.dispose);

      final routes = await container.read(allRoutesProvider.future);
      expect(routes.length, 1);
      expect(routes[0].routeShortName, '5');
    });

    test('stopDetailsProvider returns trip data', () async {
      final container = ProviderContainer(
        overrides: [
          stopDetailsProvider(1).overrideWith((ref) async => <StopTrip>[]),
        ],
      );
      addTearDown(container.dispose);

      final trips = await container.read(stopDetailsProvider(1).future);
      expect(trips, isEmpty);
    });

    test('stopsMapProvider returns map of stopId to StopInfo', () async {
      final container = ProviderContainer(
        overrides: [stopsListProvider.overrideWith((ref) async => _stops)],
      );
      addTearDown(container.dispose);

      await container.read(stopsListProvider.future);

      final stopsMap = container.read(stopsMapProvider);
      expect(stopsMap.length, 2);
      expect(stopsMap[1]!.stopName, 'Stop A');
      expect(stopsMap[2]!.stopName, 'Stop B');
    });

    test(
      'stopsMapProvider returns empty map when stopsListProvider not loaded',
      () {
        final container = ProviderContainer(
          overrides: [
            stopsListProvider.overrideWith(
              (ref) => Future<List<StopInfo>>.error('not loaded'),
            ),
          ],
        );
        addTearDown(container.dispose);

        final stopsMap = container.read(stopsMapProvider);
        expect(stopsMap, isEmpty);
      },
    );
  });

  group('SelectedLinesNotifier', () {
    test('toggle adds and removes route', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final route = RouteInfo(
        routeId: 5,
        routeShortName: '5',
        routeLongName: 'Route 5',
        routeColor: '#FF0000',
      );

      expect(container.read(selectedLinesProvider), isEmpty);

      container.read(selectedLinesProvider.notifier).toggle(route);
      expect(container.read(selectedLinesProvider), contains(route));

      container.read(selectedLinesProvider.notifier).toggle(route);
      expect(container.read(selectedLinesProvider), isEmpty);
    });

    test('setRoutes replaces state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final routes = {
        RouteInfo(
          routeId: 5,
          routeShortName: '5',
          routeLongName: 'Route 5',
          routeColor: '#FF0000',
        ),
      };

      container.read(selectedLinesProvider.notifier).setRoutes(routes);
      expect(container.read(selectedLinesProvider).length, 1);
    });

    test('clear empties the state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final route = RouteInfo(
        routeId: 5,
        routeShortName: '5',
        routeLongName: 'Route 5',
        routeColor: '#FF0000',
      );

      container.read(selectedLinesProvider.notifier).toggle(route);
      expect(container.read(selectedLinesProvider).length, 1);

      container.read(selectedLinesProvider.notifier).clear();
      expect(container.read(selectedLinesProvider), isEmpty);
    });
  });
}
