const clientesService = require('../services/clientes.service');

const listClientes = async (req, res) => {
  const clientes = await clientesService.listClientes(req.user.id);
  res.json({ data: clientes });
};

const getCliente = async (req, res) => {
  const cliente = await clientesService.getCliente(req.user.id, Number(req.params.id));
  res.json({ data: cliente });
};

const createCliente = async (req, res) => {
  const cliente = await clientesService.createCliente(req.user.id, req.body);
  res.status(201).json({ data: cliente });
};

const updateCliente = async (req, res) => {
  const cliente = await clientesService.updateCliente(req.user.id, Number(req.params.id), req.body);
  res.json({ data: cliente });
};

const deleteCliente = async (req, res) => {
  await clientesService.deleteCliente(req.user.id, Number(req.params.id));
  res.status(204).send();
};

module.exports = {
  listClientes,
  getCliente,
  createCliente,
  updateCliente,
  deleteCliente
};
