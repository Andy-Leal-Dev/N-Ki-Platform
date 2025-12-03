const express = require('express');
const controller = require('../controllers/tasas.controller');
const { authenticate } = require('../middlewares/auth');
const { validate } = require('../middlewares/validate');
const { asyncHandler } = require('../utils/asyncHandler');
const { createTasaSchema, updateTasaSchema, getTasaSchema } = require('../validators/tasas.validator');

const router = express.Router();

router.use(authenticate);
router.get('/', asyncHandler(controller.listTasas));
router.post('/', validate(createTasaSchema), asyncHandler(controller.createTasa));
router.get('/:id', validate(getTasaSchema), asyncHandler(controller.getTasa));
router.put('/:id', validate(updateTasaSchema), asyncHandler(controller.updateTasa));
router.delete('/:id', validate(getTasaSchema), asyncHandler(controller.deleteTasa));

module.exports = router;
