const express = require('express');
const authRoutes = require('./auth.routes');
const clientesRoutes = require('./clientes.routes');
const tasasRoutes = require('./tasas.routes');
const prestamosRoutes = require('./prestamos.routes');
const pagosRoutes = require('./pagos.routes');
const resumenRoutes = require('./resumen.routes');

const router = express.Router();

router.use('/auth', authRoutes);
router.use('/clientes', clientesRoutes);
router.use('/tasas', tasasRoutes);
router.use('/prestamos', prestamosRoutes);
router.use('/', pagosRoutes);
router.use('/resumen', resumenRoutes);

module.exports = router;
