import 'package:flutter/material.dart';

enum TierType { elite, gold, silver, bronze, max }

class RankTier {
  final TierType type;
  final int minPoints;
  final Color color;

  const RankTier({
    required this.type,
    required this.minPoints,
    required this.color,
  });

  static const List<RankTier> allTiers = [
    RankTier(type: TierType.elite, minPoints: 2000, color: Colors.purple),
    RankTier(type: TierType.gold, minPoints: 1500, color: Colors.amber),
    RankTier(type: TierType.silver, minPoints: 1000, color: Color(0xFFBDBDBD)),
    RankTier(type: TierType.bronze, minPoints: 0, color: Color(0xFF8D6E63)),
  ];

  static ({RankTier current, RankTier next}) getTierInfo(int points) {
    RankTier current = allTiers.last;
    RankTier next = allTiers.first;

    for (int i = 0; i < allTiers.length; i++) {
      if (points >= allTiers[i].minPoints) {
        current = allTiers[i];
        if (i > 0) {
          next = allTiers[i - 1];
        } else {
          next = const RankTier(
            type: TierType.max,
            minPoints: 99999,
            color: Colors.black,
          );
        }
        break;
      }
    }
    return (current: current, next: next);
  }
}
