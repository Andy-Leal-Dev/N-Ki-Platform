import '../data_sources/static_data_source.dart';
import '../models/pago.dart';

class PagosRepository {
  PagosRepository(this._dataSource);

  final StaticDataSource _dataSource;
  static const String _file = 'pagos.json';

  Future<List<Pago>> listPagos(int cuotaId) async {
    final List<Map<String, dynamic>> raw = await _dataSource.loadList(_file);
    return raw
        .where((Map<String, dynamic> item) => item['cuotaId'] == cuotaId)
        .map(Pago.fromJson)
        .toList();
  }

  Future<Pago> createPago({
    required int cuotaId,
    required double monto,
    required String fecha,
    String? referencia,
    String? observaciones,
  }) async {
    final List<Map<String, dynamic>> pagos = await _dataSource.loadList(_file);
    final int nextId =
        pagos.fold<int>(0, (int acc, Map<String, dynamic> item) {
          final int currentId = item['id'] as int? ?? 0;
          return currentId > acc ? currentId : acc;
        }) +
        1;

    final Map<String, dynamic> created = <String, dynamic>{
      'id': nextId,
      'cuotaId': cuotaId,
      'monto': monto,
      'fecha': fecha,
      'referencia': referencia,
      'observaciones': observaciones,
    };

    pagos.insert(0, created);
    return Pago.fromJson(created);
  }
}
