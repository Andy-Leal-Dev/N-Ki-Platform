const { prisma } = require('../prismaClient');

const createManyCuotas = (cuotas) => prisma.cuota.createMany({ data: cuotas });

const listCuotasByPrestamo = (prestamoId) => prisma.cuota.findMany({
  where: { prestamoId, deletedAt: null },
  orderBy: { numeroCuota: 'asc' },
  include: { pagos: { where: { deletedAt: null } } }
});

const findCuotaById = (id) => prisma.cuota.findFirst({ where: { id, deletedAt: null } });

const updateCuota = (id, data) => prisma.cuota.update({ where: { id }, data });

module.exports = {
  createManyCuotas,
  listCuotasByPrestamo,
  findCuotaById,
  updateCuota
};
