const clientesRepository = require('../repositories/clientes.repository');

const listClientes = async (usuarioId) => {
  return clientesRepository.listClientes(usuarioId);
};

const getCliente = async (usuarioId, id) => {
  const cliente = await clientesRepository.findClienteById(usuarioId, id);
  if (!cliente) {
    const error = new Error('Cliente no encontrado');
    error.status = 404;
    throw error;
  }
  return cliente;
};

const createCliente = async (usuarioId, data) => {
  return clientesRepository.createCliente(usuarioId, data);
};

const updateCliente = async (usuarioId, id, data) => {
  const cliente = await getCliente(usuarioId, id);
  return clientesRepository.updateCliente(cliente.id, data);
};

const deleteCliente = async (usuarioId, id) => {
  const cliente = await getCliente(usuarioId, id);
  await clientesRepository.softDeleteCliente(cliente.id);
};

module.exports = {
  listClientes,
  getCliente,
  createCliente,
  updateCliente,
  deleteCliente
};
