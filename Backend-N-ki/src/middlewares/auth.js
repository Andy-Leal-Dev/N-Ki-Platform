const { verifyAccessToken } = require('../utils/jwt');
const { prisma } = require('../prismaClient');

const authenticate = async (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: { message: 'Autenticación requerida' } });
  }

  const token = authHeader.split(' ')[1];
  try {
    const payload = verifyAccessToken(token);
    const user = await prisma.usuario.findUnique({ where: { id: payload.sub } });
    if (!user || user.deletedAt) {
      return res.status(401).json({ error: { message: 'Credenciales inválidas' } });
    }
    req.user = { id: user.id, email: user.correo, nombre: user.nombre, apellido: user.apellido };
    next();
  } catch (error) {
    return res.status(401).json({ error: { message: 'Token inválido o expirado' } });
  }
};

module.exports = { authenticate };
