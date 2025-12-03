import '../../core/error/app_exception.dart';
import '../../core/network/api_client.dart';
import '../models/tasa.dart';

class TasasRepository {
  TasasRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Tasa>> listTasas() async {
    final Map<String, dynamic> data = await _getData('/tasas');
    final List<dynamic> items = data['data'] as List<dynamic>? ?? <dynamic>[];
    return items
        .map((dynamic item) => Tasa.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Tasa> createTasa({
    required String fecha,
    required double tasaDiaria,
  }) async {
    final Map<String, dynamic> data = await _postData(
      '/tasas',
      body: <String, dynamic>{'fecha': fecha, 'tasaDiaria': tasaDiaria},
    );
    return Tasa.fromJson(data['data'] as Map<String, dynamic>);
  }

  Future<Tasa> updateTasa({
    required int id,
    String? fecha,
    double? tasaDiaria,
  }) async {
    final Map<String, dynamic> body = <String, dynamic>{};
    if (fecha != null) body['fecha'] = fecha;
    if (tasaDiaria != null) body['tasaDiaria'] = tasaDiaria;

    final Map<String, dynamic> data = await _putData('/tasas/$id', body: body);
    return Tasa.fromJson(data['data'] as Map<String, dynamic>);
  }

  Future<void> deleteTasa(int id) async {
    await _apiClient.delete('/tasas/$id');
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
