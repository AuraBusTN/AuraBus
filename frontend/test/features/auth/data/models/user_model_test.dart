import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/auth/data/models/user_model.dart';

void main() {
  group('User Model', () {
    test('fromJson creates a User with all fields', () {
      final json = {
        'id': '123',
        'firstName': 'Mario',
        'lastName': 'Rossi',
        'email': 'mario@example.com',
        'picture': 'https://example.com/pic.png',
        'points': 1500,
        'rank': 3,
      };

      final user = User.fromJson(json);

      expect(user.id, '123');
      expect(user.firstName, 'Mario');
      expect(user.lastName, 'Rossi');
      expect(user.email, 'mario@example.com');
      expect(user.picture, 'https://example.com/pic.png');
      expect(user.points, 1500);
      expect(user.rank, 3);
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'id': '456',
        'firstName': 'Luigi',
        'lastName': 'Verdi',
        'email': 'luigi@example.com',
      };

      final user = User.fromJson(json);

      expect(user.id, '456');
      expect(user.picture, isNull);
      expect(user.points, 0);
      expect(user.rank, isNull);
    });

    test('fromJson handles null email gracefully', () {
      final json = {'id': '789', 'firstName': 'Anna', 'lastName': 'Bianchi'};

      final user = User.fromJson(json);
      expect(user.email, '');
    });

    test('fromJson throws FormatException when id is null', () {
      final json = {
        'id': null,
        'firstName': 'Test',
        'lastName': 'User',
        'email': 'test@test.com',
      };

      expect(() => User.fromJson(json), throwsA(isA<FormatException>()));
    });

    test('fromJson throws FormatException when id is empty string', () {
      final json = {
        'id': '',
        'firstName': 'Test',
        'lastName': 'User',
        'email': 'test@test.com',
      };

      expect(() => User.fromJson(json), throwsA(isA<FormatException>()));
    });

    test('fromJson handles non-int points as 0', () {
      final json = {
        'id': '1',
        'firstName': 'Test',
        'lastName': 'User',
        'email': 'test@test.com',
        'points': 'not_a_number',
      };

      final user = User.fromJson(json);
      expect(user.points, 0);
    });

    test('fullName returns concatenated first and last name', () {
      final user = User(
        id: '1',
        firstName: 'Mario',
        lastName: 'Rossi',
        email: 'mario@test.com',
      );
      expect(user.fullName, 'Mario Rossi');
    });

    test('fullName trims when lastName is empty', () {
      final user = User(
        id: '1',
        firstName: 'Mario',
        lastName: '',
        email: 'mario@test.com',
      );
      expect(user.fullName, 'Mario');
    });

    test('fullName trims when firstName is empty', () {
      final user = User(
        id: '1',
        firstName: '',
        lastName: 'Rossi',
        email: 'mario@test.com',
      );
      expect(user.fullName, 'Rossi');
    });

    test('fromJson handles missing firstName and lastName', () {
      final json = {'id': '1', 'email': 'test@test.com'};

      final user = User.fromJson(json);
      expect(user.firstName, '');
      expect(user.lastName, '');
      expect(user.fullName, '');
    });

    test('default points value is 0', () {
      final user = User(
        id: '1',
        firstName: 'Test',
        lastName: 'User',
        email: 'test@test.com',
      );
      expect(user.points, 0);
    });
  });
}
