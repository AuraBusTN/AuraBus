@TestOn('browser')
library;
import 'package:aurabus/features/map/presentation/map_controller.dart';
import 'package:aurabus/features/map/data/map_providers.dart';
import 'package:aurabus/features/map/data/models/stop_trip_info.dart';
import 'package:aurabus/features/map/data/models/stop_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

void main() {
  testWidgets('Web: stop modal blocks pointer events behind it', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stopDetailsProvider(123).overrideWith((ref) async => <StopTrip>[]),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Consumer(
                  builder: (context, ref, _) {
                    return ElevatedButton(
                      onPressed: () {
                        final controller = ref.read(mapControllerProvider);

                        final dummyStop = StopInfo(
                          stopId: 123,
                          stopName: 'Stazione Centrale',
                          routes: [],
                          distance: 0,
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

                        controller.openStopModal(context, dummyStop);
                      },
                      child: const Text('Open Modal'),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Modal'));
    await tester.pumpAndSettle();

    expect(find.text('123 - Stazione Centrale'), findsOneWidget);
    expect(find.byType(PointerInterceptor), findsWidgets);
  });
}
