import 'package:aurabus/features/tickets/presentation/ticket_page.dart';
import 'package:aurabus/features/tickets/widgets/ticket_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TicketPage renders correctly', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp(home: const TicketPage())),
    );

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
