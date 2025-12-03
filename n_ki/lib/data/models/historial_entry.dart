class HistorialEntry {
  HistorialEntry({
    required this.id,
    required this.prestamoId,
    required this.clienteId,
    required this.clienteNombre,
    required this.prestamoCodigo,
    required this.fechaMovimiento,
    required this.monto,
    required this.saldoRestante,
    required this.tipoMovimiento,
    required this.estado,
    required this.canal,
    this.nota,
  });

  final int id;
  final int prestamoId;
  final int clienteId;
  final String clienteNombre;
  final String prestamoCodigo;
  final DateTime fechaMovimiento;
  final double monto;
  final double saldoRestante;
  final String tipoMovimiento;
  final String estado;
  final String canal;
  final String? nota;

  factory HistorialEntry.fromJson(Map<String, dynamic> json) {
    return HistorialEntry(
      id: json['id'] as int,
      prestamoId: json['prestamoId'] as int,
      clienteId: json['clienteId'] as int,
      clienteNombre: json['clienteNombre'] as String,
      prestamoCodigo: json['prestamoCodigo'] as String,
      fechaMovimiento: DateTime.parse(json['fechaMovimiento'] as String),
      monto: (json['monto'] as num).toDouble(),
      saldoRestante: (json['saldoRestante'] as num).toDouble(),
      tipoMovimiento: (json['tipoMovimiento'] as String).toLowerCase(),
      estado: (json['estado'] as String).toLowerCase(),
      canal: json['canal'] as String,
      nota: json['nota'] as String?,
    );
  }
}
