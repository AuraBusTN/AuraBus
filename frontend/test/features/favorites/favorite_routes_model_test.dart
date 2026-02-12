import 'package:aurabus/features/favorites/data/models/favorite_routes_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FavoriteRoutes', () {
    test('fromJson: parses valid route IDs correctly', () {
      final json = {
        'favoriteRoutes': [1, 5, 10, 99],
      };

      final result = FavoriteRoutes.fromJson(json);

      expect(result.routes, [1, 5, 10, 99]);
    });

    test('fromJson: filters out non-numeric route IDs', () {
      final json = {
        'favoriteRoutes': [1, 'invalid', 5, 'abc', 10],
      };

      final result = FavoriteRoutes.fromJson(json);

      expect(result.routes, [1, 5, 10]);
    });

    test('fromJson: handles numeric strings and filters invalid ones', () {
      final json = {
        'favoriteRoutes': ['1', '5', 'abc', '10', 'xyz'],
      };

      final result = FavoriteRoutes.fromJson(json);

      expect(result.routes, [1, 5, 10]);
    });

    test('fromJson: handles empty favorites list', () {
      final json = {
        'favoriteRoutes': [],
      };

      final result = FavoriteRoutes.fromJson(json);

      expect(result.routes, isEmpty);
    });

    test('fromJson: handles null favorites list', () {
      final json = {
        'favoriteRoutes': null,
      };

      final result = FavoriteRoutes.fromJson(json);

      expect(result.routes, isEmpty);
    });

    test('fromJson: handles missing favoriteRoutes key', () {
      final json = <String, dynamic>{};

      final result = FavoriteRoutes.fromJson(json);

      expect(result.routes, isEmpty);
    });

    test('fromJson: filters out null values in list', () {
      final json = {
        'favoriteRoutes': [1, null, 5, null, 10],
      };

      final result = FavoriteRoutes.fromJson(json);

      expect(result.routes, [1, 5, 10]);
    });

    test('fromJson: does not map invalid entries to zero', () {
      final json = {
        'favoriteRoutes': [1, 'invalid', 5],
      };

      final result = FavoriteRoutes.fromJson(json);

      expect(result.routes, [1, 5]);
      expect(result.routes.contains(0), isFalse);
    });

    test('fromJson: rejects zero as invalid route ID', () {
      final json = {
        'favoriteRoutes': [0, 1, 5],
      };

      final result = FavoriteRoutes.fromJson(json);

      expect(result.routes, [1, 5]);
    });

    test('fromJson: rejects negative route IDs', () {
      final json = {
        'favoriteRoutes': [-1, 5, -10, 10],
      };

      final result = FavoriteRoutes.fromJson(json);

      expect(result.routes, [5, 10]);
    });

    test('fromJson: handles large route ID values', () {
      final json = {
        'favoriteRoutes': [999999, 1000000, 9999999],
      };

      final result = FavoriteRoutes.fromJson(json);

      expect(result.routes, [999999, 1000000, 9999999]);
    });

    test('fromJson: preserves duplicates', () {
      final json = {
        'favoriteRoutes': [1, 5, 5, 10, 5],
      };

      final result = FavoriteRoutes.fromJson(json);

      expect(result.routes, [1, 5, 5, 10, 5]);
    });

    test('fromJson: preserves order of valid entries', () {
      final json = {
        'favoriteRoutes': [10, 'invalid', 5, 'abc', 1, 'xyz', 20],
      };

      final result = FavoriteRoutes.fromJson(json);

      expect(result.routes, [10, 5, 1, 20]);
    });
  });
}
