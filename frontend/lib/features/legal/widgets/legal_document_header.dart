import 'package:flutter/material.dart';

class LegalDocumentHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String lastUpdated;

  const LegalDocumentHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 32, color: theme.colorScheme.primary),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(fontSize: 22),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            lastUpdated,
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.grey.shade600,
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
