import 'package:aurabus/common/models/stop_details.dart';
import 'package:aurabus/common/widgets/bus_rectangle.dart';
import 'package:aurabus/features/map/presentation/stop_details_modal.dart';
import 'package:aurabus/features/map/presentation/stop_details_widgets/blinking_dot.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:aurabus/theme.dart';
import 'package:flutter/material.dart';

class BusCardHeader extends StatelessWidget {
  final StopArrival arrival;

  const BusCardHeader({super.key, required this.arrival});

  static const int _kPlaceholderOvercrowding = 0;

  @override
  Widget build(BuildContext context) {
    final updatedAt = arrival.lastUpdate;
    UpdateStatus status;
    if (updatedAt == null) {
      status = UpdateStatus.none;
    } else {
      final diffMinutes = DateTime.now().difference(updatedAt).inMinutes;
      status = diffMinutes <= 5 ? UpdateStatus.fresh : UpdateStatus.stale;
    }

    final delay = arrival.delay ?? 0;
    final scheduledTime = arrival.arrivalTimeScheduled.toLocal();
    final timeStr = TimeOfDay.fromDateTime(scheduledTime).format(context);

    Widget buildTime() {
      const baseStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

      if (delay == 0) {
        return SizedBox(
          width: 72,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(timeStr, style: baseStyle),
          ),
        );
      }

      final sign = delay > 0 ? "+$delay" : "$delay";
      final color = delay > 0 ? Colors.red : Colors.purple;

      return SizedBox(
        width: 72,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Text(timeStr, style: baseStyle),
            ),
            Positioned(
              right: -10,
              top: -10,
              child: Text(
                "$sign'",
                style: baseStyle.copyWith(fontSize: 11, color: color),
              ),
            ),
          ],
        ),
      );
    }

    final overcrowding = _kPlaceholderOvercrowding;
    final overcrowdingFraction = overcrowding / 100.0;

    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now().toUtc();
    final diff = arrival.arrivalTimeEstimated.difference(now);
    final minutes = (diff.inSeconds / 60).ceil();
    var hereIn = l10n.arrivingIn(minutes);

    // If arrival is in the past → show 0
    if (diff.isNegative) {
      hereIn = l10n.arrivingIn(0);
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: .06),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          if (status != UpdateStatus.none) ...[
            BlinkingDot(
              color: status == UpdateStatus.fresh
                  ? Colors.green
                  : Colors.orange,
            ),
            const SizedBox(width: 8),
          ] else
            const SizedBox(width: 20),
          BusRectangle.fromStopArrival(arrival,3), 
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  arrival.stopTimes.last.stopName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: overcrowdingFraction,
                          minHeight: 5,
                          backgroundColor: Colors.grey.shade300,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "$overcrowding%",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildTime(),
              const SizedBox(height: 2),
              Text(
                hereIn,
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}