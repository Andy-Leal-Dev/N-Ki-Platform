const prestamosService = require('../services/prestamos.service');
const cuotasService = require('../services/cuotas.service');

const listPrestamos = async (req, res) => {
  const prestamos = await prestamosService.listPrestamos(req.user.id);
  res.json({ data: prestamos });
};

const getPrestamo = async (req, res) => {
  const prestamo = await prestamosService.getPrestamo(req.user.id, Number(req.params.id));
  res.json({ data: prestamo });
};

const createPrestamo = async (req, res) => {
  const prestamo = await prestamosService.createPrestamo(req.user.id, req.body);
  res.status(201).json({ data: prestamo });
};

const updatePrestamo = async (req, res) => {
  const prestamo = await prestamosService.updatePrestamo(req.user.id, Number(req.params.id), req.body);
  res.json({ data: prestamo });
};

const deletePrestamo = async (req, res) => {
  await prestamosService.deletePrestamo(req.user.id, Number(req.params.id));
  res.status(204).send();
};

const listCuotas = async (req, res) => {
  const cuotas = await cuotasService.listCuotas(req.user.id, Number(req.params.id));
  res.json({ data: cuotas });
};

module.exports = {
  listPrestamos,
  getPrestamo,
  createPrestamo,
  updatePrestamo,
  deletePrestamo,
  listCuotas
};
