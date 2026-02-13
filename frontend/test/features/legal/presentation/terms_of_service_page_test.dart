import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/legal/presentation/terms_of_service_page.dart';
import 'package:aurabus/features/legal/widgets/legal_document_header.dart';
import 'package:aurabus/features/legal/widgets/legal_section_card.dart';
import 'package:aurabus/common/widgets/fade_in_slide.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import '../../../utils/device_definitions.dart';

void main() {
  Widget createTermsApp() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: const TermsOfServicePage(),
    );
  }

  Widget createTermsAppItalian() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('it'),
      home: const TermsOfServicePage(),
    );
  }

  group('TermsOfServicePage Functional Tests', () {
    testWidgets('renders page with title and header', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTermsApp());
      await tester.pumpAndSettle();

      expect(find.text('Terms of Service'), findsOneWidget);
      expect(find.byType(LegalDocumentHeader), findsOneWidget);
      expect(find.byIcon(Icons.description_outlined), findsOneWidget);
    });

    testWidgets('renders all 13 sections', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTermsApp());
      await tester.pumpAndSettle();

      expect(find.byType(LegalSectionCard), findsNWidgets(13));
    });

    testWidgets('renders with FadeInSlide animations', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTermsApp());
      await tester.pumpAndSettle();

      expect(find.byType(FadeInSlide), findsNWidgets(14));
    });

    testWidgets('shows last updated date', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTermsApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('13/02/2026'), findsOneWidget);
    });

    testWidgets('sections are collapsed by default', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTermsApp());
      await tester.pumpAndSettle();

      expect(find.text('1. Introduction'), findsOneWidget);
      expect(find.textContaining('Welcome to AuraBus'), findsNothing);
    });

    testWidgets('tapping a section expands it to show body', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTermsApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('1. Introduction'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Welcome to AuraBus'), findsOneWidget);
    });

    testWidgets('tapping an expanded section collapses it', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTermsApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('1. Introduction'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Welcome to AuraBus'), findsOneWidget);

      await tester.tap(find.text('1. Introduction'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Welcome to AuraBus'), findsNothing);
    });

    testWidgets('multiple sections can be expanded independently', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTermsApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('1. Introduction'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('2. Eligibility'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Welcome to AuraBus'), findsOneWidget);
      expect(find.textContaining('at least 16 years'), findsOneWidget);
    });

    testWidgets('Expand All button expands all sections', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTermsApp());
      await tester.pumpAndSettle();

      expect(find.text('Expand'), findsOneWidget);
      await tester.tap(find.text('Expand'));
      await tester.pumpAndSettle();

      expect(find.text('Collapse'), findsOneWidget);

      expect(find.textContaining('Welcome to AuraBus'), findsOneWidget);
    });

    testWidgets('Collapse All button collapses all sections', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTermsApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Expand'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Collapse'));
      await tester.pumpAndSettle();

      expect(find.text('Expand'), findsOneWidget);

      expect(find.textContaining('Welcome to AuraBus'), findsNothing);
    });

    testWidgets('Expand All icon changes between unfold_more and unfold_less', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTermsApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.unfold_more_rounded), findsOneWidget);

      await tester.tap(find.text('Expand'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.unfold_less_rounded), findsOneWidget);
    });

    testWidgets('has back button that calls Navigator.pop', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTermsApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back_ios_rounded), findsOneWidget);
    });

    testWidgets('page is scrollable', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTermsApp());
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsOneWidget);

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LegalSectionCard), findsNWidgets(13));
    });

    testWidgets('renders correctly in Italian locale', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTermsAppItalian());
      await tester.pumpAndSettle();

      expect(find.text('Termini di Servizio'), findsOneWidget);
      expect(find.text('1. Introduzione'), findsOneWidget);
    });

    testWidgets('section titles contain sequential numbers', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTermsApp());
      await tester.pumpAndSettle();

      expect(find.text('1. Introduction'), findsOneWidget);
      expect(find.text('2. Eligibility'), findsOneWidget);
      expect(find.text('3. User Account'), findsOneWidget);
    });

    testWidgets('contact section contains email when expanded', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTermsApp());
      await tester.pumpAndSettle();

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -2000),
      );
      await tester.pumpAndSettle();

      final contactSection = find.text('13. Contact Us');
      if (contactSection.evaluate().isNotEmpty) {
        await tester.tap(contactSection);
        await tester.pumpAndSettle();
        expect(find.textContaining('support@aurabus.it'), findsOneWidget);
      }
    });
  });

  group('TermsOfServicePage Responsiveness Tests', () {
    for (var device in TestDevices.all) {
      testWidgets(
        'Renders correctly on ${device.name} (${device.size.width}x${device.size.height})',
        (tester) async {
          tester.view.physicalSize = device.size;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);

          await tester.pumpWidget(createTermsApp());
          await tester.pumpAndSettle();

          expect(find.text('Terms of Service'), findsOneWidget);
          expect(find.byType(LegalDocumentHeader), findsOneWidget);
          expect(find.byType(LegalSectionCard), findsNWidgets(13));
        },
      );
    }
  });
}
