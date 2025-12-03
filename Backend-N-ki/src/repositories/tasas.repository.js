const { prisma } = require('../prismaClient');

const listTasas = () => prisma.tasa.findMany({ where: { deletedAt: null }, orderBy: { fecha: 'desc' } });

const findTasaById = (id) => prisma.tasa.findFirst({ where: { id, deletedAt: null } });

const createTasa = (data) => prisma.tasa.create({
  data: {
    fecha: new Date(data.fecha),
    tasaDiaria: data.tasaDiaria
  }
});

const updateTasa = (id, data) => prisma.tasa.update({
  where: { id },
  data: {
    fecha: data.fecha ? new Date(data.fecha) : undefined,
    tasaDiaria: data.tasaDiaria
  }
});

const softDeleteTasa = (id) => prisma.tasa.update({ where: { id }, data: { deletedAt: new Date() } });

module.exports = {
  listTasas,
  findTasaById,
  createTasa,
  updateTasa,
  softDeleteTasa
};
