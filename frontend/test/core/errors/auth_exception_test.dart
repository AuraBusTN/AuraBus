import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/core/errors/auth_exception.dart';

void main() {
  group('AuthException', () {
    test('stores message', () {
      final exception = AuthException('Login failed');
      expect(exception.message, 'Login failed');
    });

    test('stores statusCode when provided', () {
      final exception = AuthException('Unauthorized', statusCode: 401);
      expect(exception.statusCode, 401);
    });

    test('statusCode is null by default', () {
      final exception = AuthException('Error');
      expect(exception.statusCode, isNull);
    });

    test('toString returns the message', () {
      final exception = AuthException('Something went wrong');
      expect(exception.toString(), 'Something went wrong');
    });

    test('implements Exception', () {
      final exception = AuthException('Test');
      expect(exception, isA<Exception>());
    });
  });
}
