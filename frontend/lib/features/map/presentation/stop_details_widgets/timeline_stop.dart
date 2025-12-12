import 'package:aurabus/common/models/stop_details.dart';
import 'package:aurabus/theme.dart';
import 'package:flutter/material.dart';

class TimelineStop extends StatelessWidget {
  final StopTime stop;
  final int delay;
  final bool isPastOrCurrent;
  final bool isThisStop;
  final bool isFirst;
  final bool isLast;

  const TimelineStop({
    required this.stop,
    required this.delay,
    required this.isPastOrCurrent,
    required this.isThisStop,
    required this.isFirst,
    required this.isLast,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mainColor = isPastOrCurrent
        ? AppColors.primary
        : AppColors.textSecondary;

    final stopTime = stop.arrivalTimeScheduled.length >= 5
        ? stop.arrivalTimeScheduled.substring(0, 5)
        : stop.arrivalTimeScheduled;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (!isFirst) Container(width: 2, height: 12, color: mainColor),

            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: mainColor,
                shape: BoxShape.circle,
              ),
            ),

            if (!isLast) Container(width: 2, height: 36, color: mainColor),
          ],
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                      children: [
                        TextSpan(text: stopTime),
                        if (!isPastOrCurrent && delay != 0)
                          TextSpan(
                            text: delay > 0 ? "  +$delay'" : "  $delay'",
                            style: TextStyle(
                              color: delay > 0 ? Colors.red : Colors.purple,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    stop.stopName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isThisStop
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}