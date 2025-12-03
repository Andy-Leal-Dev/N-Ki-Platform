const express = require('express');
const controller = require('../controllers/pagos.controller');
const { authenticate } = require('../middlewares/auth');
const { validate } = require('../middlewares/validate');
const { asyncHandler } = require('../utils/asyncHandler');
const { createPagoSchema } = require('../validators/pagos.validator');

const router = express.Router({ mergeParams: true });

router.use(authenticate);
router.get('/cuotas/:cuotaId/pagos', asyncHandler(controller.listPagos));
router.post('/cuotas/:cuotaId/pagos', validate(createPagoSchema), asyncHandler(controller.createPago));

module.exports = router;
