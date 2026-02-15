import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/auth/data/models/user_model.dart';
import 'package:aurabus/features/ranking/data/models/leaderboard_data.dart';

void main() {
  group('LeaderboardData', () {
    test('creates with topUsers and me', () {
      final users = [
        User(
          id: '1',
          firstName: 'Mario',
          lastName: 'Rossi',
          email: 'a@a.com',
          points: 2000,
        ),
        User(
          id: '2',
          firstName: 'Luigi',
          lastName: 'Verdi',
          email: 'b@b.com',
          points: 1500,
        ),
      ];
      final me = User(
        id: '3',
        firstName: 'Anna',
        lastName: 'Bianchi',
        email: 'c@c.com',
        points: 500,
        rank: 15,
      );

      final data = LeaderboardData(topUsers: users, me: me);

      expect(data.topUsers.length, 2);
      expect(data.topUsers[0].firstName, 'Mario');
      expect(data.topUsers[1].firstName, 'Luigi');
      expect(data.me, isNotNull);
      expect(data.me!.firstName, 'Anna');
      expect(data.me!.rank, 15);
    });

    test('creates with topUsers and null me', () {
      final data = LeaderboardData(topUsers: []);

      expect(data.topUsers, isEmpty);
      expect(data.me, isNull);
    });

    test('topUsers can be empty list', () {
      final data = LeaderboardData(topUsers: []);
      expect(data.topUsers, isEmpty);
    });
  });
}
