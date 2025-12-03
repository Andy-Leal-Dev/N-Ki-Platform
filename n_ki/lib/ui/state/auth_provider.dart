import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/error/app_exception.dart';
import '../../core/storage/session_storage.dart';
import '../../data/models/auth_session.dart';
import '../../data/models/auth_tokens.dart';
import '../../data/models/user.dart';
import '../../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    required AuthRepository authRepository,
    required SessionStorage sessionStorage,
  }) : _authRepository = authRepository,
       _sessionStorage = sessionStorage;

  final AuthRepository _authRepository;
  final SessionStorage _sessionStorage;

  AppUser? _currentUser;
  AuthTokens? _tokens;
  bool _initialized = false;
  bool _isLoading = false;
  String? _error;

  AppUser? get user => _currentUser;
  AuthTokens? get tokens => _tokens;
  bool get isAuthenticated => _currentUser != null;
  bool get initialized => _initialized;
  bool get isLoading => _isLoading;
  String? get errorMessage => _error;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    _initialized = true;
    try {
      final AuthSession? session = await _sessionStorage.loadSession();
      if (session != null) {
        _applySession(session, persist: false);
      }
    } catch (_) {
      await _sessionStorage.clear();
      _currentUser = null;
      _tokens = null;
    }
    notifyListeners();
  }

  Future<bool> login({required String correo, required String password}) async {
    return _executeAuthCall(
      () => _authRepository.login(correo: correo, password: password),
    );
  }

  Future<bool> register({
    required String nombre,
    required String apellido,
    required String correo,
    required String password,
    String? fechaNacimiento,
  }) async {
    return _executeAuthCall(
      () => _authRepository.register(
        nombre: nombre,
        apellido: apellido,
        correo: correo,
        password: password,
        fechaNacimiento: fechaNacimiento,
      ),
    );
  }

  Future<void> logout() async {
    final AuthTokens? currentTokens = _tokens;
    _setLoading(true);
    _error = null;
    try {
      if (currentTokens != null) {
        await _authRepository.logout(currentTokens.refreshToken);
      }
    } catch (_) {
      // Ignoramos fallos del lado del servidor al cerrar sesión.
    } finally {
      await _sessionStorage.clear();
      _currentUser = null;
      _tokens = null;
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> requestPasswordReset(String correo) async {
    await _authRepository.requestPasswordReset(correo);
  }

  Future<String> verifyResetCode({
    required String correo,
    required String code,
  }) {
    return _authRepository.verifyResetCode(correo: correo, code: code);
  }

  Future<void> resetPassword({
    required String correo,
    required String resetToken,
    required String password,
  }) async {
    await _authRepository.resetPassword(
      correo: correo,
      resetToken: resetToken,
      password: password,
    );
  }

  void handleUnauthorized() {
    _currentUser = null;
    _tokens = null;
    _error = 'Sesión expirada, vuelve a iniciar sesión.';
    unawaited(_sessionStorage.clear());
    notifyListeners();
  }

  Future<bool> _executeAuthCall(Future<AuthSession> Function() request) async {
    _setLoading(true);
    _error = null;
    try {
      final AuthSession session = await request();
      await _sessionStorage.saveSession(session);
      _applySession(session, persist: false);
      _setLoading(false);
      notifyListeners();
      return true;
    } on AppException catch (error) {
      _error = error.message;
      _setLoading(false);
      notifyListeners();
      return false;
    } catch (error) {
      _error = error.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  void _applySession(AuthSession session, {bool persist = true}) {
    _currentUser = session.user;
    _tokens = session.tokens;
    if (persist) {
      _sessionStorage.saveSession(session);
    }
  }

  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
    }
  }
}
