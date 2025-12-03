import '../../core/error/app_exception.dart';
import '../../core/network/api_client.dart';
import '../models/cliente.dart';

class ClientesRepository {
  ClientesRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Cliente>> listClientes() async {
    final Map<String, dynamic> data = await _getData('/clientes');
    final List<dynamic> items = data['data'] as List<dynamic>? ?? <dynamic>[];
    return items
        .map((dynamic item) => Cliente.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Cliente> createCliente({
    required String cedula,
    required String nombre,
    String? telefono,
    String? direccion,
    String? tipo,
  }) async {
    final Map<String, dynamic> data = await _postData(
      '/clientes',
      body: <String, dynamic>{
        'cedula': cedula,
        'nombre': nombre,
        'telefono': telefono,
        'direccion': direccion,
        if (tipo != null) 'tipo': tipo,
      },
    );
    return Cliente.fromJson(data['data'] as Map<String, dynamic>);
  }

  Future<Cliente> updateCliente({
    required int id,
    String? cedula,
    String? nombre,
    String? telefono,
    String? direccion,
    String? tipo,
  }) async {
    final Map<String, dynamic> data = await _putData(
      '/clientes/$id',
      body: <String, dynamic>{
        if (cedula != null) 'cedula': cedula,
        if (nombre != null) 'nombre': nombre,
        if (telefono != null) 'telefono': telefono,
        if (direccion != null) 'direccion': direccion,
        if (tipo != null) 'tipo': tipo,
      },
    );
    return Cliente.fromJson(data['data'] as Map<String, dynamic>);
  }

  Future<void> deleteCliente(int id) async {
    await _apiClient.delete('/clientes/$id');
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
