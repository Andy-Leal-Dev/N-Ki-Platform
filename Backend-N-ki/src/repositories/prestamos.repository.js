const { prisma } = require('../prismaClient');

const listPrestamos = (usuarioId) => prisma.prestamo.findMany({
  where: { usuarioId, deletedAt: null },
  include: {
    cliente: true,
    tasa: true,
    cuotas: {
      where: { deletedAt: null },
      orderBy: { numeroCuota: 'asc' },
      include: { pagos: { where: { deletedAt: null } } }
    }
  },
  orderBy: { createdAt: 'desc' }
});

const findPrestamoById = (usuarioId, id) => prisma.prestamo.findFirst({
  where: { id, usuarioId, deletedAt: null },
  include: {
    cliente: true,
    tasa: true,
    cuotas: {
      where: { deletedAt: null },
      orderBy: { numeroCuota: 'asc' },
      include: { pagos: { where: { deletedAt: null } } }
    }
  }
});

const createPrestamo = (data) => prisma.prestamo.create({
  data,
  include: {
    cliente: true,
    tasa: true,
    cuotas: true
  }
});

const updatePrestamo = (id, data) => prisma.prestamo.update({ where: { id }, data });

const softDeletePrestamo = (id) => prisma.prestamo.update({ where: { id }, data: { deletedAt: new Date(), estado: 'Vencido' } });

module.exports = {
  listPrestamos,
  findPrestamoById,
  createPrestamo,
  updatePrestamo,
  softDeletePrestamo
};
