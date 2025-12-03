import 'package:flutter/material.dart';

import '../../core/error/app_exception.dart';
import '../../data/models/resumen.dart';
import '../../data/repositories/resumen_repository.dart';

class ResumenProvider extends ChangeNotifier {
  ResumenProvider(this._repository) {
    Future<void>.microtask(() => loadResumen());
  }

  final ResumenRepository _repository;

  List<ResumenFinanciero> _resumenes = <ResumenFinanciero>[];
  bool _isLoading = false;
  String? _error;

  List<ResumenFinanciero> get resumenes => _resumenes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  ResumenFinanciero? get latest => _resumenes.isEmpty ? null : _resumenes.first;

  Future<void> loadResumen({String? fechaInicio, String? fechaFin}) async {
    _setLoading(true);
    try {
      _resumenes = await _repository.listResumenes(
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
      );
      _error = null;
    } on AppException catch (error) {
      _error = error.message;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }
}
