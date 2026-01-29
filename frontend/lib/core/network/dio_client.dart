import 'package:dio/dio.dart';
import 'package:aurabus/core/services/token_storage_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';

class DioClient {
  final Dio _dio;
  final TokenStorageService _tokenStorage;
  bool _isRefreshing = false;
  Completer<String?>? _refreshTokenCompleter;

  DioClient(this._tokenStorage)
    : _dio = Dio(
        BaseOptions(
          baseUrl: _getBaseUrl(),
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
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
              _refreshTokenCompleter = Completer<String?>();

              try {
                final newAccessToken = await _refreshToken();

                _refreshTokenCompleter?.complete(newAccessToken);

                if (newAccessToken != null) {
                  error.requestOptions.headers['Authorization'] =
                      'Bearer $newAccessToken';
                  final clonedRequest = await _dio.fetch(error.requestOptions);
                  return handler.resolve(clonedRequest);
                } else {
                  await _tokenStorage.clearTokens();
                  return handler.next(error);
                }
              } catch (e) {
                _refreshTokenCompleter?.complete(null);
                await _tokenStorage.clearTokens();
                return handler.next(error);
              } finally {
                _isRefreshing = false;
              }
            } else {
              final newToken = await _refreshTokenCompleter?.future;

              if (newToken != null) {
                error.requestOptions.headers['Authorization'] =
                    'Bearer $newToken';
                try {
                  final clonedRequest = await _dio.fetch(error.requestOptions);
                  return handler.resolve(clonedRequest);
                } catch (e) {
                  return handler.next(error);
                }
              }
              return handler.next(error);
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
