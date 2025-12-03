import 'dart:io';

import 'package:flutter/foundation.dart';

class AppConfig {
  static String get apiBaseUrl {
    const envUrl = String.fromEnvironment('API_BASE_URL');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }

    if (kIsWeb) {
      return 'http://localhost:4000/api/v1';
    }

    if (Platform.isAndroid) {
      return 'http://10.0.2.2:4000/api/v1';
    }

    return 'http://localhost:4000/api/v1';
  }

  /// If true, the app will use the real backend. If false, the app will use
  /// a built-in mock client that returns static data (useful for testing
  /// features like taking a photo without a full backend).
  static bool get useBackend {
    const boolEnv = bool.fromEnvironment('USE_BACKEND', defaultValue: false);
    return boolEnv;
  }
}
