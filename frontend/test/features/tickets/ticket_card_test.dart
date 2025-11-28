import 'package:aurabus/features/tickets/widgets/ticket_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TicketCard renders correct static info', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: const TicketCard())),
    );

    expect(find.text('Servizio Urbano'), findsOneWidget);
    expect(find.text('TRENTO'), findsOneWidget);
    expect(find.text('70 minuti'), findsOneWidget);
    expect(find.text('UNUSED'), findsOneWidget);
    expect(find.text('Validate'), findsOneWidget);
  });
}
