import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:aurabus/theme.dart';
import 'package:aurabus/features/auth/data/models/user_model.dart';
import 'package:aurabus/features/auth/presentation/providers/auth_provider.dart';
import 'package:aurabus/features/ranking/domain/rank_tier.dart';
import 'package:aurabus/features/ranking/presentation/providers/leaderboard_provider.dart';
import 'package:aurabus/l10n/app_localizations.dart';

import 'widgets/user_fifa_card.dart';
import 'widgets/tiers_list.dart';
import 'widgets/leaderboard_list.dart';

class RankingPage extends ConsumerWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final authState = ref.watch(authProvider);
    final currentUser = authState.user;
    final myPoints = currentUser?.points ?? 0;
    final myId = currentUser?.id;

    final tierInfo = RankTier.getTierInfo(myPoints);

    final leaderboardAsync = ref.watch(leaderboardProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.rankingTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserFifaCard(
                  current: tierInfo.current,
                  next: tierInfo.next,
                  points: myPoints,
                ),
                const SizedBox(height: 24),

                Text(
                  l10n.tiersAndRewards,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),

                TiersList(userPoints: myPoints),

                const SizedBox(height: 24),

                Text(
                  l10n.globalLeaderboard,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),

                leaderboardAsync.when(
                  data: (data) {
                    if (data.topUsers.isEmpty) {
                      return Text(l10n.noUsersInLeaderboard);
                    }
                    return LeaderboardList(
                      users: data.topUsers,
                      meOutsideTop10: data.me,
                      myId: myId,
                    );
                  },
                  error: (err, stack) => Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('${l10n.errorLoadingLeaderboard}: $err'),
                  ),
                  loading: () => Skeletonizer(
                    enabled: true,
                    child: LeaderboardList(
                      users: List.generate(
                        6,
                        (index) => User(
                          id: 'fake',
                          firstName: 'Loading User Name',
                          lastName: '',
                          email: '',
                          points: 1000,
                        ),
                      ),
                      meOutsideTop10: null,
                      myId: null,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
