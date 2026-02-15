import 'package:flutter/material.dart';
import 'package:aurabus/theme.dart';
import 'package:aurabus/features/ranking/domain/rank_tier.dart';
import 'package:aurabus/features/ranking/presentation/utils/ranking_utils.dart';

class TiersList extends StatelessWidget {
  final int userPoints;
  const TiersList({super.key, required this.userPoints});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: RankTier.allTiers.map((tier) {
        final isAchieved = userPoints >= tier.minPoints;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isAchieved ? tier.color : AppColors.border,
              width: isAchieved ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: tier.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      RankingUtils.getTierName(context, tier.type),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: tier.color,
                      ),
                    ),
                    Text(
                      RankingUtils.getTierReward(context, tier.type),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isAchieved ? Icons.check_circle : Icons.lock_outline,
                color: isAchieved ? Colors.green : Colors.grey,
                size: 20,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
