import '../../core/error/app_exception.dart';
import '../../core/network/api_client.dart';
import '../models/pago.dart';

class PagosRepository {
  PagosRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Pago>> listPagos(int cuotaId) async {
    final Map<String, dynamic> data = await _getData('/cuotas/$cuotaId/pagos');
    final List<dynamic> items = data['data'] as List<dynamic>? ?? <dynamic>[];
    return items
        .map((dynamic item) => Pago.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Pago> createPago({
    required int cuotaId,
    required double monto,
    required String fecha,
    String? referencia,
    String? observaciones,
  }) async {
    final Map<String, dynamic> data = await _postData(
      '/cuotas/$cuotaId/pagos',
      body: <String, dynamic>{
        'monto': monto,
        'fecha': fecha,
        'referencia': referencia,
        'observaciones': observaciones,
      },
    );
    return Pago.fromJson(data['data'] as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> _getData(String path) async {
    final response = await _apiClient.get(path);
    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> _postData(String path, {Object? body}) async {
    final response = await _apiClient.post(path, data: body);
    return _asMap(response.data);
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    throw AppException('Respuesta inesperada del servidor');
  }
}
