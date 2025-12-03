import 'package:equatable/equatable.dart';

class Tasa extends Equatable {
  const Tasa({required this.id, required this.fecha, required this.tasaDiaria});

  final int id;
  final DateTime fecha;
  final double tasaDiaria;

  factory Tasa.fromJson(Map<String, dynamic> json) {
    return Tasa(
      id: json['id'] as int,
      fecha: DateTime.parse(json['fecha'] as String),
      tasaDiaria: _parseDecimal(json['tasaDiaria']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'fecha': fecha.toIso8601String(),
    'tasaDiaria': tasaDiaria,
  };

  static double _parseDecimal(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '0') ?? 0;
  }

  @override
  List<Object?> get props => <Object?>[id, fecha, tasaDiaria];
}
