import 'package:aurabus/common/models/stop_details.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:aurabus/theme.dart';
import 'package:flutter/material.dart';

class LineCard extends StatelessWidget {
  final StopArrival line;
  final bool isSelected;
  final VoidCallback onTap;

  const LineCard({
    super.key, 
    required this.line,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? AppColors.primary.withValues(alpha: 0.8)
        : AppColors.divider;
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 70,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              offset: const Offset(0, 3),
              color: AppColors.divider,
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/bus_icon.png',
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 2),
            Text(
              l10n.lineTitle(line.routeShortName),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}