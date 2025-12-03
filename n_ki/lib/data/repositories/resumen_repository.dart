import '../../core/error/app_exception.dart';
import '../../core/network/api_client.dart';
import '../models/resumen.dart';

class ResumenRepository {
  ResumenRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<ResumenFinanciero>> listResumenes({
    String? fechaInicio,
    String? fechaFin,
  }) async {
    final Map<String, dynamic> data = await _getData(
      '/resumen',
      queryParameters: <String, dynamic>{
        if (fechaInicio != null) 'fechaInicio': fechaInicio,
        if (fechaFin != null) 'fechaFin': fechaFin,
      },
    );
    final List<dynamic> items = data['data'] as List<dynamic>? ?? <dynamic>[];
    return items
        .map(
          (dynamic item) =>
              ResumenFinanciero.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  Future<Map<String, dynamic>> _getData(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _apiClient.get(
      path,
      queryParameters: queryParameters,
    );
    return _asMap(response.data);
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    throw AppException('Respuesta inesperada del servidor');
  }
}
