const { prisma } = require('../prismaClient');

const createRefreshToken = ({ usuarioId, tokenHash, expiresAt, userAgent, ipAddress }) =>
  prisma.refreshToken.create({
    data: {
      usuarioId,
      tokenHash,
      expiresAt,
      userAgent,
      ipAddress
    }
  });

const findValidRefreshToken = (tokenHash) =>
  prisma.refreshToken.findFirst({
    where: {
      tokenHash,
      revokedAt: null,
      expiresAt: { gt: new Date() }
    }
  });

const revokeToken = (id) => prisma.refreshToken.update({ where: { id }, data: { revokedAt: new Date() } });

const revokeAllForUser = (usuarioId) => prisma.refreshToken.updateMany({
  where: { usuarioId, revokedAt: null },
  data: { revokedAt: new Date() }
});

module.exports = {
  createRefreshToken,
  findValidRefreshToken,
  revokeToken,
  revokeAllForUser
};
