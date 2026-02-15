import 'package:aurabus/features/account/presentation/account_page.dart';
import 'package:aurabus/features/account/widgets/account_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../utils/test_app_wrapper.dart';
import '../../utils/device_definitions.dart';

void main() {
  group('AccountPage Functional Tests', () {
    testWidgets('AccountPage renders correctly', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestApp(child: const AccountPage()));
      await tester.pumpAndSettle();

      expect(find.text('Account Settings'), findsOneWidget);

      expect(find.byType(AccountSection), findsAtLeastNWidgets(4));
    });

    testWidgets('AccountPage sections can expand and collapse', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestApp(child: const AccountPage()));
      await tester.pumpAndSettle();

      final accountInfoSection = find.text('Account Info');
      expect(accountInfoSection, findsOneWidget);

      await tester.tap(accountInfoSection);
      await tester.pumpAndSettle();

      expect(find.byType(AccountSection), findsAtLeastNWidgets(4));

      await tester.tap(accountInfoSection);
      await tester.pumpAndSettle();
    });
  });

  group('AccountPage Responsiveness Tests', () {
    for (var device in TestDevices.all) {
      testWidgets(
        'Renders correctly on ${device.name} (${device.size.width}x${device.size.height})',
        (tester) async {
          tester.view.physicalSize = device.size;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);

          await tester.pumpWidget(createTestApp(child: const AccountPage()));
          await tester.pumpAndSettle();

          expect(find.text('Account Settings'), findsOneWidget);

          expect(find.byType(AccountSection), findsAtLeastNWidgets(4));
        },
      );
    }
  });
}
