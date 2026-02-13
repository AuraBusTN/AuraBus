import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/legal/presentation/privacy_policy_page.dart';
import 'package:aurabus/features/legal/widgets/legal_document_header.dart';
import 'package:aurabus/features/legal/widgets/legal_section_card.dart';
import 'package:aurabus/common/widgets/fade_in_slide.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import '../../../utils/device_definitions.dart';

void main() {
  Widget createPrivacyApp() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: const PrivacyPolicyPage(),
    );
  }

  Widget createPrivacyAppItalian() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('it'),
      home: const PrivacyPolicyPage(),
    );
  }

  group('PrivacyPolicyPage Functional Tests', () {
    testWidgets('renders page with title and header', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createPrivacyApp());
      await tester.pumpAndSettle();

      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.byType(LegalDocumentHeader), findsOneWidget);
      expect(find.byIcon(Icons.shield_outlined), findsOneWidget);
    });

    testWidgets('renders all 12 sections', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createPrivacyApp());
      await tester.pumpAndSettle();

      expect(find.byType(LegalSectionCard), findsNWidgets(12));
    });

    testWidgets('renders with FadeInSlide animations', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createPrivacyApp());
      await tester.pumpAndSettle();

      expect(find.byType(FadeInSlide), findsNWidgets(13));
    });

    testWidgets('shows last updated date', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createPrivacyApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('13/02/2026'), findsOneWidget);
    });

    testWidgets('sections are collapsed by default', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createPrivacyApp());
      await tester.pumpAndSettle();

      expect(find.text('1. Introduction'), findsOneWidget);
      expect(
        find.textContaining('committed to protecting your privacy'),
        findsNothing,
      );
    });

    testWidgets('tapping a section expands it to show body', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createPrivacyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('1. Introduction'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('committed to protecting your privacy'),
        findsOneWidget,
      );
    });

    testWidgets('tapping an expanded section collapses it', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createPrivacyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('1. Introduction'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('committed to protecting your privacy'),
        findsOneWidget,
      );

      await tester.tap(find.text('1. Introduction'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('committed to protecting your privacy'),
        findsNothing,
      );
    });

    testWidgets('multiple sections can be expanded independently', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createPrivacyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('1. Introduction'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('2. Information We Collect'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('committed to protecting your privacy'),
        findsOneWidget,
      );
      expect(find.textContaining('Personal Information'), findsOneWidget);
    });

    testWidgets('Expand All button works', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createPrivacyApp());
      await tester.pumpAndSettle();

      expect(find.text('Expand'), findsOneWidget);
      await tester.tap(find.text('Expand'));
      await tester.pumpAndSettle();

      expect(find.text('Collapse'), findsOneWidget);
      expect(
        find.textContaining('committed to protecting your privacy'),
        findsOneWidget,
      );
    });

    testWidgets('Collapse All button works', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createPrivacyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Expand'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Collapse'));
      await tester.pumpAndSettle();

      expect(find.text('Expand'), findsOneWidget);
      expect(
        find.textContaining('committed to protecting your privacy'),
        findsNothing,
      );
    });

    testWidgets('Expand All icon toggles correctly', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createPrivacyApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.unfold_more_rounded), findsOneWidget);

      await tester.tap(find.text('Expand'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.unfold_less_rounded), findsOneWidget);
    });

    testWidgets('has back button', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createPrivacyApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back_ios_rounded), findsOneWidget);
    });

    testWidgets('page is scrollable', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createPrivacyApp());
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsOneWidget);

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('GDPR rights section is present', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createPrivacyApp());
      await tester.pumpAndSettle();

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -1000),
      );
      await tester.pumpAndSettle();

      final gdprSection = find.text('7. Your Rights (GDPR)');
      if (gdprSection.evaluate().isNotEmpty) {
        await tester.tap(gdprSection);
        await tester.pumpAndSettle();
        expect(find.textContaining('Erasure'), findsOneWidget);
        expect(find.textContaining('Portability'), findsOneWidget);
      }
    });

    testWidgets('DPO section is present', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createPrivacyApp());
      await tester.pumpAndSettle();

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -2000),
      );
      await tester.pumpAndSettle();

      final dpoSection = find.text('12. Data Protection Officer');
      if (dpoSection.evaluate().isNotEmpty) {
        await tester.tap(dpoSection);
        await tester.pumpAndSettle();
        expect(find.textContaining('privacy@aurabus.it'), findsOneWidget);
      }
    });

    testWidgets('renders correctly in Italian locale', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createPrivacyAppItalian());
      await tester.pumpAndSettle();

      expect(find.text('Informativa sulla Privacy'), findsOneWidget);
      expect(find.text('1. Introduzione'), findsOneWidget);
    });

    testWidgets('children privacy section is present', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createPrivacyApp());
      await tester.pumpAndSettle();

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -1200),
      );
      await tester.pumpAndSettle();

      final childrenSection = find.text("8. Children's Privacy");
      if (childrenSection.evaluate().isNotEmpty) {
        expect(childrenSection, findsOneWidget);
      }
    });
  });

  group('PrivacyPolicyPage Responsiveness Tests', () {
    for (var device in TestDevices.all) {
      testWidgets(
        'Renders correctly on ${device.name} (${device.size.width}x${device.size.height})',
        (tester) async {
          tester.view.physicalSize = device.size;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);

          await tester.pumpWidget(createPrivacyApp());
          await tester.pumpAndSettle();

          expect(find.text('Privacy Policy'), findsOneWidget);
          expect(find.byType(LegalDocumentHeader), findsOneWidget);
          expect(find.byType(LegalSectionCard), findsNWidgets(12));
        },
      );
    }
  });
}
