import 'package:flutter/material.dart';

import '../../data/models/historial_entry.dart';
import '../../data/repositories/historial_repository.dart';

class HistorialProvider extends ChangeNotifier {
  HistorialProvider(this._repository);

  final HistorialRepository _repository;

  List<HistorialEntry> _entries = <HistorialEntry>[];
  bool _isLoading = false;
  String? _error;
  String? _filter;

  List<HistorialEntry> get entries {
    if (_filter == null || _filter == 'todos') {
      return _entries;
    }
    return _entries
        .where((HistorialEntry e) => e.tipoMovimiento == _filter)
        .toList();
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get filter => _filter ?? 'todos';
  bool get hasEntries => _entries.isNotEmpty;

  Future<void> loadHistorial() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _entries = await _repository.listHistorial();
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFilter(String? filter) {
    _filter = filter == null || filter.isEmpty ? 'todos' : filter;
    notifyListeners();
  }
}
