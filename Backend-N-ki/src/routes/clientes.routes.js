const express = require('express');
const controller = require('../controllers/clientes.controller');
const { authenticate } = require('../middlewares/auth');
const { validate } = require('../middlewares/validate');
const { asyncHandler } = require('../utils/asyncHandler');
const { createClienteSchema, updateClienteSchema, getClienteSchema } = require('../validators/clientes.validator');

const router = express.Router();

router.use(authenticate);
router.get('/', asyncHandler(controller.listClientes));
router.post('/', validate(createClienteSchema), asyncHandler(controller.createCliente));
router.get('/:id', validate(getClienteSchema), asyncHandler(controller.getCliente));
router.put('/:id', validate(updateClienteSchema), asyncHandler(controller.updateCliente));
router.delete('/:id', validate(getClienteSchema), asyncHandler(controller.deleteCliente));

module.exports = router;
