import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/auth/presentation/providers/auth_provider.dart';
import 'package:aurabus/features/auth/data/models/user_model.dart';

void main() {
  group('AuthState', () {
    test('default state has correct initial values', () {
      const state = AuthState();

      expect(state.isLoading, false);
      expect(state.isAuthenticated, false);
      expect(state.error, isNull);
      expect(state.user, isNull);
    });

    test('copyWith updates isLoading', () {
      const state = AuthState();
      final updated = state.copyWith(isLoading: true);

      expect(updated.isLoading, true);
      expect(updated.isAuthenticated, false);
      expect(updated.error, isNull);
    });

    test('copyWith updates isAuthenticated', () {
      const state = AuthState();
      final updated = state.copyWith(isAuthenticated: true);

      expect(updated.isAuthenticated, true);
      expect(updated.isLoading, false);
    });

    test('copyWith updates error', () {
      const state = AuthState();
      final updated = state.copyWith(error: 'Login failed');

      expect(updated.error, 'Login failed');
    });

    test('copyWith clears error when not provided', () {
      final state = const AuthState().copyWith(error: 'Some error');
      final updated = state.copyWith(isLoading: true);

      expect(updated.error, isNull);
    });

    test('copyWith updates user', () {
      const state = AuthState();
      final user = User(
        id: '1',
        firstName: 'Mario',
        lastName: 'Rossi',
        email: 'mario@test.com',
        points: 100,
      );
      final updated = state.copyWith(user: user);

      expect(updated.user, isNotNull);
      expect(updated.user!.firstName, 'Mario');
      expect(updated.user!.points, 100);
    });

    test('copyWith preserves user when not provided', () {
      final user = User(
        id: '1',
        firstName: 'Mario',
        lastName: 'Rossi',
        email: 'mario@test.com',
      );
      final state = AuthState(user: user, isAuthenticated: true);
      final updated = state.copyWith(isLoading: true);

      expect(updated.user, isNotNull);
      expect(updated.user!.firstName, 'Mario');
    });

    test('copyWith can update all fields at once', () {
      final user = User(
        id: '1',
        firstName: 'Test',
        lastName: 'User',
        email: 'test@test.com',
        points: 500,
      );
      final updated = const AuthState().copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        error: null,
      );

      expect(updated.isLoading, false);
      expect(updated.isAuthenticated, true);
      expect(updated.user!.id, '1');
      expect(updated.error, isNull);
    });
  });
}
