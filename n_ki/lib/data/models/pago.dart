import 'package:equatable/equatable.dart';

class Pago extends Equatable {
  const Pago({
    required this.id,
    required this.cuotaId,
    required this.monto,
    required this.fecha,
    this.referencia,
    this.observaciones,
  });

  final int id;
  final int cuotaId;
  final double monto;
  final DateTime fecha;
  final String? referencia;
  final String? observaciones;

  factory Pago.fromJson(Map<String, dynamic> json) {
    return Pago(
      id: json['id'] as int,
      cuotaId: json['cuotaId'] as int,
      monto: _parseDecimal(json['monto']),
      fecha: DateTime.parse(json['fecha'] as String),
      referencia: json['referencia'] as String?,
      observaciones: json['observaciones'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'cuotaId': cuotaId,
    'monto': monto,
    'fecha': fecha.toIso8601String(),
    'referencia': referencia,
    'observaciones': observaciones,
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
    cuotaId,
    monto,
    fecha,
    referencia,
    observaciones,
  ];
}
