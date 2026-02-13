import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aurabus/features/map/data/map_providers.dart';
import 'package:aurabus/features/map/data/models/route_info.dart';

void main() {
  group('SelectedLinesNotifier', () {
    late ProviderContainer container;
    late SelectedLinesNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(selectedLinesProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is empty set', () {
      final state = container.read(selectedLinesProvider);
      expect(state, isEmpty);
    });

    test('toggle adds a route', () {
      final route = RouteInfo(
        routeId: 1,
        routeShortName: '5',
        routeLongName: 'Test Route',
        routeColor: '#FF0000',
      );

      notifier.toggle(route);
      final state = container.read(selectedLinesProvider);

      expect(state.length, 1);
      expect(state.contains(route), isTrue);
    });

    test('toggle removes a route that was already added', () {
      final route = RouteInfo(
        routeId: 1,
        routeShortName: '5',
        routeLongName: 'Test Route',
        routeColor: '#FF0000',
      );

      notifier.toggle(route);
      expect(container.read(selectedLinesProvider).length, 1);

      notifier.toggle(route);
      expect(container.read(selectedLinesProvider).length, 0);
    });

    test('setRoutes replaces current selection', () {
      final route1 = RouteInfo(
        routeId: 1,
        routeShortName: '5',
        routeLongName: 'Route A',
        routeColor: '#FF0000',
      );
      final route2 = RouteInfo(
        routeId: 2,
        routeShortName: '3',
        routeLongName: 'Route B',
        routeColor: '#0000FF',
      );

      notifier.setRoutes({route1, route2});
      final state = container.read(selectedLinesProvider);

      expect(state.length, 2);
      expect(state.contains(route1), isTrue);
      expect(state.contains(route2), isTrue);
    });

    test('clear empties the selection', () {
      final route = RouteInfo(
        routeId: 1,
        routeShortName: '5',
        routeLongName: 'Route A',
        routeColor: '#FF0000',
      );

      notifier.toggle(route);
      expect(container.read(selectedLinesProvider), isNotEmpty);

      notifier.clear();
      expect(container.read(selectedLinesProvider), isEmpty);
    });

    test('toggle multiple routes', () {
      final route1 = RouteInfo(
        routeId: 1,
        routeShortName: '5',
        routeLongName: 'Route A',
        routeColor: '#FF0000',
      );
      final route2 = RouteInfo(
        routeId: 2,
        routeShortName: '3',
        routeLongName: 'Route B',
        routeColor: '#0000FF',
      );
      final route3 = RouteInfo(
        routeId: 3,
        routeShortName: '1',
        routeLongName: 'Route C',
        routeColor: '#00FF00',
      );

      notifier.toggle(route1);
      notifier.toggle(route2);
      notifier.toggle(route3);
      expect(container.read(selectedLinesProvider).length, 3);

      notifier.toggle(route2);
      final state = container.read(selectedLinesProvider);
      expect(state.length, 2);
      expect(state.contains(route1), isTrue);
      expect(state.contains(route2), isFalse);
      expect(state.contains(route3), isTrue);
    });
  });
}
