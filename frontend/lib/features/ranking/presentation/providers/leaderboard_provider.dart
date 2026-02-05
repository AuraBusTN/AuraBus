import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aurabus/features/auth/presentation/providers/auth_provider.dart';
import 'package:aurabus/features/ranking/data/models/leaderboard_data.dart';

final leaderboardProvider = FutureProvider.autoDispose<LeaderboardData>((
  ref,
) async {
  final repo = ref.watch(authRepositoryProvider);
  return await repo.getLeaderboard();
});
