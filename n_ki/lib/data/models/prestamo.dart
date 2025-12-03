import 'package:equatable/equatable.dart';

import 'cliente.dart';
import 'cuota.dart';
import 'tasa.dart';

class Prestamo extends Equatable {
  const Prestamo({
    required this.id,
    required this.usuarioId,
    required this.clienteId,
    required this.montoCapital,
    required this.tasaInteres,
    required this.frecuenciaPago,
    required this.fechaInicio,
    required this.fechaVencimiento,
    required this.estado,
    required this.totalInteres,
    required this.saldoPendiente,
    required this.cliente,
    required this.tasa,
    required this.cuotas,
  });

  final int id;
  final int usuarioId;
  final int clienteId;
  final double montoCapital;
  final double tasaInteres;
  final String frecuenciaPago;
  final DateTime fechaInicio;
  final DateTime fechaVencimiento;
  final String estado;
  final double totalInteres;
  final double saldoPendiente;
  final Cliente cliente;
  final Tasa? tasa;
  final List<Cuota> cuotas;

  double get totalPrestamo => montoCapital + totalInteres;
  double get totalCobrado =>
      cuotas.fold<double>(0, (sum, cuota) => sum + cuota.totalPagado);

  factory Prestamo.fromJson(Map<String, dynamic> json) {
    return Prestamo(
      id: json['id'] as int,
      usuarioId: json['usuarioId'] as int,
      clienteId: json['clienteId'] as int,
      montoCapital: _parseDecimal(json['montoCapital']),
      tasaInteres: _parseDecimal(json['tasaInteres']),
      frecuenciaPago: json['frecuenciaPago'] as String? ?? '',
      fechaInicio: DateTime.parse(json['fechaInicio'] as String),
      fechaVencimiento: DateTime.parse(json['fechaVencimiento'] as String),
      estado: json['estado'] as String? ?? 'Activo',
      totalInteres: _parseDecimal(json['totalInteres']),
      saldoPendiente: _parseDecimal(json['saldoPendiente']),
      cliente: Cliente.fromJson(json['cliente'] as Map<String, dynamic>),
      tasa: json['tasa'] != null
          ? Tasa.fromJson(json['tasa'] as Map<String, dynamic>)
          : null,
      cuotas: (json['cuotas'] as List<dynamic>? ?? <dynamic>[])
          .map((dynamic item) => Cuota.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'usuarioId': usuarioId,
    'clienteId': clienteId,
    'montoCapital': montoCapital,
    'tasaInteres': tasaInteres,
    'frecuenciaPago': frecuenciaPago,
    'fechaInicio': fechaInicio.toIso8601String(),
    'fechaVencimiento': fechaVencimiento.toIso8601String(),
    'estado': estado,
    'totalInteres': totalInteres,
    'saldoPendiente': saldoPendiente,
    'cliente': cliente.toJson(),
    'tasa': tasa?.toJson(),
    'cuotas': cuotas.map((Cuota cuota) => cuota.toJson()).toList(),
  };

  static double _parseDecimal(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '0') ?? 0;
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    usuarioId,
    clienteId,
    montoCapital,
    tasaInteres,
    frecuenciaPago,
    fechaInicio,
    fechaVencimiento,
    estado,
    totalInteres,
    saldoPendiente,
    cliente,
    tasa,
    cuotas,
  ];
}
