const pagosService = require('../services/pagos.service');

const listPagos = async (req, res) => {
  const pagos = await pagosService.listPagos(req.user.id, Number(req.params.cuotaId));
  res.json({ data: pagos });
};

const createPago = async (req, res) => {
  const pago = await pagosService.createPago(req.user.id, Number(req.params.cuotaId), req.body);
  res.status(201).json({ data: pago });
};

module.exports = {
  listPagos,
  createPago
};
