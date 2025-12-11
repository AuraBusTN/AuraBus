import 'package:flutter/material.dart';
import 'package:aurabus/features/map/data/models/stop_trip_info.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:aurabus/theme.dart';

class RouteFilterCard extends StatelessWidget {
  final StopTrip line;
  final bool isSelected;
  final VoidCallback onTap;

  const RouteFilterCard({
    super.key,
    required this.line,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primary = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: isSelected ? primary.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              offset: const Offset(0, 4),
              color: Colors.black.withValues(alpha: 0.08),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/bus_icon.png',
              width: 50, // Increased icon size
              height: 50,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Icon(
                Icons.directions_bus,
                color: isSelected ? primary : Colors.grey,
                size: 50,
              ),
            ),
            Text(
              l10n.lineTitle(line.routeShortName),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? primary : AppColors.textPrimary,
                fontSize: 13, // Slightly larger text
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
