import 'package:equatable/equatable.dart';

import 'pago.dart';

class Cuota extends Equatable {
  const Cuota({
    required this.id,
    required this.prestamoId,
    required this.numeroCuota,
    required this.fechaVencimiento,
    required this.capitalCuota,
    required this.interesCuota,
    required this.montoTotalCuota,
    required this.diasRetraso,
    required this.pagos,
  });

  final int id;
  final int prestamoId;
  final int numeroCuota;
  final DateTime fechaVencimiento;
  final double capitalCuota;
  final double interesCuota;
  final double montoTotalCuota;
  final int diasRetraso;
  final List<Pago> pagos;

  double get totalPagado =>
      pagos.fold<double>(0, (sum, pago) => sum + pago.monto);

  bool get estaPagada => totalPagado >= montoTotalCuota - 0.01;

  factory Cuota.fromJson(Map<String, dynamic> json) {
    return Cuota(
      id: json['id'] as int,
      prestamoId: json['prestamoId'] as int,
      numeroCuota: json['numeroCuota'] as int,
      fechaVencimiento: DateTime.parse(json['fechaVencimiento'] as String),
      capitalCuota: _parseDecimal(json['capitalCuota']),
      interesCuota: _parseDecimal(json['interesCuota']),
      montoTotalCuota: _parseDecimal(json['montoTotalCuota']),
      diasRetraso: json['diasRetraso'] as int? ?? 0,
      pagos: (json['pagos'] as List<dynamic>? ?? <dynamic>[])
          .map((dynamic item) => Pago.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'prestamoId': prestamoId,
    'numeroCuota': numeroCuota,
    'fechaVencimiento': fechaVencimiento.toIso8601String(),
    'capitalCuota': capitalCuota,
    'interesCuota': interesCuota,
    'montoTotalCuota': montoTotalCuota,
    'diasRetraso': diasRetraso,
    'pagos': pagos.map((Pago pago) => pago.toJson()).toList(),
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
    prestamoId,
    numeroCuota,
    fechaVencimiento,
    capitalCuota,
    interesCuota,
    montoTotalCuota,
    diasRetraso,
    pagos,
  ];
}
