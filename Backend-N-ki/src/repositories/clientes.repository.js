const { prisma } = require('../prismaClient');

const listClientes = (usuarioId) => prisma.cliente.findMany({
  where: { usuarioId, deletedAt: null },
  orderBy: { createdAt: 'desc' }
});

const findClienteById = (usuarioId, id) => prisma.cliente.findFirst({ where: { id, usuarioId, deletedAt: null } });

const createCliente = (usuarioId, data) => prisma.cliente.create({
  data: {
    usuarioId,
    cedula: data.cedula,
    nombre: data.nombre,
    telefono: data.telefono,
    direccion: data.direccion,
    tipo: data.tipo ?? 'Nuevo'
  }
});

const updateCliente = (id, data) => prisma.cliente.update({
  where: { id },
  data: {
    cedula: data.cedula,
    nombre: data.nombre,
    telefono: data.telefono,
    direccion: data.direccion,
    tipo: data.tipo
  }
});

const softDeleteCliente = (id) => prisma.cliente.update({ where: { id }, data: { deletedAt: new Date() } });

module.exports = {
  listClientes,
  findClienteById,
  createCliente,
  updateCliente,
  softDeleteCliente
};
