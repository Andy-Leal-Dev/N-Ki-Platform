const { prisma } = require('../prismaClient');

const findByEmail = (correo) => prisma.usuario.findUnique({ where: { correo } });

const findById = (id) => prisma.usuario.findUnique({ where: { id } });

const findByGoogleId = (googleId) => prisma.usuario.findUnique({ where: { googleId } });

const createUser = ({ nombre, apellido, correo, password, googleId, fechaNacimiento }) =>
  prisma.usuario.create({
    data: {
      nombre,
      apellido,
      correo,
      password,
      googleId,
      fechaNacimiento: fechaNacimiento ? new Date(fechaNacimiento) : undefined
    }
  });

const updatePassword = (id, password) => prisma.usuario.update({ where: { id }, data: { password } });

const linkGoogleAccount = (id, googleId) => prisma.usuario.update({ where: { id }, data: { googleId } });

module.exports = {
  findByEmail,
  findById,
  findByGoogleId,
  createUser,
  updatePassword,
  linkGoogleAccount
};
