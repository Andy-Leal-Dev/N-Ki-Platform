import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppSecureStorage {
  AppSecureStorage({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _secureStorage;
  static final Map<String, String> _memoryStore = <String, String>{};

  Future<void> write({required String key, required String value}) async {
    if (kIsWeb) {
      _memoryStore[key] = value;
      return;
    }
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    if (kIsWeb) {
      return _memoryStore[key];
    }
    return _secureStorage.read(key: key);
  }

  Future<void> delete(String key) async {
    if (kIsWeb) {
      _memoryStore.remove(key);
      return;
    }
    await _secureStorage.delete(key: key);
  }

  Future<void> deleteAll() async {
    if (kIsWeb) {
      _memoryStore.clear();
      return;
    }
    await _secureStorage.deleteAll();
  }
}
