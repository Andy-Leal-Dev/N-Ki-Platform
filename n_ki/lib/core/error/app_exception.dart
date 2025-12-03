class AppException implements Exception {
  AppException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'AppException($statusCode): $message';
}

class NetworkException extends AppException {
  NetworkException(super.message, {super.statusCode});
}

class UnauthorizedException extends AppException {
  UnauthorizedException(super.message) : super(statusCode: 401);
}

class ValidationException extends AppException {
  ValidationException(super.message, {super.statusCode});
}
