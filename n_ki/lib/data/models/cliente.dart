import 'package:equatable/equatable.dart';

class Cliente extends Equatable {
  const Cliente({
    required this.id,
    required this.cedula,
    required this.nombre,
    this.telefono,
    this.direccion,
    this.tipo,
  });

  final int id;
  final String cedula;
  final String nombre;
  final String? telefono;
  final String? direccion;
  final String? tipo;

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] as int,
      cedula: json['cedula'] as String? ?? '',
      nombre: json['nombre'] as String? ?? '',
      telefono: json['telefono'] as String?,
      direccion: json['direccion'] as String?,
      tipo: json['tipo'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'cedula': cedula,
    'nombre': nombre,
    'telefono': telefono,
    'direccion': direccion,
    'tipo': tipo,
  };

  Cliente copyWith({
    String? cedula,
    String? nombre,
    String? telefono,
    String? direccion,
    String? tipo,
  }) {
    return Cliente(
      id: id,
      cedula: cedula ?? this.cedula,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      direccion: direccion ?? this.direccion,
      tipo: tipo ?? this.tipo,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    cedula,
    nombre,
    telefono,
    direccion,
    tipo,
  ];
}
