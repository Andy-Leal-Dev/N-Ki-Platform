import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'base_api_client.dart';

class MockResponse {
  final dynamic data;
  MockResponse(this.data);
}

/// Simple mock API client that mimics the minimal interface used by the app
/// repositories. It returns static responses for common endpoints.
class MockApiClient implements BaseApiClient {
  MockApiClient();

  Future<dynamic> _loadJson(String filename) async {
    try {
      final String raw = await rootBundle.loadString(
        'assets/mock_data/$filename',
      );
      return json.decode(raw);
    } catch (_) {
      return null;
    }
  }

  Future<MockResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));

    if (path == '/clientes') {
      final data = await _loadJson('clients.json');
      return MockResponse({'data': data ?? <dynamic>[]});
    }

    if (path == '/prestamos') {
      final data = await _loadJson('prestamos.json');
      return MockResponse({'data': data ?? <dynamic>[]});
    }

    // Return single prestamo when requesting /prestamos/{id}
    if (path.startsWith('/prestamos/')) {
      final parts = path.split('/');
      if (parts.length == 3) {
        final id = int.tryParse(parts[2]);
        if (id != null) {
          final prestamos =
              await _loadJson('prestamos.json') as List<dynamic>? ??
              <dynamic>[];
          final match = prestamos.cast<Map<String, dynamic>?>().firstWhere(
            (p) => p != null && (p['id'] as int) == id,
            orElse: () => null,
          );
          if (match != null) {
            return MockResponse({'data': match});
          }
        }
      }
    }
    // /prestamos/{id}/cuotas -> return empty list by default
    if (path.contains('/prestamos/') && path.endsWith('/cuotas')) {
      return MockResponse({'data': <dynamic>[]});
    }

    if (path == '/ganancias') {
      final data = await _loadJson('ganancias.json');
      return MockResponse(data ?? <String, dynamic>{});
    }

    if (path == '/resumen') {
      final clientes =
          await _loadJson('clients.json') as List<dynamic>? ?? <dynamic>[];
      final prestamos =
          await _loadJson('prestamos.json') as List<dynamic>? ?? <dynamic>[];
      final gananciasMap =
          await _loadJson('ganancias.json') as Map<String, dynamic>?;

      final double capitalPrestado = prestamos
          .where((p) => (p is Map<String, dynamic> && p['estado'] == 'activo'))
          .fold<double>(0.0, (acc, p) {
            final num? monto =
                (p as Map<String, dynamic>)['montoCapital'] as num?;
            return acc + (monto?.toDouble() ?? 0.0);
          });

      double gananciasTotales = 0.0;
      if (gananciasMap != null && gananciasMap['resumenMensual'] is List) {
        final resum = gananciasMap['resumenMensual'] as List<dynamic>;
        if (resum.isNotEmpty) {
          final last = resum.last as Map<String, dynamic>;
          gananciasTotales = (last['gananciaTotal'] as num?)?.toDouble() ?? 0.0;
        }
      }

      final int totalClientes = clientes.length;
      final int totalPrestamosActivos = prestamos
          .where((p) => (p is Map<String, dynamic> && p['estado'] == 'activo'))
          .length;

      final summary = {
        'fecha': DateTime.now().toIso8601String(),
        'capitalPrestado': capitalPrestado,
        'gananciasTotales': gananciasTotales,
        'dineroCalle': capitalPrestado,
        'totalClientes': totalClientes,
        'totalPrestamosActivos': totalPrestamosActivos,
      };

      return MockResponse({
        'data': <dynamic>[summary],
      });
    }

    if (path == '/historial') {
      final data = await _loadJson('historial.json');
      return MockResponse({'data': data ?? <dynamic>[]});
    }
    // Return single cliente when requesting /clientes/{id}
    if (path.startsWith('/clientes/')) {
      final parts = path.split('/');
      if (parts.length == 3) {
        final id = int.tryParse(parts[2]);
        if (id != null) {
          final clientes =
              await _loadJson('clients.json') as List<dynamic>? ?? <dynamic>[];
          final match = clientes.cast<Map<String, dynamic>?>().firstWhere(
            (c) => c != null && (c['id'] as int) == id,
            orElse: () => null,
          );
          if (match != null) {
            return MockResponse({'data': match});
          }
        }
      }
    }

    if (path == '/agenda') {
      // Build a simple agenda from prestamos.json: next unpaid cuotas
      final prestamos = await _loadJson('prestamos.json') as List<dynamic>?;
      if (prestamos == null) {
        return MockResponse({'data': <dynamic>[]});
      }
      final clientes =
          await _loadJson('clients.json') as List<dynamic>? ?? <dynamic>[];
      final List<dynamic> agenda = <dynamic>[];
      for (final p in prestamos) {
        if (p is Map<String, dynamic> && p['estado'] == 'activo') {
          final Map<String, dynamic>? clienteMatch = clientes
              .cast<Map<String, dynamic>?>()
              .firstWhere(
                (c) => c != null && (c['id'] as int) == p['clienteId'],
                orElse: () => null,
              );
          final double cuota =
              (p['montoCuota'] as num?)?.toDouble() ??
              ((p['montoCapital'] as num?)?.toDouble() ?? 0) *
                  ((p['tasaInteres'] as num?)?.toDouble() ?? 0) /
                  100 /
                  ((p['numeroCuotas'] as num?)?.toDouble() ?? 12);
          agenda.add({
            'id': (p['id'] as int) * 1000 + 1,
            'prestamoId': p['id'],
            'clienteId': p['clienteId'],
            'clienteNombre': clienteMatch != null
                ? (clienteMatch['nombre'] as String? ??
                      'Cliente ${p['clienteId']}')
                : 'Cliente ${p['clienteId']}',
            'numeroCuota': 1,
            'fechaVencimiento':
                p['proximoVencimiento'] ?? DateTime.now().toIso8601String(),
            'montoTotalCuota': cuota,
            'estaPagada': false,
            'diasRetraso': 0,
          });
        }
      }
      return MockResponse({'data': agenda});
    }

    if (path == '/tasas') {
      // Simple tasas mock
      final tasas = <Map<String, dynamic>>[
        {
          'id': 1,
          'fecha': DateTime.now().toIso8601String(),
          'tasaDiaria': 0.75,
        },
        {
          'id': 2,
          'fecha': DateTime.now()
              .subtract(const Duration(days: 30))
              .toIso8601String(),
          'tasaDiaria': 0.72,
        },
      ];
      return MockResponse({'data': tasas});
    }

    return MockResponse({'data': <dynamic>[]});
  }

  Future<MockResponse> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    if (path == '/clientes') {
      final Map<String, dynamic> body =
          data as Map<String, dynamic>? ?? <String, dynamic>{};
      final clients =
          await _loadJson('clients.json') as List<dynamic>? ?? <dynamic>[];
      final int nextId =
          (clients.isNotEmpty
              ? (clients
                    .map((e) => (e['id'] as int))
                    .reduce((a, b) => a > b ? a : b))
              : 0) +
          1;
      final created = <String, dynamic>{
        'id': nextId,
        'cedula': body['cedula'] ?? 'V-00000000',
        'nombre': body['nombre'] ?? 'Cliente Mock',
        'telefono': body['telefono'],
        'direccion': body['direccion'],
      };
      // Note: not persisting to disk; just return created
      return MockResponse({'data': created});
    }

    // For other posts, echo the payload
    return MockResponse({'data': data});
  }

  Future<MockResponse> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    // Echo back the updated object (not persisted)
    return MockResponse({'data': data});
  }

  Future<MockResponse> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    // Return success-like response
    return MockResponse({'data': null});
  }
}
