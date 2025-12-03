import 'dart:async';

import 'package:dio/dio.dart';

import '../../data/models/auth_tokens.dart';
import '../../data/models/auth_session.dart';
import '../../data/repositories/auth_repository.dart';
import '../config/app_config.dart';
import 'base_api_client.dart';
import '../error/app_exception.dart';
import '../storage/session_storage.dart';

class ApiClient implements BaseApiClient {
  ApiClient({
    required SessionStorage sessionStorage,
    required AuthRepository authRepository,
    void Function()? onUnauthorized,
  }) : _sessionStorage = sessionStorage,
       _authRepository = authRepository,
       _onUnauthorized = onUnauthorized {
    final BaseOptions options = BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      responseType: ResponseType.json,
      headers: <String, dynamic>{'Content-Type': 'application/json'},
    );

    _dio = Dio(options);
    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
              final AuthTokens? tokens = await _sessionStorage.loadTokens();
              if (tokens != null) {
                options.headers['Authorization'] =
                    'Bearer ${tokens.accessToken}';
              }
              handler.next(options);
            },
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          if (_shouldAttemptRefresh(error)) {
            try {
              final AuthTokens? refreshed = await _refreshTokens();
              if (refreshed != null) {
                final RequestOptions requestOptions = error.requestOptions;
                requestOptions.headers['Authorization'] =
                    'Bearer ${refreshed.accessToken}';
                final Response<dynamic> response = await _dio.fetch<dynamic>(
                  requestOptions,
                );
                handler.resolve(response);
                return;
              }
            } catch (_) {
              _onUnauthorized?.call();
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  late final Dio _dio;
  final SessionStorage _sessionStorage;
  final AuthRepository _authRepository;
  final void Function()? _onUnauthorized;
  Completer<AuthTokens?>? _refreshCompleter;

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<dynamic> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (error) {
      throw _mapError(error);
    }
  }

  bool _shouldAttemptRefresh(DioException error) {
    if (error.type != DioExceptionType.badResponse) {
      return false;
    }
    final int? status = error.response?.statusCode;
    if (status != 401) {
      return false;
    }

    final String path = error.requestOptions.path;
    if (path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/refresh') ||
        path.contains('/auth/logout') ||
        path.contains('/auth/forgot-password') ||
        path.contains('/auth/verify-reset-code') ||
        path.contains('/auth/reset-password')) {
      return false;
    }

    return true;
  }

  Future<AuthTokens?> _refreshTokens() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }
    final Completer<AuthTokens?> completer = Completer<AuthTokens?>();
    _refreshCompleter = completer;

    try {
      final AuthTokens? storedTokens = await _sessionStorage.loadTokens();
      if (storedTokens == null) {
        completer.complete(null);
      } else {
        final AuthSession session = await _authRepository.refreshSession(
          storedTokens.refreshToken,
        );
        await _sessionStorage.saveSession(session);
        completer.complete(session.tokens);
      }
    } catch (_) {
      await _sessionStorage.clear();
      completer.complete(null);
      _onUnauthorized?.call();
    } finally {
      _refreshCompleter = null;
    }

    return completer.future;
  }

  AppException _mapError(Object error) {
    if (error is AppException) {
      return error;
    }
    if (error is DioException) {
      final Response<dynamic>? response = error.response;
      final String message =
          _extractMessage(response?.data) ??
          error.message ??
          'Error de red inesperado';
      final int? statusCode = response?.statusCode;

      if (statusCode == 401) {
        _onUnauthorized?.call();
        return UnauthorizedException(message);
      }

      if (statusCode != null && statusCode >= 400 && statusCode < 500) {
        return ValidationException(message, statusCode: statusCode);
      }

      return NetworkException(message, statusCode: statusCode);
    }
    return AppException(error.toString());
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['error'] is Map<String, dynamic>) {
        final Map<String, dynamic> errorMap =
            data['error'] as Map<String, dynamic>;
        return (errorMap['message'] ?? errorMap['detail'])?.toString();
      }
      if (data['message'] != null) {
        return data['message'].toString();
      }
    }
    return null;
  }
}
