const tasasService = require('../services/tasas.service');

const listTasas = async (req, res) => {
  const tasas = await tasasService.listTasas();
  res.json({ data: tasas });
};

const getTasa = async (req, res) => {
  const tasa = await tasasService.getTasa(Number(req.params.id));
  res.json({ data: tasa });
};

const createTasa = async (req, res) => {
  const tasa = await tasasService.createTasa(req.body);
  res.status(201).json({ data: tasa });
};

const updateTasa = async (req, res) => {
  const tasa = await tasasService.updateTasa(Number(req.params.id), req.body);
  res.json({ data: tasa });
};

const deleteTasa = async (req, res) => {
  await tasasService.deleteTasa(Number(req.params.id));
  res.status(204).send();
};

module.exports = {
  listTasas,
  getTasa,
  createTasa,
  updateTasa,
  deleteTasa
};
