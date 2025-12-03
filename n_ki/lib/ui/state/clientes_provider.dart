import 'package:flutter/material.dart';

import '../../core/error/app_exception.dart';
import '../../data/models/cliente.dart';
import '../../data/repositories/clientes_repository.dart';

class ClientesProvider extends ChangeNotifier {
  ClientesProvider(this._repository);

  final ClientesRepository _repository;

  final List<Cliente> _clientes = <Cliente>[];
  bool _isLoading = false;
  String? _error;

  List<Cliente> get clientes => List<Cliente>.unmodifiable(_clientes);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadClientes() async {
    _setLoading(true);
    try {
      final List<Cliente> items = await _repository.listClientes();
      _clientes
        ..clear()
        ..addAll(items);
      _error = null;
    } on AppException catch (error) {
      _error = error.message;
    } finally {
      _setLoading(false);
    }
  }

  Future<Cliente?> createCliente({
    required String cedula,
    required String nombre,
    String? telefono,
    String? direccion,
    String? tipo,
  }) async {
    try {
      final Cliente cliente = await _repository.createCliente(
        cedula: cedula,
        nombre: nombre,
        telefono: telefono,
        direccion: direccion,
        tipo: tipo,
      );
      _clientes.insert(0, cliente);
      notifyListeners();
      return cliente;
    } on AppException catch (error) {
      _error = error.message;
      notifyListeners();
      return null;
    }
  }

  Future<Cliente?> updateCliente({
    required int id,
    String? cedula,
    String? nombre,
    String? telefono,
    String? direccion,
    String? tipo,
  }) async {
    try {
      final Cliente updated = await _repository.updateCliente(
        id: id,
        cedula: cedula,
        nombre: nombre,
        telefono: telefono,
        direccion: direccion,
        tipo: tipo,
      );
      final int index = _clientes.indexWhere((Cliente item) => item.id == id);
      if (index != -1) {
        _clientes[index] = updated;
        notifyListeners();
      }
      return updated;
    } on AppException catch (error) {
      _error = error.message;
      notifyListeners();
      return null;
    }
  }

  Future<bool> deleteCliente(int id) async {
    try {
      await _repository.deleteCliente(id);
      _clientes.removeWhere((Cliente item) => item.id == id);
      notifyListeners();
      return true;
    } on AppException catch (error) {
      _error = error.message;
      notifyListeners();
      return false;
    }
  }

  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }
}
