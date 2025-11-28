import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aurabus/features/tickets/widgets/ticket_card.dart';

class TicketPage extends ConsumerWidget {
  const TicketPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            children: [
              Text(
                'Your Tickets',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              const TicketCard(),
              const SizedBox(height: 20),
              const TicketCard(),
              const SizedBox(height: 20),
              const TicketCard(),
            ],
          ),
        ),
      ),
    );
  }
}
