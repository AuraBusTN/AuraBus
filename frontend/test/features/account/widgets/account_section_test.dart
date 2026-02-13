import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/account/widgets/account_section.dart';

void main() {
  group('AccountSection', () {
    Widget buildSection({
      required String title,
      required bool isExpanded,
      required VoidCallback onTap,
      Widget? child,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: AccountSection(
            title: title,
            isExpanded: isExpanded,
            onTap: onTap,
            child: child,
          ),
        ),
      );
    }

    testWidgets('renders title text', (tester) async {
      await tester.pumpWidget(
        buildSection(title: 'Test Section', isExpanded: false, onTap: () {}),
      );

      expect(find.text('Test Section'), findsOneWidget);
    });

    testWidgets('shows chevron_right when collapsed', (tester) async {
      await tester.pumpWidget(
        buildSection(title: 'Collapsed', isExpanded: false, onTap: () {}),
      );

      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
      expect(find.byIcon(Icons.expand_less), findsNothing);
    });

    testWidgets('shows expand_less when expanded', (tester) async {
      await tester.pumpWidget(
        buildSection(
          title: 'Expanded',
          isExpanded: true,
          onTap: () {},
          child: const Text('Child Content'),
        ),
      );

      expect(find.byIcon(Icons.expand_less), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsNothing);
    });

    testWidgets('shows child content when expanded', (tester) async {
      await tester.pumpWidget(
        buildSection(
          title: 'Expanded',
          isExpanded: true,
          onTap: () {},
          child: const Text('Child Content'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Child Content'), findsOneWidget);
    });

    testWidgets('hides child content when collapsed', (tester) async {
      await tester.pumpWidget(
        buildSection(
          title: 'Collapsed',
          isExpanded: false,
          onTap: () {},
          child: const Text('Hidden Content'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Hidden Content'), findsNothing);
    });

    testWidgets('tapping the ListTile calls onTap', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        buildSection(
          title: 'Tappable',
          isExpanded: false,
          onTap: () => tapped = true,
        ),
      );

      await tester.tap(find.text('Tappable'));
      expect(tapped, isTrue);
    });

    testWidgets('renders without child when null', (tester) async {
      await tester.pumpWidget(
        buildSection(
          title: 'No Child',
          isExpanded: true,
          onTap: () {},
          child: null,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No Child'), findsOneWidget);
    });

    testWidgets('has AnimatedContainer for animation', (tester) async {
      await tester.pumpWidget(
        buildSection(title: 'Animated', isExpanded: false, onTap: () {}),
      );

      expect(find.byType(AnimatedContainer), findsOneWidget);
    });

    testWidgets('has AnimatedSize for child reveal', (tester) async {
      await tester.pumpWidget(
        buildSection(
          title: 'Animated',
          isExpanded: false,
          onTap: () {},
          child: const Text('Content'),
        ),
      );

      expect(find.byType(AnimatedSize), findsOneWidget);
    });
  });
}
