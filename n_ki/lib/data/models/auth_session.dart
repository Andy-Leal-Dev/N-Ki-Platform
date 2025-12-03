import 'auth_tokens.dart';
import 'user.dart';

class AuthSession {
  const AuthSession({required this.user, required this.tokens});

  final AppUser user;
  final AuthTokens tokens;
}
