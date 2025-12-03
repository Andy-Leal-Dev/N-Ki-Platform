import 'package:flutter/material.dart';

import '../../core/error/app_exception.dart';
import '../../data/models/pago.dart';
import '../../data/models/prestamo.dart';
import '../../data/repositories/pagos_repository.dart';
import '../../data/repositories/prestamos_repository.dart';

class PrestamosProvider extends ChangeNotifier {
  PrestamosProvider({
    required PrestamosRepository prestamosRepository,
    required PagosRepository pagosRepository,
  }) : _prestamosRepository = prestamosRepository,
       _pagosRepository = pagosRepository;

  final PrestamosRepository _prestamosRepository;
  final PagosRepository _pagosRepository;

  final List<Prestamo> _prestamos = <Prestamo>[];
  bool _isLoading = false;
  String? _error;

  List<Prestamo> get prestamos => List<Prestamo>.unmodifiable(_prestamos);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPrestamos() async {
    _setLoading(true);
    try {
      final List<Prestamo> items = await _prestamosRepository.listPrestamos();
      _prestamos
        ..clear()
        ..addAll(items);
      _error = null;
    } on AppException catch (error) {
      _error = error.message;
    } finally {
      _setLoading(false);
    }
  }

  Future<Prestamo?> createPrestamo({
    required int clienteId,
    int? tasaId,
    required double montoCapital,
    required double tasaInteres,
    required String frecuenciaPago,
    required String fechaInicio,
    required String fechaVencimiento,
    required int numeroCuotas,
  }) async {
    try {
      final Prestamo prestamo = await _prestamosRepository.createPrestamo(
        clienteId: clienteId,
        tasaId: tasaId,
        montoCapital: montoCapital,
        tasaInteres: tasaInteres,
        frecuenciaPago: frecuenciaPago,
        fechaInicio: fechaInicio,
        fechaVencimiento: fechaVencimiento,
        numeroCuotas: numeroCuotas,
      );
      _prestamos.insert(0, prestamo);
      notifyListeners();
      return prestamo;
    } on AppException catch (error) {
      _error = error.message;
      notifyListeners();
      return null;
    }
  }

  Future<Prestamo?> refreshPrestamo(int id) async {
    try {
      final Prestamo prestamo = await _prestamosRepository.getPrestamo(id);
      final int index = _prestamos.indexWhere((Prestamo item) => item.id == id);
      if (index == -1) {
        _prestamos.add(prestamo);
      } else {
        _prestamos[index] = prestamo;
      }
      notifyListeners();
      return prestamo;
    } on AppException catch (error) {
      _error = error.message;
      notifyListeners();
      return null;
    }
  }

  Future<Pago?> registrarPago({
    required int prestamoId,
    required int cuotaId,
    required double monto,
    required String fecha,
    String? referencia,
    String? observaciones,
  }) async {
    try {
      final Pago pago = await _pagosRepository.createPago(
        cuotaId: cuotaId,
        monto: monto,
        fecha: fecha,
        referencia: referencia,
        observaciones: observaciones,
      );
      await refreshPrestamo(prestamoId);
      return pago;
    } on AppException catch (error) {
      _error = error.message;
      notifyListeners();
      return null;
    }
  }

  Future<bool> deletePrestamo(int prestamoId) async {
    try {
      await _prestamosRepository.deletePrestamo(prestamoId);
      _prestamos.removeWhere((Prestamo item) => item.id == prestamoId);
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
