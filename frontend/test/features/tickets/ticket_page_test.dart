import 'package:aurabus/features/tickets/presentation/ticket_page.dart';
import 'package:aurabus/features/tickets/widgets/ticket_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../utils/test_app_wrapper.dart';

void main() {
  testWidgets('TicketPage renders correctly', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createTestApp(child: const TicketPage()));

    await tester.pumpAndSettle();

    expect(find.text('My Tickets'), findsOneWidget);

    expect(find.byType(TicketCard), findsNWidgets(3));

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -200),
    );
    await tester.pump();
  });
}
