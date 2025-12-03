import '../../core/error/app_exception.dart';
import '../../core/network/api_client.dart';
import '../models/cuota.dart';
import '../models/prestamo.dart';

class PrestamosRepository {
  PrestamosRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Prestamo>> listPrestamos() async {
    final Map<String, dynamic> data = await _getData('/prestamos');
    final List<dynamic> items = data['data'] as List<dynamic>? ?? <dynamic>[];
    return items
        .map((dynamic item) => Prestamo.fromJson(item as Map<String, dynamic>))
        .toList();
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
    final Map<String, dynamic> data = await _postData(
      '/prestamos',
      body: <String, dynamic>{
        'clienteId': clienteId,
        if (tasaId != null) 'tasaId': tasaId,
        'montoCapital': montoCapital,
        'tasaInteres': tasaInteres,
        'frecuenciaPago': frecuenciaPago,
        'fechaInicio': fechaInicio,
        'fechaVencimiento': fechaVencimiento,
        'numeroCuotas': numeroCuotas,
      },
    );
    return Prestamo.fromJson(data['data'] as Map<String, dynamic>);
  }

  Future<Prestamo> getPrestamo(int id) async {
    final Map<String, dynamic> data = await _getData('/prestamos/$id');
    return Prestamo.fromJson(data['data'] as Map<String, dynamic>);
  }

  Future<List<Cuota>> listCuotas(int prestamoId) async {
    final Map<String, dynamic> data = await _getData(
      '/prestamos/$prestamoId/cuotas',
    );
    final List<dynamic> items = data['data'] as List<dynamic>? ?? <dynamic>[];
    return items
        .map((dynamic item) => Cuota.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Prestamo> updatePrestamo({
    required int id,
    int? tasaId,
    double? tasaInteres,
    String? frecuenciaPago,
    String? fechaVencimiento,
    String? estado,
  }) async {
    final Map<String, dynamic> body = <String, dynamic>{};
    if (tasaId != null) body['tasaId'] = tasaId;
    if (tasaInteres != null) body['tasaInteres'] = tasaInteres;
    if (frecuenciaPago != null) body['frecuenciaPago'] = frecuenciaPago;
    if (fechaVencimiento != null) body['fechaVencimiento'] = fechaVencimiento;
    if (estado != null) body['estado'] = estado;

    final Map<String, dynamic> data = await _putData(
      '/prestamos/$id',
      body: body,
    );
    return Prestamo.fromJson(data['data'] as Map<String, dynamic>);
  }

  Future<void> deletePrestamo(int id) async {
    await _apiClient.delete('/prestamos/$id');
  }

  Future<Map<String, dynamic>> _getData(String path) async {
    final response = await _apiClient.get(path);
    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> _postData(String path, {Object? body}) async {
    final response = await _apiClient.post(path, data: body);
    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> _putData(String path, {Object? body}) async {
    final response = await _apiClient.put(path, data: body);
    return _asMap(response.data);
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    throw AppException('Respuesta inesperada del servidor');
  }
}
