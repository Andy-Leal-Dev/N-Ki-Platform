const tasasRepository = require('../repositories/tasas.repository');

const listTasas = () => tasasRepository.listTasas();

const getTasa = async (id) => {
  const tasa = await tasasRepository.findTasaById(id);
  if (!tasa) {
    const error = new Error('Tasa no encontrada');
    error.status = 404;
    throw error;
  }
  return tasa;
};

const createTasa = (data) => tasasRepository.createTasa(data);

const updateTasa = async (id, data) => {
  await getTasa(id);
  return tasasRepository.updateTasa(id, data);
};

const deleteTasa = async (id) => {
  await getTasa(id);
  await tasasRepository.softDeleteTasa(id);
};

module.exports = {
  listTasas,
  getTasa,
  createTasa,
  updateTasa,
  deleteTasa
};
