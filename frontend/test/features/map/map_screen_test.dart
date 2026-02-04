import 'package:aurabus/features/map/presentation/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../utils/test_app_wrapper.dart';
import '../../utils/device_definitions.dart';

void main() {
  group('MapScreen Functional Tests', () {
    testWidgets('MapScreen renders correctly', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestApp(child: const MapScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(MapScreen), findsOneWidget);
    });
  });

  group('MapScreen Responsiveness Tests', () {
    for (var device in TestDevices.all) {
      testWidgets(
        'Renders correctly on ${device.name} (${device.size.width}x${device.size.height})',
        (tester) async {
          tester.view.physicalSize = device.size;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);

          await tester.pumpWidget(createTestApp(child: const MapScreen()));
          await tester.pumpAndSettle();

          expect(find.byType(MapScreen), findsOneWidget);
        },
      );
    }
  });
}
