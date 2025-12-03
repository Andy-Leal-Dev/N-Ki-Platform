import '../data_sources/static_data_source.dart';
import '../models/resumen.dart';

class ResumenRepository {
  ResumenRepository(this._dataSource);

  final StaticDataSource _dataSource;

  Future<List<ResumenFinanciero>> listResumenes({
    String? fechaInicio,
    String? fechaFin,
  }) async {
    final List<Map<String, dynamic>> prestamos = await _dataSource.loadList(
      'prestamos.json',
    );
    final List<Map<String, dynamic>> clientes = await _dataSource.loadList(
      'clients.json',
    );
    final Map<String, dynamic> ganancias = await _dataSource.loadMap(
      'ganancias.json',
    );

    final double capitalPrestado = prestamos
        .where(
          (Map<String, dynamic> p) =>
              (p['estado'] as String?)?.toLowerCase() == 'activo',
        )
        .fold<double>(
          0,
          (double acc, Map<String, dynamic> p) =>
              acc + ((p['montoCapital'] as num?)?.toDouble() ?? 0),
        );

    double gananciasTotales = 0;
    final List<dynamic>? resumenMensual =
        ganancias['resumenMensual'] as List<dynamic>?;
    if (resumenMensual != null && resumenMensual.isNotEmpty) {
      final Map<String, dynamic> last =
          resumenMensual.last as Map<String, dynamic>;
      gananciasTotales = (last['gananciaTotal'] as num?)?.toDouble() ?? 0;
    }

    final ResumenFinanciero resumen = ResumenFinanciero(
      fecha: DateTime.now(),
      capitalPrestado: capitalPrestado,
      gananciasTotales: gananciasTotales,
      dineroCalle: capitalPrestado,
      totalClientes: clientes.length,
      totalPrestamosActivos: prestamos
          .where(
            (Map<String, dynamic> p) =>
                (p['estado'] as String?)?.toLowerCase() == 'activo',
          )
          .length,
    );

    return <ResumenFinanciero>[resumen];
  }
}
