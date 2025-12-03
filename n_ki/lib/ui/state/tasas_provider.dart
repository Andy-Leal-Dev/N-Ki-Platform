import 'package:flutter/material.dart';

import '../../core/error/app_exception.dart';
import '../../data/models/tasa.dart';
import '../../data/repositories/tasas_repository.dart';

class TasasProvider extends ChangeNotifier {
  TasasProvider(this._repository) {
    Future<void>.microtask(() => loadTasas());
  }

  final TasasRepository _repository;

  List<Tasa> _tasas = <Tasa>[];
  bool _isLoading = false;
  String? _error;

  List<Tasa> get tasas => _tasas;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTasas() async {
    _setLoading(true);
    try {
      _tasas = await _repository.listTasas();
      _error = null;
    } on AppException catch (error) {
      _error = error.message;
    } finally {
      _setLoading(false);
    }
  }

  Future<Tasa?> createTasa({
    required String fecha,
    required double tasaDiaria,
  }) async {
    try {
      final Tasa tasa = await _repository.createTasa(
        fecha: fecha,
        tasaDiaria: tasaDiaria,
      );
      _tasas.insert(0, tasa);
      notifyListeners();
      return tasa;
    } on AppException catch (error) {
      _error = error.message;
      notifyListeners();
      return null;
    }
  }

  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }
}
