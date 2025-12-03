const express = require('express');
const controller = require('../controllers/resumen.controller');
const { authenticate } = require('../middlewares/auth');
const { validate } = require('../middlewares/validate');
const { asyncHandler } = require('../utils/asyncHandler');
const { resumenQuerySchema } = require('../validators/resumen.validator');

const router = express.Router();

router.use(authenticate);
router.get('/', validate(resumenQuerySchema), asyncHandler(controller.getResumen));

module.exports = router;
