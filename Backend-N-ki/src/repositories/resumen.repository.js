const { prisma } = require('../prismaClient');

const listResumenes = (fechaInicio, fechaFin) => prisma.resumenFinanciero.findMany({
  where: {
    deletedAt: null,
    fecha: {
      gte: fechaInicio ?? undefined,
      lte: fechaFin ?? undefined
    }
  },
  orderBy: { fecha: 'desc' }
});

module.exports = {
  listResumenes
};
