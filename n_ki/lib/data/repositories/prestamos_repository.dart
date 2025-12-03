import '../../core/error/app_exception.dart';
import '../data_sources/static_data_source.dart';
import '../models/cuota.dart';
import '../models/prestamo.dart';
import '../models/agenda_registro.dart';

class PrestamosRepository {
  PrestamosRepository(this._dataSource);

  final StaticDataSource _dataSource;
  static const String _prestamosFile = 'prestamos.json';
  static const String _clientesFile = 'clients.json';

  Future<List<Prestamo>> listPrestamos() async {
    final List<Map<String, dynamic>> raw = await _dataSource.loadList(
      _prestamosFile,
    );
    return raw.map(Prestamo.fromJson).toList();
  }

  Future<Prestamo> createPrestamo({
    required int clienteId,
    int? tasaId,
    required double montoCapital,
    required double tasaInteres,
    required String frecuenciaPago,
    required String fechaInicio,
    required String fechaVencimiento,
    required int numeroCuotas,
  }) async {
    final List<Map<String, dynamic>> prestamos = await _dataSource.loadList(
      _prestamosFile,
    );
    final List<Map<String, dynamic>> clientes = await _dataSource.loadList(
      _clientesFile,
    );
    final int nextId =
        prestamos.fold<int>(0, (int acc, Map<String, dynamic> item) {
          final int currentId = item['id'] as int? ?? 0;
          return currentId > acc ? currentId : acc;
        }) +
        1;

    final Map<String, dynamic>? cliente = clientes.firstWhere(
      (Map<String, dynamic> item) => item['id'] == clienteId,
      orElse: () => <String, dynamic>{},
    );

    final Map<String, dynamic> created = <String, dynamic>{
      'id': nextId,
      'usuarioId': 1,
      'clienteId': clienteId,
      'montoCapital': montoCapital,
      'tasaInteres': tasaInteres,
      'frecuenciaPago': frecuenciaPago,
      'fechaInicio': fechaInicio,
      'fechaVencimiento': fechaVencimiento,
      'numeroCuotas': numeroCuotas,
      'montoCuota': montoCapital / numeroCuotas,
      'proximoVencimiento': fechaVencimiento,
      'estado': 'activo',
      'totalInteres': montoCapital * (tasaInteres / 100),
      'saldoPendiente': montoCapital,
      'cliente': cliente != null && cliente.isNotEmpty
          ? <String, dynamic>{
              'id': cliente['id'],
              'cedula': cliente['cedula'],
              'nombre': cliente['nombre'],
            }
          : null,
      'tasa': tasaId != null ? <String, dynamic>{'id': tasaId} : null,
      'cuotas': <Map<String, dynamic>>[],
    };

    prestamos.insert(0, created);
    return Prestamo.fromJson(created);
  }

  Future<Prestamo> getPrestamo(int id) async {
    final List<Map<String, dynamic>> prestamos = await _dataSource.loadList(
      _prestamosFile,
    );
    final Map<String, dynamic>? raw = prestamos.firstWhere(
      (Map<String, dynamic> item) => item['id'] == id,
      orElse: () => <String, dynamic>{},
    );
    if (raw == null || raw.isEmpty) {
      throw AppException('Préstamo no encontrado');
    }
    return Prestamo.fromJson(raw);
  }

  Future<List<Cuota>> listCuotas(int prestamoId) async {
    final List<Map<String, dynamic>> prestamos = await _dataSource.loadList(
      _prestamosFile,
    );
    final Map<String, dynamic>? rawPrestamo = prestamos.firstWhere(
      (Map<String, dynamic> item) => item['id'] == prestamoId,
      orElse: () => <String, dynamic>{},
    );
    if (rawPrestamo == null || rawPrestamo.isEmpty) {
      return <Cuota>[];
    }
    final List<dynamic> cuotas =
        rawPrestamo['cuotas'] as List<dynamic>? ?? <dynamic>[];
    return cuotas
        .map((dynamic item) => Cuota.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<AgendaRegistro>> listAgenda({
    String? fromDate,
    String? toDate,
  }) async {
    final List<Map<String, dynamic>> prestamos = await _dataSource.loadList(
      _prestamosFile,
    );
    final List<Map<String, dynamic>> clientes = await _dataSource.loadList(
      _clientesFile,
    );
    final List<AgendaRegistro> agenda = <AgendaRegistro>[];

    for (final Map<String, dynamic> prestamo in prestamos) {
      if ((prestamo['estado'] as String?)?.toLowerCase() != 'activo') {
        continue;
      }
      final Map<String, dynamic>? cliente = clientes.firstWhere(
        (Map<String, dynamic> c) => c['id'] == prestamo['clienteId'],
        orElse: () => <String, dynamic>{},
      );
      final double cuota =
          (prestamo['montoCuota'] as num?)?.toDouble() ??
          ((prestamo['montoCapital'] as num?)?.toDouble() ?? 0) /
              ((prestamo['numeroCuotas'] as num?)?.toDouble() ?? 1);
      agenda.add(
        AgendaRegistro(
          id: (prestamo['id'] as int) * 1000 + 1,
          prestamoId: prestamo['id'] as int,
          clienteId: prestamo['clienteId'] as int,
          clienteNombre: cliente != null && cliente.isNotEmpty
              ? cliente['nombre'] as String
              : 'Cliente',
          numeroCuota: 1,
          fechaVencimiento: DateTime.parse(
            (prestamo['proximoVencimiento'] as String?) ??
                DateTime.now().toIso8601String(),
          ),
          montoTotalCuota: cuota,
          estaPagada: false,
          diasRetraso: 0,
        ),
      );
    }

    return agenda;
  }

  Future<Prestamo> updatePrestamo({
    required int id,
    int? tasaId,
    double? tasaInteres,
    String? frecuenciaPago,
    String? fechaVencimiento,
    String? estado,
  }) async {
    final List<Map<String, dynamic>> prestamos = await _dataSource.loadList(
      _prestamosFile,
    );
    final int index = prestamos.indexWhere(
      (Map<String, dynamic> item) => item['id'] == id,
    );
    if (index == -1) {
      throw AppException('Préstamo no encontrado');
    }

    final Map<String, dynamic> updated = Map<String, dynamic>.from(
      prestamos[index],
    );
    if (tasaId != null) updated['tasa'] = <String, dynamic>{'id': tasaId};
    if (tasaInteres != null) updated['tasaInteres'] = tasaInteres;
    if (frecuenciaPago != null) updated['frecuenciaPago'] = frecuenciaPago;
    if (fechaVencimiento != null) {
      updated['fechaVencimiento'] = fechaVencimiento;
      updated['proximoVencimiento'] = fechaVencimiento;
    }
    if (estado != null) updated['estado'] = estado;

    prestamos[index] = updated;
    return Prestamo.fromJson(updated);
  }

  Future<void> deletePrestamo(int id) async {
    final List<Map<String, dynamic>> prestamos = await _dataSource.loadList(
      _prestamosFile,
    );
    prestamos.removeWhere((Map<String, dynamic> item) => item['id'] == id);
  }
}
