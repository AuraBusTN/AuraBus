import 'package:dio/dio.dart';
import 'package:aurabus/core/network/dio_client.dart';
import 'package:aurabus/core/services/token_storage_service.dart';
import 'package:aurabus/core/errors/auth_exception.dart';
import 'models/user_model.dart';
import 'package:aurabus/features/ranking/data/models/leaderboard_data.dart';

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
      final message = e.response?.data['message'] ?? 'Error during login';
      throw AuthException(message, statusCode: e.response?.statusCode);
    } catch (e) {
      throw AuthException('Unexpected error during login: $e');
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
      final message = e.response?.data['message'] ?? 'Error during signup';
      throw AuthException(message, statusCode: e.response?.statusCode);
    } catch (e) {
      throw AuthException('Unexpected error during signup: $e');
    }
  }

  Future<User> googleLogin(String idToken) async {
    try {
      final response = await _dioClient.dio.post(
        '/auth/google',
        data: {'idToken': idToken},
      );

      await _tokenStorage.saveTokens(
        accessToken: response.data['accessToken'],
        refreshToken: response.data['refreshToken'],
      );

      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Error during Google login';
      throw AuthException(message, statusCode: e.response?.statusCode);
    } catch (e) {
      throw AuthException('Unexpected error during Google login: $e');
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
      } catch (_) {}
    }
    await _tokenStorage.clearTokens();
  }

  Future<User?> getUserProfile() async {
    try {
      final response = await _dioClient.dio.get('/auth/me');
      return User.fromJson(response.data['user']);
    } catch (_) {
      return null;
    }
  }

  Future<LeaderboardData> getLeaderboard() async {
    try {
      final response = await _dioClient.dio.get('/users/leaderboard');
      final data = response.data;

      final topList = (data['topUsers'] as List)
          .map((e) => User.fromJson(e))
          .toList();

      User? meUser;
      if (data['me'] != null) {
        meUser = User.fromJson(data['me']);
      }

      return LeaderboardData(topUsers: topList, me: meUser);
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Error loading leaderboard';
      throw AuthException(message, statusCode: e.response?.statusCode);
    } catch (e) {
      throw AuthException('Unexpected error loading leaderboard: $e');
    }
  }

  Future<List<int>> getFavoriteRoutes() async {
    try {
      final response = await _dioClient.dio.get('/users/favorite-routes');
      final data = response.data;

      if (data['favoriteRoutes'] != null) {
        return (data['favoriteRoutes'] as List).map((e) => e as int).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<void> updateFavoriteRoutes(List<int> routeIds) async {
    try {
      await _dioClient.dio.post(
        '/users/favorite-routes',
        data: {'favoriteRoutes': routeIds},
      );
    } catch (e) {
      throw Exception("Failed to update favorite routes: $e");
    }
  }
}
