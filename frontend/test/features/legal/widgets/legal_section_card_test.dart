import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/legal/data/legal_section.dart';
import 'package:aurabus/features/legal/widgets/legal_section_card.dart';

void main() {
  const testSection = LegalSection(
    title: '1. Introduction',
    body: 'Welcome to AuraBus. These terms govern your use of the application.',
  );

  Widget createCardApp({
    LegalSection section = testSection,
    bool isExpanded = false,
    VoidCallback? onTap,
    int index = 0,
  }) {
    bool expanded = isExpanded;
    return MaterialApp(
      home: Scaffold(
        body: StatefulBuilder(
          builder: (context, setState) {
            return LegalSectionCard(
              section: section,
              isExpanded: expanded,
              onTap: onTap ?? () => setState(() => expanded = !expanded),
            );
          },
        ),
      ),
    );
  }

  group('LegalSectionCard Widget', () {
    testWidgets('renders section title when collapsed', (tester) async {
      await tester.pumpWidget(createCardApp());

      expect(find.text('1. Introduction'), findsOneWidget);

      expect(
        find.text(
          'Welcome to AuraBus. These terms govern your use of the application.',
        ),
        findsNothing,
      );
    });

    testWidgets('renders section title and body when expanded', (tester) async {
      await tester.pumpWidget(createCardApp(isExpanded: true));
      await tester.pumpAndSettle();

      expect(find.text('1. Introduction'), findsOneWidget);
      expect(
        find.text(
          'Welcome to AuraBus. These terms govern your use of the application.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('has chevron icon that rotates on expansion', (tester) async {
      await tester.pumpWidget(createCardApp());

      expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);

      // Check AnimatedRotation is present
      expect(find.byType(AnimatedRotation), findsOneWidget);

      // When collapsed, rotation turns should be 0
      final AnimatedRotation rotation = tester.widget(
        find.byType(AnimatedRotation),
      );
      expect(rotation.turns, 0);
    });

    testWidgets('chevron rotates when expanded', (tester) async {
      await tester.pumpWidget(createCardApp(isExpanded: true));
      await tester.pumpAndSettle();

      final AnimatedRotation rotation = tester.widget(
        find.byType(AnimatedRotation),
      );
      expect(rotation.turns, 0.5);
    });

    testWidgets('calls onTap callback when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(createCardApp(onTap: () => tapped = true));

      await tester.tap(find.byType(InkWell));
      expect(tapped, isTrue);
    });

    testWidgets('shows divider when expanded', (tester) async {
      await tester.pumpWidget(createCardApp(isExpanded: true));
      await tester.pumpAndSettle();

      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('does not show divider when collapsed', (tester) async {
      await tester.pumpWidget(createCardApp(isExpanded: false));
      await tester.pumpAndSettle();

      expect(find.byType(Divider), findsNothing);
    });

    testWidgets('has AnimatedContainer for smooth transitions', (tester) async {
      await tester.pumpWidget(createCardApp());

      expect(find.byType(AnimatedContainer), findsOneWidget);
    });

    testWidgets('has AnimatedSize for body reveal', (tester) async {
      await tester.pumpWidget(createCardApp());

      expect(find.byType(AnimatedSize), findsOneWidget);
    });

    testWidgets('renders multiline body text correctly', (tester) async {
      const multilineSection = LegalSection(
        title: 'Data Collected',
        body:
            'We collect:\n\n• Personal Information\n• Location Data\n• Usage Data',
      );
      await tester.pumpWidget(
        createCardApp(section: multilineSection, isExpanded: true),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Personal Information'), findsOneWidget);
      expect(find.textContaining('Location Data'), findsOneWidget);
    });

    testWidgets('handles long title text', (tester) async {
      const longTitleSection = LegalSection(
        title: '7. A Very Long Section Title That Tests Text Overflow Handling',
        body: 'Short body.',
      );
      await tester.pumpWidget(createCardApp(section: longTitleSection));

      expect(find.textContaining('A Very Long Section Title'), findsOneWidget);
    });
  });
}
