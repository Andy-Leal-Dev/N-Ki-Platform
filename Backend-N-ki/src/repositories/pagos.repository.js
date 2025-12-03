const { prisma } = require('../prismaClient');

const createPago = (data) => prisma.pago.create({ data });

const listPagosByCuota = (cuotaId) => prisma.pago.findMany({ where: { cuotaId, deletedAt: null }, orderBy: { fecha: 'asc' } });

module.exports = {
  createPago,
  listPagosByCuota
};
