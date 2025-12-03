import 'package:dio/dio.dart';

import '../config/app_config.dart';

Dio createBaseDio() {
  return Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      responseType: ResponseType.json,
      headers: <String, dynamic>{'Content-Type': 'application/json'},
    ),
  );
}
