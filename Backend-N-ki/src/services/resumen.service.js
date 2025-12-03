const { listResumenes } = require('../repositories/resumen.repository');

const getResumen = async ({ fechaInicio, fechaFin }) => {
  const start = fechaInicio ? new Date(fechaInicio) : undefined;
  const end = fechaFin ? new Date(fechaFin) : undefined;
  return listResumenes(start, end);
};

module.exports = {
  getResumen
};
