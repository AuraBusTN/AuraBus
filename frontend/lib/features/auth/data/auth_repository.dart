import 'package:dio/dio.dart';
import 'package:aurabus/core/network/dio_client.dart';
import 'package:aurabus/core/services/token_storage_service.dart';
import 'models/user_model.dart';

class AuthRepository {
  final DioClient _dioClient;
  final TokenStorageService _tokenStorage;

  AuthRepository(this._dioClient, this._tokenStorage);

  Future<User> login(String email, String password) async {
    try {
      final response = await _dioClient.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      await _tokenStorage.saveTokens(
        accessToken: response.data['accessToken'],
        refreshToken: response.data['refreshToken'],
      );

      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Error during login';
    }
  }

  Future<User> signup(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    try {
      final response = await _dioClient.dio.post(
        '/auth/signup',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
        },
      );

      await _tokenStorage.saveTokens(
        accessToken: response.data['accessToken'],
        refreshToken: response.data['refreshToken'],
      );

      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data['message'] != null) {
        throw e.response!.data['message'];
      }
      throw 'Error during signup';
    }
  }
  Future<void> logout() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken != null) {
      try {
        await _dioClient.dio.post(
          '/auth/logout',
          data: {'refreshToken': refreshToken},
        );
      } catch (_) {
      }
    }
    await _tokenStorage.clearTokens();
  }

  Future<User?> getUserProfile() async {
    try {
      final response = await _dioClient.dio.get('/auth/me');
      return User.fromJson(response.data);
    } catch (_) {
      return null;
    }
  }
}
