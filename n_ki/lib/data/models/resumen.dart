import 'package:equatable/equatable.dart';

class ResumenFinanciero extends Equatable {
  const ResumenFinanciero({
    required this.fecha,
    required this.capitalPrestado,
    required this.gananciasTotales,
    required this.dineroCalle,
    required this.totalClientes,
    required this.totalPrestamosActivos,
  });

  final DateTime fecha;
  final double capitalPrestado;
  final double gananciasTotales;
  final double dineroCalle;
  final int totalClientes;
  final int totalPrestamosActivos;

  factory ResumenFinanciero.fromJson(Map<String, dynamic> json) {
    return ResumenFinanciero(
      fecha: DateTime.parse(json['fecha'] as String),
      capitalPrestado: _parseDecimal(json['capitalPrestado']),
      gananciasTotales: _parseDecimal(json['gananciasTotales']),
      dineroCalle: _parseDecimal(json['dineroCalle']),
      totalClientes: json['totalClientes'] as int? ?? 0,
      totalPrestamosActivos: json['totalPrestamosActivos'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'fecha': fecha.toIso8601String(),
    'capitalPrestado': capitalPrestado,
    'gananciasTotales': gananciasTotales,
    'dineroCalle': dineroCalle,
    'totalClientes': totalClientes,
    'totalPrestamosActivos': totalPrestamosActivos,
  };

  static double _parseDecimal(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '0') ?? 0;
  }

  @override
  List<Object?> get props => <Object?>[
    fecha,
    capitalPrestado,
    gananciasTotales,
    dineroCalle,
    totalClientes,
    totalPrestamosActivos,
  ];
}
