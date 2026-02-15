import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:aurabus/features/map/widgets/map_search_bar.dart';
import 'package:aurabus/features/map/presentation/map_controller.dart';
import 'package:aurabus/features/map/data/map_providers.dart';
import 'package:aurabus/features/map/data/models/stop_info.dart';
import 'package:aurabus/l10n/app_localizations.dart';

class ManualMapController extends MapController {
  ManualMapController(super.ref);

  bool animateCameraCalled = false;

  @override
  void onMapCreated(GoogleMapController c) {}

  @override
  GoogleMapController? get controller => ManualGoogleMapController(this);
}

class ManualGoogleMapController extends Fake implements GoogleMapController {
  final ManualMapController parent;
  ManualGoogleMapController(this.parent);

  @override
  Future<void> animateCamera(
    CameraUpdate cameraUpdate, {
    Duration? duration,
  }) async {
    parent.animateCameraCalled = true;
  }
}

void main() {
  late List<StopInfo> dummyStops;

  setUp(() {
    dummyStops = [
      StopInfo(
        stopId: 1,
        stopName: "Stazione Centrale",
        stopLat: 46.071,
        stopLon: 11.123,
        routes: [],
        distance: 0,
        stopCode: '001',
        stopDesc: 'Central Station',
        stopLevel: 0,
        street: 'Piazza Dante',
        type: 'bus_stop',
        wheelchairBoarding: 1,
        town: 'Trento',
      ),
      StopInfo(
        stopId: 2,
        stopName: "Piazza Fiera",
        stopLat: 46.065,
        stopLon: 11.121,
        routes: [],
        distance: 0,
        stopCode: '002',
        stopDesc: 'Market Square',
        stopLevel: 0,
        street: 'Piazza Fiera',
        type: 'bus_stop',
        wheelchairBoarding: 1,
        town: 'Trento',
      ),
    ];
  });

  testWidgets('MapSearchBar filters results with debouncing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [stopsListProvider.overrideWith((ref) => dummyStops)],
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
    expect(find.text('Piazza Fiera'), findsNothing);
  });

  testWidgets('Selecting a result updates UI and animates camera', (
    WidgetTester tester,
  ) async {
    late ManualMapController manualController;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stopsListProvider.overrideWith((ref) => dummyStops),
          mapControllerProvider.overrideWith((ref) {
            manualController = ManualMapController(ref);
            return manualController;
          }),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: MapSearchBar()),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Fiera');
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.text('Piazza Fiera'));
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsNothing);
    expect(find.text('Piazza Fiera'), findsOneWidget);
    expect(manualController.animateCameraCalled, isTrue);
  });

  testWidgets('Clear button resets search state', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [stopsListProvider.overrideWith((ref) => dummyStops)],
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
