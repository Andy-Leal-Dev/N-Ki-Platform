import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle, rootBundle;

import '../../core/error/app_exception.dart';

class StaticDataSource {
  StaticDataSource({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  final Map<String, List<Map<String, dynamic>>> _listCache =
      <String, List<Map<String, dynamic>>>{};
  final Map<String, Map<String, dynamic>> _mapCache =
      <String, Map<String, dynamic>>{};

  Future<List<Map<String, dynamic>>> loadList(String filename) async {
    if (_listCache.containsKey(filename)) {
      return _listCache[filename]!;
    }
    final dynamic data = await _loadJson(filename);
    if (data is List) {
      final List<Map<String, dynamic>> list = data
          .map<Map<String, dynamic>>(
            (dynamic item) =>
                Map<String, dynamic>.from(item as Map<String, dynamic>),
          )
          .toList();
      _listCache[filename] = list;
      return list;
    }
    throw AppException('Formato inválido en $filename');
  }

  Future<Map<String, dynamic>> loadMap(String filename) async {
    if (_mapCache.containsKey(filename)) {
      return _mapCache[filename]!;
    }
    final dynamic data = await _loadJson(filename);
    if (data is Map<String, dynamic>) {
      final Map<String, dynamic> map = Map<String, dynamic>.from(data);
      _mapCache[filename] = map;
      return map;
    }
    throw AppException('Formato inválido en $filename');
  }

  Future<dynamic> _loadJson(String filename) async {
    final String raw = await _bundle.loadString('assets/$filename');
    return json.decode(raw);
  }
}
