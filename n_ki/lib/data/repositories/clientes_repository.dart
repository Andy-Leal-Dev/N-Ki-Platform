import '../../core/error/app_exception.dart';
import '../data_sources/static_data_source.dart';
import '../models/cliente.dart';

class ClientesRepository {
  ClientesRepository(this._dataSource);

  final StaticDataSource _dataSource;
  static const String _file = 'clients.json';

  Future<List<Cliente>> listClientes() async {
    final List<Map<String, dynamic>> raw = await _dataSource.loadList(_file);
    return raw.map(Cliente.fromJson).toList();
  }

  Future<Cliente> createCliente({
    required String cedula,
    required String nombre,
    String? telefono,
    String? direccion,
    String? tipo,
  }) async {
    final List<Map<String, dynamic>> clients = await _dataSource.loadList(
      _file,
    );
    final int nextId =
        clients.fold<int>(0, (int acc, Map<String, dynamic> item) {
          final int currentId = item['id'] as int? ?? 0;
          return currentId > acc ? currentId : acc;
        }) +
        1;

    final Map<String, dynamic> created = <String, dynamic>{
      'id': nextId,
      'cedula': cedula,
      'nombre': nombre,
      'telefono': telefono,
      'direccion': direccion,
      if (tipo != null) 'tipo': tipo,
    };

    clients.insert(0, created);
    return Cliente.fromJson(created);
  }

  Future<Cliente> updateCliente({
    required int id,
    String? cedula,
    String? nombre,
    String? telefono,
    String? direccion,
    String? tipo,
  }) async {
    final List<Map<String, dynamic>> clients = await _dataSource.loadList(
      _file,
    );
    final int index = clients.indexWhere(
      (Map<String, dynamic> item) => item['id'] == id,
    );
    if (index == -1) {
      throw AppException('Cliente no encontrado');
    }

    final Map<String, dynamic> updated = Map<String, dynamic>.from(
      clients[index],
    );
    if (cedula != null) updated['cedula'] = cedula;
    if (nombre != null) updated['nombre'] = nombre;
    if (telefono != null) updated['telefono'] = telefono;
    if (direccion != null) updated['direccion'] = direccion;
    if (tipo != null) updated['tipo'] = tipo;

    clients[index] = updated;
    return Cliente.fromJson(updated);
  }

  Future<void> deleteCliente(int id) async {
    final List<Map<String, dynamic>> clients = await _dataSource.loadList(
      _file,
    );
    clients.removeWhere((Map<String, dynamic> item) => item['id'] == id);
  }
}
