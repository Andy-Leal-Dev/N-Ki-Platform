import '../../core/error/app_exception.dart';
import '../data_sources/static_data_source.dart';
import '../models/tasa.dart';

class TasasRepository {
  TasasRepository(this._dataSource);

  final StaticDataSource _dataSource;
  static const String _file = 'tasas.json';

  Future<List<Tasa>> listTasas() async {
    final List<Map<String, dynamic>> raw = await _dataSource.loadList(_file);
    return raw.map(Tasa.fromJson).toList();
  }

  Future<Tasa> createTasa({
    required String fecha,
    required double tasaDiaria,
  }) async {
    final List<Map<String, dynamic>> tasas = await _dataSource.loadList(_file);
    final int nextId =
        tasas.fold<int>(0, (int acc, Map<String, dynamic> item) {
          final int currentId = item['id'] as int? ?? 0;
          return currentId > acc ? currentId : acc;
        }) +
        1;

    final Map<String, dynamic> created = <String, dynamic>{
      'id': nextId,
      'fecha': fecha,
      'tasaDiaria': tasaDiaria,
    };

    tasas.insert(0, created);
    return Tasa.fromJson(created);
  }

  Future<Tasa> updateTasa({
    required int id,
    String? fecha,
    double? tasaDiaria,
  }) async {
    final List<Map<String, dynamic>> tasas = await _dataSource.loadList(_file);
    final int index = tasas.indexWhere(
      (Map<String, dynamic> item) => item['id'] == id,
    );
    if (index == -1) {
      throw AppException('Tasa no encontrada');
    }

    final Map<String, dynamic> updated = Map<String, dynamic>.from(
      tasas[index],
    );
    if (fecha != null) updated['fecha'] = fecha;
    if (tasaDiaria != null) updated['tasaDiaria'] = tasaDiaria;

    tasas[index] = updated;
    return Tasa.fromJson(updated);
  }

  Future<void> deleteTasa(int id) async {
    final List<Map<String, dynamic>> tasas = await _dataSource.loadList(_file);
    tasas.removeWhere((Map<String, dynamic> item) => item['id'] == id);
  }
}
