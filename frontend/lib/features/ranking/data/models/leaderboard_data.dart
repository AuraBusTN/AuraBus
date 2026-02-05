import 'package:aurabus/features/auth/data/models/user_model.dart';

class LeaderboardData {
  final List<User> topUsers;
  final User? me;

  LeaderboardData({required this.topUsers, this.me});
}
