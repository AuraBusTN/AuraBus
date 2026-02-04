import 'package:flutter/material.dart';
import 'package:aurabus/theme.dart';
import 'package:aurabus/features/auth/data/models/user_model.dart';
import 'package:aurabus/l10n/app_localizations.dart';

class LeaderboardList extends StatelessWidget {
  final List<User> users;
  final User? meOutsideTop10;
  final String? myId;

  const LeaderboardList({
    super.key,
    required this.users,
    this.meOutsideTop10,
    this.myId,
  });

  Color _getRankColor(int pos) {
    if (pos == 1) return const Color(0xFFFFD700);
    if (pos == 2) return const Color(0xFFC0C0C0);
    if (pos == 3) return const Color(0xFFCD7F32);
    return AppColors.scaffoldBackground;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ...users.asMap().entries.map((entry) {
            final user = entry.value;
            final rank = user.rank ?? (entry.key + 1);
            final isMe = (myId != null && user.id == myId);

            return _buildRow(
              context,
              user,
              rank,
              isMe,
              l10n,
              isLast: entry.key == users.length - 1 && meOutsideTop10 == null,
            );
          }),

          if (meOutsideTop10 != null) ...[
            const Divider(height: 1, thickness: 1, color: AppColors.border),
            Container(
              height: 16,
              color: const Color(0xFFF5F5F5),
              child: const Center(
                child: Icon(Icons.more_vert, size: 14, color: Colors.grey),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.border),
            _buildRow(
              context,
              meOutsideTop10!,
              meOutsideTop10!.rank ?? 999,
              true,
              l10n,
              isLast: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    User user,
    int rank,
    bool isMe,
    AppLocalizations l10n, {
    bool isLast = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isMe
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.vertical(
          bottom: isLast ? const Radius.circular(14) : Radius.zero,
          top: rank == 1 ? const Radius.circular(14) : Radius.zero,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 35,
          height: 35,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _getRankColor(rank),
            shape: BoxShape.circle,
            border: rank > 3 ? Border.all(color: Colors.grey.shade300) : null,
          ),
          child: Text(
            '$rank',
            style: TextStyle(
              color: rank <= 3 ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        title: Text(
          isMe ? "${user.firstName} (${l10n.youLabel})" : user.firstName,
          style: TextStyle(
            fontWeight: isMe ? FontWeight.bold : FontWeight.w500,
            color: isMe ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${user.points} ${l10n.pointsAbbr}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
