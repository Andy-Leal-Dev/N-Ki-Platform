const cuotasRepository = require('../repositories/cuotas.repository');
const prestamosService = require('./prestamos.service');

const listCuotas = async (usuarioId, prestamoId) => {
  await prestamosService.getPrestamo(usuarioId, prestamoId);
  return cuotasRepository.listCuotasByPrestamo(prestamoId);
};

const getCuota = async (usuarioId, prestamoId, cuotaId) => {
  await prestamosService.getPrestamo(usuarioId, prestamoId);
  const cuota = await cuotasRepository.findCuotaById(cuotaId);
  if (!cuota || cuota.prestamoId !== prestamoId) {
    const error = new Error('Cuota no encontrada');
    error.status = 404;
    throw error;
  }
  return cuota;
};

module.exports = {
  listCuotas,
  getCuota
};
