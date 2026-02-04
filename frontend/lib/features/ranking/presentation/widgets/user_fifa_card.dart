import 'package:flutter/material.dart';
import 'package:aurabus/theme.dart';
import 'package:aurabus/features/ranking/domain/rank_tier.dart';
import 'package:aurabus/features/ranking/presentation/utils/ranking_utils.dart';
import 'package:aurabus/l10n/app_localizations.dart';

class UserFifaCard extends StatelessWidget {
  final RankTier current;
  final RankTier next;
  final int points;

  const UserFifaCard({
    super.key,
    required this.current,
    required this.next,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    int pointsNeeded = next.minPoints - current.minPoints;
    double progress = (pointsNeeded > 0)
        ? (points - current.minPoints) / pointsNeeded
        : 1.0;
    progress = progress.clamp(0.0, 1.0);

    final bool isMax = next.type == TierType.max;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.shield, color: current.color, size: 35),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.yourTier.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      RankingUtils.getTierName(
                        context,
                        current.type,
                      ).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.points.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$points',
                      style: const TextStyle(
                        color: AppColors.ticketOrange,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (isMax)
              Text(
                l10n.maxLevelReached,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${l10n.nextTier} ${RankingUtils.getTierName(context, next.type)}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${next.minPoints - points} ${l10n.missingPoints}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.black26,
                      color: AppColors.ticketOrange,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
