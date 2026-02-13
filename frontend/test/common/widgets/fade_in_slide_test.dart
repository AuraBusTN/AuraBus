import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/common/widgets/fade_in_slide.dart';

void main() {
  group('FadeInSlide', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FadeInSlide(delay: 0.0, child: const Text('Hello')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('contains FadeTransition', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FadeInSlide(delay: 0.0, child: const Text('Test')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(FadeTransition), findsAtLeast(1));
    });

    testWidgets('contains SlideTransition', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FadeInSlide(delay: 0.0, child: const Text('Test')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(SlideTransition), findsAtLeast(1));
    });

    testWidgets('animates to visible after delay', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FadeInSlide(delay: 0.1, child: const Text('Animated')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Animated'), findsOneWidget);
    });

    testWidgets('works with zero delay', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FadeInSlide(delay: 0.0, child: const Text('Immediate')),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Immediate'), findsOneWidget);
    });
  });
}
