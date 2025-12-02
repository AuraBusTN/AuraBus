import 'package:aurabus/features/map/presentation/map_controller.dart';
import 'package:aurabus/features/map/data/map_providers.dart';
import 'package:aurabus/features/map/data/models/stop_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/l10n/app_localizations.dart';

void main() {
  testWidgets('MapController opens modal correctly', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stopDetailsProvider(123).overrideWith((ref) async => <StopArrival>[]),
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
                        controller.openStopModal(
                          context,
                          123,
                          'Stazione Centrale',
                        );
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

    expect(find.text('STOP_123 - Stazione Centrale'), findsOneWidget);
  });
}
