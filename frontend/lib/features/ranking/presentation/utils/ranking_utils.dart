import 'package:flutter/material.dart';
import 'package:aurabus/features/ranking/domain/rank_tier.dart';
import 'package:aurabus/l10n/app_localizations.dart';

class RankingUtils {
  static String getTierName(BuildContext context, TierType type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case TierType.elite:
        return l10n.tierElite;
      case TierType.gold:
        return l10n.tierGold;
      case TierType.silver:
        return l10n.tierSilver;
      case TierType.bronze:
        return l10n.tierBronze;
      case TierType.max:
        return "Max";
    }
  }

  static String getTierReward(BuildContext context, TierType type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case TierType.elite:
        return l10n.rewardAnnual;
      case TierType.gold:
        return l10n.rewardMonthly;
      case TierType.silver:
        return l10n.reward10Rides;
      case TierType.bronze:
        return l10n.reward2Rides;
      case TierType.max:
        return "";
    }
  }
}
