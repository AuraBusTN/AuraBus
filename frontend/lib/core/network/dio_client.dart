import 'package:dio/dio.dart';
import 'package:aurabus/core/services/token_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  final Dio _dio;
  final TokenStorageService _tokenStorage;
  bool _isRefreshing = false;

  DioClient(this._tokenStorage)
    : _dio = Dio(
        BaseOptions(
          baseUrl: _getBaseUrl(),
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 3),
        ),
      ) {
    _setupInterceptors();
  }

  static String _getBaseUrl() {
    String url = dotenv.env['API_URL'] ?? 'http://localhost:3000';

    return url;
  }

  Dio get dio => _dio;

  void _setupInterceptors() {
    debugPrint('DioClient: Setting up interceptors');
    debugPrint('Base URL: ${_dio.options.baseUrl}');
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },

        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            if (!_isRefreshing) {
              _isRefreshing = true;
              try {
                final newAccessToken = await _refreshToken();
                if (newAccessToken != null) {
                  _isRefreshing = false;
                  error.requestOptions.headers['Authorization'] =
                      'Bearer $newAccessToken';
                  final clonedRequest = await _dio.fetch(error.requestOptions);
                  return handler.resolve(clonedRequest);
                }
              } catch (e) {
                _isRefreshing = false;
                await _tokenStorage.clearTokens();
                return handler.next(error);
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<String?> _refreshToken() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null) return null;

    try {
      final response = await Dio(
        BaseOptions(baseUrl: _dio.options.baseUrl),
      ).post('/auth/refresh-token', data: {'refreshToken': refreshToken});

      if (response.statusCode == 200) {
        final newAccess = response.data['accessToken'];
        final newRefresh = response.data['refreshToken'];

        await _tokenStorage.saveTokens(
          accessToken: newAccess,
          refreshToken: newRefresh,
        );
        return newAccess;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
