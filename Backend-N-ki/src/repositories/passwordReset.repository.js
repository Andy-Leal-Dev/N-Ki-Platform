const { prisma } = require('../prismaClient');

const createResetRequest = (usuarioId, codeHash, expiresAt) =>
  prisma.passwordReset.create({
    data: {
      usuarioId,
      code: codeHash,
      expiresAt
    }
  });

const findActiveRequest = (usuarioId) =>
  prisma.passwordReset.findFirst({
    where: {
      usuarioId,
      usedAt: null,
      expiresAt: { gt: new Date() }
    },
    orderBy: { createdAt: 'desc' }
  });

const markAsUsed = (id) => prisma.passwordReset.update({ where: { id }, data: { usedAt: new Date() } });

module.exports = {
  createResetRequest,
  findActiveRequest,
  markAsUsed
};
