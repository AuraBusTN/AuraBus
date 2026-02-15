import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aurabus/features/map/widgets/map_search_bar.dart';
import 'package:aurabus/features/map/data/map_providers.dart';
import 'package:aurabus/features/map/data/models/stop_info.dart';
import 'package:aurabus/features/map/data/models/route_info.dart';
import 'package:aurabus/l10n/app_localizations.dart';

void main() {
  late List<StopInfo> stopsWithRoutes;

  setUp(() {
    stopsWithRoutes = [
      StopInfo(
        stopId: 1,
        stopName: 'Stazione Centrale',
        stopLat: 46.071,
        stopLon: 11.123,
        routes: [
          RouteInfo(
            routeId: 5,
            routeShortName: '5',
            routeLongName: 'Route 5',
            routeColor: '#FF0000',
          ),
          RouteInfo(
            routeId: 3,
            routeShortName: '3',
            routeLongName: 'Route 3',
            routeColor: '#0000FF',
          ),
        ],
        distance: 0,
        stopCode: '001',
        stopDesc: '',
        stopLevel: 0,
        street: 'Via Test',
        type: 'bus_stop',
        wheelchairBoarding: 1,
        town: 'Trento',
      ),
    ];
  });

  testWidgets('search results show route badges for stops with routes', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [stopsListProvider.overrideWith((ref) => stopsWithRoutes)],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: MapSearchBar()),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Stazione');
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Stazione Centrale'), findsOneWidget);

    expect(find.text('5'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('entering empty text clears results', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [stopsListProvider.overrideWith((ref) => stopsWithRoutes)],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: MapSearchBar()),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Stazione');
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Stazione Centrale'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '');
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('clear button clears text and results', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [stopsListProvider.overrideWith((ref) => stopsWithRoutes)],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: MapSearchBar()),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Stazione');
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();

    final TextField textField = tester.widget(find.byType(TextField));
    expect(textField.controller?.text, isEmpty);

    expect(find.byType(ListTile), findsNothing);
  });
}
