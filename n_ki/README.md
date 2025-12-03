# n_ki

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Ejecutar en modo mock / modo backend

La app puede ejecutarse en dos modos:

- Modo mock (por defecto): la app usa datos estáticos y un cliente mock interno.
- Modo backend: la app se conecta al backend real usando la URL definida en `API_BASE_URL`.

Para forzar la conexión al backend, ejecuta Flutter con `--dart-define`:

```bash
flutter run --dart-define=USE_BACKEND=true --dart-define=API_BASE_URL=http://tu-backend:4000/api/v1
```

Si no pasas `USE_BACKEND=true`, la app usará datos estáticos (útil para probar funcionalidades como tomar fotos sin depender del backend).

### Ver la Agenda de préstamos (modo mock)

Puedes abrir la pantalla de agenda en la app para ver registros de cuotas próximos. Si ejecutas en modo mock (por defecto) la app permitirá el acceso sin iniciar sesión y mostrará datos de ejemplo.

Ruta: `/agenda`

Navega a la pantalla mediante `Navigator.pushNamed(context, '/agenda')` o usando la barra de rutas si la app la muestra.
