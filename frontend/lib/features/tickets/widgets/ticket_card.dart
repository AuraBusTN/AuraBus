import 'package:flutter/material.dart';
import 'package:aurabus/theme.dart';

class TicketCard extends StatelessWidget {
  const TicketCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Column(
        children: [
          _TicketHeader(),
          SizedBox(height: 5),
          _TicketDivider(),
          SizedBox(height: 5),
          _TicketBody(),
        ],
      ),
    );
  }
}

class _TicketHeader extends StatelessWidget {
  const _TicketHeader();
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          'assets/images/tt_logo.png',
          height: 32,
          fit: BoxFit.contain,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Servizio Urbano', style: textTheme.labelMedium),
            Text('TRENTO', style: textTheme.titleMedium),
          ],
        ),
      ],
    );
  }
}

class _TicketDivider extends StatelessWidget {
  const _TicketDivider();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.divider, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Text(
            'P.IVA 01807370224',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        const Expanded(child: Divider(color: AppColors.divider, height: 1)),
      ],
    );
  }
}

class _TicketBody extends StatelessWidget {
  const _TicketBody();
  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 4, child: _TicketInfoPanel()),
        SizedBox(width: 16),
        Expanded(flex: 2, child: _TicketQrPanel()),
      ],
    );
  }
}

class _TicketInfoPanel extends StatelessWidget {
  const _TicketInfoPanel();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Row(
          children: [
            _InfoPill(text: '70 minuti', isFirst: true),
            SizedBox(width: 1.5),
            _InfoPill(text: '€ 1.20', isLast: true, isItalic: true),
          ],
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textPrimary, width: 1.5),
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: const Text(
            'Validate',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _TicketQrPanel extends StatelessWidget {
  const _TicketQrPanel();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.qrBackground, // Dal Tema
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Image.asset('assets/images/ticket_qr.png', fit: BoxFit.contain),
          const SizedBox(height: 4),
          Text(
            'UNUSED',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.text,
    this.isFirst = false,
    this.isLast = false,
    this.isItalic = false,
  });
  final String text;
  final bool isFirst;
  final bool isLast;
  final bool isItalic;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary, // Arancione dal tema
          borderRadius: BorderRadius.horizontal(
            left: isFirst ? const Radius.circular(4) : Radius.zero,
            right: isLast ? const Radius.circular(4) : Radius.zero,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.ticketPillText,
            fontWeight: FontWeight.bold,
            fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
