import 'dart:convert';

import '../../data/models/auth_tokens.dart';
import '../../data/models/user.dart';
import '../../data/models/auth_session.dart';
import 'secure_storage.dart';

class SessionStorage {
  SessionStorage(this._storage);

  final AppSecureStorage _storage;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'session_user';

  Future<void> saveSession(AuthSession session) async {
    await _storage.write(
      key: _accessTokenKey,
      value: session.tokens.accessToken,
    );
    await _storage.write(
      key: _refreshTokenKey,
      value: session.tokens.refreshToken,
    );
    await _storage.write(
      key: _userKey,
      value: jsonEncode(session.user.toJson()),
    );
  }

  Future<AuthSession?> loadSession() async {
    final String? accessToken = await _storage.read(_accessTokenKey);
    final String? refreshToken = await _storage.read(_refreshTokenKey);
    final String? userJson = await _storage.read(_userKey);

    if (accessToken == null || refreshToken == null || userJson == null) {
      return null;
    }

    final Map<String, dynamic> userMap =
        jsonDecode(userJson) as Map<String, dynamic>;
    final AppUser user = AppUser.fromJson(userMap);
    final AuthTokens tokens = AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    return AuthSession(user: user, tokens: tokens);
  }

  Future<AuthTokens?> loadTokens() async {
    final String? accessToken = await _storage.read(_accessTokenKey);
    final String? refreshToken = await _storage.read(_refreshTokenKey);
    if (accessToken == null || refreshToken == null) {
      return null;
    }
    return AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
  }

  Future<void> clear() async {
    await _storage.delete(_accessTokenKey);
    await _storage.delete(_refreshTokenKey);
    await _storage.delete(_userKey);
  }

  Future<void> updateTokens(AuthTokens tokens) async {
    await _storage.write(key: _accessTokenKey, value: tokens.accessToken);
    await _storage.write(key: _refreshTokenKey, value: tokens.refreshToken);
  }

  Future<void> updateUser(AppUser user) async {
    await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
  }
}
