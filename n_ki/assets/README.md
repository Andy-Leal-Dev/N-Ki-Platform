Estos archivos JSON son datos mock para usar en simulación o en desarrollo local.

Archivos:
- `clients.json` — lista de clientes con campos: `id`, `cedula`, `nombre`, `telefono`, `direccion`, `email`, `registradoEn`.
- `prestamos.json` — lista de préstamos con campos: `id`, `clienteId`, `montoSolicitado`, `tasaInteresAnual`, `plazoMeses`, `montoCuota`, `fechaInicio`, `estado`, `totalPagado`, `saldo`, `proxVencimiento`.
- `ganancias.json` — resumen de ganancias mensuales y por préstamo.
- `historial.json` — historial de pagos con campos: `id`, `prestamoId`, `clienteId`, `fechaPago`, `monto`, `tipo`, `estadoPago`, `diasRetraso`, `nota`.

Uso sugerido:
- Copia los archivos a `assets/` o carga con `rootBundle.loadString('assets/mock_data/clients.json')`.
- Si usas `MockApiClient`, puedes modificarlo para leer estos archivos y devolver los datos en lugar de hardcodear respuestas.

¿Quieres que integre estos JSON al `MockApiClient` para que los devuelva automáticamente?