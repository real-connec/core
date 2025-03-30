import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  ApiService({
    required Dio dio,
    required FlutterSecureStorage storage,
  })  : _dio = dio,
        _storage = storage {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = await _storage.read(key: 'jwt_token');

        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        if (kDebugMode) {
          print('REQUEST[${options.method}] => PATH: ${options.path}');
        }

        handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          print('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
        }

        handler.next(response);
      },
      onError: (DioException e, handler) async {
        if (kDebugMode) {
          print('ERROR[${e.response?.statusCode}] => MESSAGE: ${e.message}');
        }

        if (e.response?.statusCode == 401) {
          await _refreshToken();
          // Optionally retry the request after refreshing token
        }

        handler.next(e);
      },
    ));
  }

  static const String baseUrl = 'http://localhost:8000/'; // Emulator localhost

  Future<Response> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: params);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String endpoint, dynamic data) async {
    try {
      final response = await _dio.post(
        baseUrl + endpoint,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveToken(String token, String key) async {
    await _storage.write(key: key, value: token);
  }

  Future<void> deleteToken(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> _refreshToken() async {
    final refreshToken = await _storage.read(key: 'refresh_token');

    if (refreshToken == null) return;

    try {
      final response = await _dio.post(
        'api-auth/token/refresh',
        data: {'refresh': refreshToken},
      );

      final newToken = response.data['access'];
      await saveToken(newToken, 'jwt_token');
    } catch (e) {
      // Handle token refresh error
      if (kDebugMode) {
        print('Failed to refresh token: $e');
      }
    }
  }
}
