import 'package:aurabus/features/tickets/widgets/ticket_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../utils/test_app_wrapper.dart';

void main() {
  testWidgets('TicketCard renders correct static info', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createTestApp(child: const TicketCard()));

    await tester.pumpAndSettle();

    expect(find.text('Urban Service'), findsOneWidget);
    expect(find.text('TRENTO'), findsOneWidget);
    expect(find.text('70 minutes'), findsOneWidget);
    expect(find.text('UNUSED'), findsOneWidget);
    expect(find.text('Validate'), findsOneWidget);
  });
}
