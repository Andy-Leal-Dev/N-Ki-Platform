# N-Ki Backend

API REST construida con Node.js y Express para gestionar clientes, préstamos, cuotas y pagos de la aplicación N-Ki.

## Requisitos

- Node.js >= 18
- npm

## Configuración inicial

1. Instala las dependencias:

   ```bash
   npm install
   ```

2. Crea un archivo `.env` basado en `.env.example` y actualiza los valores (secretos JWT, credenciales SMTP, Google OAuth, etc.).

3. Genera el cliente de Prisma e inicializa la base de datos SQLite:

   ```bash
   npx prisma migrate dev --name init
   ```

## Scripts disponibles

- `npm run dev`: inicia el servidor con `nodemon` en modo desarrollo.
- `npm run start`: inicia el servidor en modo producción.
- `npm run prisma:migrate`: ejecuta migraciones de Prisma (alias de `prisma migrate dev`).
- `npm run prisma:generate`: regenera el cliente de Prisma.
- `npm run lint`: ejecuta ESLint sobre la carpeta `src`.

## Estructura principal

- `src/app.js`: configuración de Express (middlewares, rutas, seguridad).
- `src/server.js`: arranque del servidor HTTP.
- `src/routes/`: definición de rutas agrupadas por dominio.
- `src/controllers/`: entrada HTTP que orquesta servicios.
- `src/services/`: lógica de negocio.
- `src/repositories/`: acceso a datos vía Prisma.
- `src/utils/`: utilidades (JWT, correo, Google, logger, etc.).
- `prisma/schema.prisma`: modelado de tablas sobre SQLite.

## Seguridad

- JWT para autenticación (access y refresh tokens).
- Rate limiting en rutas de autenticación.
- Helmet, CORS, compresión y logging estructurado.
- Hash de contraseñas con bcrypt.
- Tokens de refresco hashados y revocables.

## Autenticación

- Registro y login con correo/contraseña.
- Restablecimiento de contraseña mediante código y token temporal (envío por correo con Nodemailer).
- Inicio de sesión con Google `id_token`.

## Base de datos

Prisma usa SQLite (`DATABASE_URL` apunta a `./database/dev.sqlite`). Puedes cambiar la ruta en el `.env` sin modificar el código.

## Migraciones y modelos

Los modelos replican las tablas provistas (usuarios, clientes, tasas, préstamos, cuotas, pagos, resumen financiero) y añaden tablas auxiliares para restablecimiento de contraseña y tokens de refresco.

## Endpoints principales

Todos prefijados por `/api/v1`:

- `POST /auth/register`, `POST /auth/login`, `POST /auth/google`, `POST /auth/refresh`, `POST /auth/logout`
- `POST /auth/forgot-password`, `POST /auth/verify-reset-code`, `POST /auth/reset-password`
- CRUD de clientes `/clientes`
- CRUD de tasas `/tasas`
- CRUD de préstamos `/prestamos` y cuotas `/prestamos/:id/cuotas`
- Pagos `/cuotas/:cuotaId/pagos`
- Resumen financiero `/resumen`

## Desarrollo

Inicia el servidor en modo desarrollo:

```bash
npm run dev
```

Se expone `GET /health` para revisar el estado del servicio.

---

Cualquier ajuste adicional (por ejemplo, Docker Compose, pruebas automatizadas o cálculos avanzados de amortización) se puede añadir sobre esta base.
