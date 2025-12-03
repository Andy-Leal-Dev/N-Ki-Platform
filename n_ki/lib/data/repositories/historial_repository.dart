import '../data_sources/static_data_source.dart';
import '../models/historial_entry.dart';

class HistorialRepository {
  HistorialRepository(this._dataSource);

  final StaticDataSource _dataSource;
  static const String _file = 'historial.json';

  Future<List<HistorialEntry>> listHistorial() async {
    final List<Map<String, dynamic>> raw = await _dataSource.loadList(_file);
    final List<HistorialEntry> entries = raw
        .map(HistorialEntry.fromJson)
        .toList();
    entries.sort((a, b) => b.fechaMovimiento.compareTo(a.fechaMovimiento));
    return entries;
  }
}
