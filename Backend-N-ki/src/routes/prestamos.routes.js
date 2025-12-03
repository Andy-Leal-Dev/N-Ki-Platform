const express = require('express');
const controller = require('../controllers/prestamos.controller');
const { authenticate } = require('../middlewares/auth');
const { validate } = require('../middlewares/validate');
const { asyncHandler } = require('../utils/asyncHandler');
const { createPrestamoSchema, updatePrestamoSchema, getPrestamoSchema } = require('../validators/prestamos.validator');

const router = express.Router();

router.use(authenticate);
router.get('/', asyncHandler(controller.listPrestamos));
router.post('/', validate(createPrestamoSchema), asyncHandler(controller.createPrestamo));
router.get('/:id', validate(getPrestamoSchema), asyncHandler(controller.getPrestamo));
router.put('/:id', validate(updatePrestamoSchema), asyncHandler(controller.updatePrestamo));
router.delete('/:id', validate(getPrestamoSchema), asyncHandler(controller.deletePrestamo));
router.get('/:id/cuotas', validate(getPrestamoSchema), asyncHandler(controller.listCuotas));

module.exports = router;
