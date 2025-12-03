import 'package:equatable/equatable.dart';

class AgendaRegistro extends Equatable {
  const AgendaRegistro({
    required this.id,
    required this.prestamoId,
    required this.clienteId,
    required this.clienteNombre,
    required this.numeroCuota,
    required this.fechaVencimiento,
    required this.montoTotalCuota,
    required this.estaPagada,
    required this.diasRetraso,
  });

  final int id;
  final int prestamoId;
  final int clienteId;
  final String clienteNombre;
  final int numeroCuota;
  final DateTime fechaVencimiento;
  final double montoTotalCuota;
  final bool estaPagada;
  final int diasRetraso;

  factory AgendaRegistro.fromJson(Map<String, dynamic> json) {
    return AgendaRegistro(
      id: json['id'] as int,
      prestamoId: json['prestamoId'] as int,
      clienteId: json['clienteId'] as int,
      clienteNombre: json['clienteNombre'] as String? ?? '',
      numeroCuota: json['numeroCuota'] as int? ?? 0,
      fechaVencimiento: DateTime.parse(json['fechaVencimiento'] as String),
      montoTotalCuota: _parseDecimal(json['montoTotalCuota']),
      estaPagada: json['estaPagada'] as bool? ?? false,
      diasRetraso: json['diasRetraso'] as int? ?? 0,
    );
  }

  static double _parseDecimal(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '0') ?? 0;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'prestamoId': prestamoId,
    'clienteId': clienteId,
    'clienteNombre': clienteNombre,
    'numeroCuota': numeroCuota,
    'fechaVencimiento': fechaVencimiento.toIso8601String(),
    'montoTotalCuota': montoTotalCuota,
    'estaPagada': estaPagada,
    'diasRetraso': diasRetraso,
  };

  @override
  List<Object?> get props => <Object?>[
    id,
    prestamoId,
    clienteId,
    clienteNombre,
    numeroCuota,
    fechaVencimiento,
    montoTotalCuota,
    estaPagada,
    diasRetraso,
  ];
}
