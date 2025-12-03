import 'package:dio/dio.dart';

import '../../core/error/app_exception.dart';
import '../../core/network/dio_factory.dart';
import '../models/auth_session.dart';
import '../models/auth_tokens.dart';
import '../models/user.dart';

class AuthRepository {
  AuthRepository({Dio? dio}) : _dio = dio ?? createBaseDio();

  final Dio _dio;

  Future<AuthSession> login({
    required String correo,
    required String password,
  }) async {
    return _handleAuthRequest(
      () => _dio.post<dynamic>(
        '/auth/login',
        data: <String, dynamic>{'correo': correo, 'password': password},
      ),
    );
  }

  Future<AuthSession> register({
    required String nombre,
    required String apellido,
    required String correo,
    required String password,
    String? fechaNacimiento,
  }) async {
    return _handleAuthRequest(
      () => _dio.post<dynamic>(
        '/auth/register',
        data: <String, dynamic>{
          'nombre': nombre,
          'apellido': apellido,
          'correo': correo,
          'password': password,
          if (fechaNacimiento != null && fechaNacimiento.isNotEmpty)
            'fechaNacimiento': fechaNacimiento,
        },
      ),
    );
  }

  Future<AuthSession> googleSignIn({required String idToken}) async {
    return _handleAuthRequest(
      () => _dio.post<dynamic>(
        '/auth/google',
        data: <String, dynamic>{'idToken': idToken},
      ),
    );
  }

  Future<AuthSession> refreshSession(String refreshToken) async {
    return _handleAuthRequest(
      () => _dio.post<dynamic>(
        '/auth/refresh',
        data: <String, dynamic>{'refreshToken': refreshToken},
      ),
    );
  }

  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post<dynamic>(
        '/auth/logout',
        data: <String, dynamic>{'refreshToken': refreshToken},
      );
    } catch (error) {
      throw _mapError(error);
    }
  }

  Future<void> requestPasswordReset(String correo) async {
    try {
      await _dio.post<dynamic>(
        '/auth/forgot-password',
        data: <String, dynamic>{'correo': correo},
      );
    } catch (error) {
      throw _mapError(error);
    }
  }

  Future<String> verifyResetCode({
    required String correo,
    required String code,
  }) async {
    try {
      final Response<dynamic> response = await _dio.post<dynamic>(
        '/auth/verify-reset-code',
        data: <String, dynamic>{'correo': correo, 'code': code},
      );
      final Map<String, dynamic> data = _asMap(response.data);
      final String? token = data['resetToken'] as String?;
      if (token == null) {
        throw AppException('No se recibió el token de restablecimiento');
      }
      return token;
    } catch (error) {
      throw _mapError(error);
    }
  }

  Future<void> resetPassword({
    required String correo,
    required String resetToken,
    required String password,
  }) async {
    try {
      await _dio.post<dynamic>(
        '/auth/reset-password',
        data: <String, dynamic>{
          'correo': correo,
          'resetToken': resetToken,
          'password': password,
        },
      );
    } catch (error) {
      throw _mapError(error);
    }
  }

  Future<AuthSession> _handleAuthRequest(
    Future<Response<dynamic>> Function() requestFn,
  ) async {
    try {
      final Response<dynamic> response = await requestFn();
      final Map<String, dynamic> data = _asMap(response.data);
      final Map<String, dynamic> userMap = _asMap(data['user']);
      final Map<String, dynamic> tokenMap = _asMap(data['tokens']);
      final AppUser user = AppUser.fromJson(userMap);
      final AuthTokens tokens = AuthTokens.fromJson(tokenMap);
      return AuthSession(user: user, tokens: tokens);
    } catch (error) {
      throw _mapError(error);
    }
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    throw AppException('Respuesta inesperada del servidor');
  }

  AppException _mapError(Object error) {
    if (error is AppException) {
      return error;
    }
    if (error is DioException) {
      final Response<dynamic>? response = error.response;
      final int? statusCode = response?.statusCode;
      final String message =
          _extractMessage(response?.data) ??
          error.message ??
          'Error de autenticación';
      if (statusCode == 401) {
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
