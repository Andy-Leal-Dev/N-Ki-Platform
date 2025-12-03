class AppUser {
  const AppUser({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.correo,
    this.googleId,
  });

  final int id;
  final String nombre;
  final String apellido;
  final String correo;
  final String? googleId;

  String get nombreCompleto => '$nombre $apellido'.trim();

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as int,
      nombre: json['nombre'] as String? ?? '',
      apellido: json['apellido'] as String? ?? '',
      correo: json['correo'] as String? ?? '',
      googleId: json['googleId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'nombre': nombre,
    'apellido': apellido,
    'correo': correo,
    'googleId': googleId,
  };
}
