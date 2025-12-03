const jwt = require('jsonwebtoken');
const { config } = require('../config');
const userRepository = require('../repositories/user.repository');
const passwordResetRepository = require('../repositories/passwordReset.repository');
const refreshTokenRepository = require('../repositories/refreshToken.repository');
const { hashPassword, comparePassword, hashCode, compareCode } = require('../utils/password');
const { signAccessToken, signRefreshToken, verifyRefreshToken, hashToken, generateRandomToken } = require('../utils/jwt');
const { addDuration } = require('../utils/time');
const { sendPasswordResetCode, sendPasswordResetLink } = require('../utils/mailer');
const { verifyGoogleIdToken } = require('../utils/google');

const buildPublicUser = (user) => ({
  id: user.id,
  nombre: user.nombre,
  apellido: user.apellido,
  correo: user.correo,
  googleId: user.googleId ?? undefined
});

const issueTokens = async (user, context = {}) => {
  const accessToken = signAccessToken({ sub: user.id, email: user.correo });
  const refreshToken = signRefreshToken({ sub: user.id, email: user.correo });
  const decoded = jwt.decode(refreshToken);
  const expiresAt = decoded?.exp ? new Date(decoded.exp * 1000) : addDuration(config.jwt.refreshExpiresIn);

  await refreshTokenRepository.createRefreshToken({
    usuarioId: user.id,
    tokenHash: hashToken(refreshToken),
    expiresAt,
    userAgent: context.userAgent,
    ipAddress: context.ipAddress
  });

  return { accessToken, refreshToken };
};

const register = async ({ nombre, apellido, correo, password, fechaNacimiento }) => {
  const existing = await userRepository.findByEmail(correo);
  if (existing) {
    const error = new Error('El correo ya está registrado');
    error.status = 409;
    throw error;
  }

  const hashed = await hashPassword(password);
  const user = await userRepository.createUser({ nombre, apellido, correo, password: hashed, fechaNacimiento });
  const tokens = await issueTokens(user);
  return { user: buildPublicUser(user), tokens };
};

const login = async ({ correo, password }, context = {}) => {
  const user = await userRepository.findByEmail(correo);
  if (!user || user.deletedAt) {
    const error = new Error('Credenciales inválidas');
    error.status = 401;
    throw error;
  }
  const valid = await comparePassword(password, user.password);
  if (!valid) {
    const error = new Error('Credenciales inválidas');
    error.status = 401;
    throw error;
  }
  const tokens = await issueTokens(user, context);
  return { user: buildPublicUser(user), tokens };
};

const googleSignIn = async ({ idToken }, context = {}) => {
  const profile = await verifyGoogleIdToken(idToken);
  if (!profile.emailVerified) {
    const error = new Error('El correo de Google no está verificado');
    error.status = 400;
    throw error;
  }

  let user = await userRepository.findByGoogleId(profile.googleId);
  if (!user) {
    user = await userRepository.findByEmail(profile.email);
    if (user && !user.googleId) {
      await userRepository.linkGoogleAccount(user.id, profile.googleId);
      user = await userRepository.findById(user.id);
    }
  }

  if (!user) {
    const randomPassword = await hashPassword(generateRandomToken(16));
    user = await userRepository.createUser({
      nombre: profile.givenName ?? 'Usuario',
      apellido: profile.familyName ?? 'Google',
      correo: profile.email,
      password: randomPassword,
      googleId: profile.googleId
    });
  }

  const tokens = await issueTokens(user, context);
  return { user: buildPublicUser(user), tokens };
};

const refreshSession = async ({ refreshToken }) => {
  let payload;
  try {
    payload = verifyRefreshToken(refreshToken);
  } catch (error) {
    const err = new Error('Refresh token inválido');
    err.status = 401;
    throw err;
  }

  const tokenHash = hashToken(refreshToken);
  const stored = await refreshTokenRepository.findValidRefreshToken(tokenHash);
  if (!stored || stored.usuarioId !== payload.sub) {
    const err = new Error('Refresh token revocado o expirado');
    err.status = 401;
    throw err;
  }

  const user = await userRepository.findById(payload.sub);
  if (!user || user.deletedAt) {
    await refreshTokenRepository.revokeToken(stored.id);
    const err = new Error('Usuario no disponible');
    err.status = 401;
    throw err;
  }

  await refreshTokenRepository.revokeToken(stored.id);
  const tokens = await issueTokens(user);
  return { user: buildPublicUser(user), tokens };
};

const logout = async ({ refreshToken }) => {
  try {
    const tokenHash = hashToken(refreshToken);
    const stored = await refreshTokenRepository.findValidRefreshToken(tokenHash);
    if (stored) {
      await refreshTokenRepository.revokeToken(stored.id);
    }
  } catch (error) {
    // silencioso
  }
};

const requestPasswordReset = async ({ correo }) => {
  const user = await userRepository.findByEmail(correo);
  if (!user || user.deletedAt) {
    return;
  }

  const code = Math.floor(100000 + Math.random() * 900000).toString();
  const codeHash = await hashCode(code);
  const expiresAt = addDuration('10m');
  await passwordResetRepository.createResetRequest(user.id, codeHash, expiresAt);
  await sendPasswordResetCode({ to: user.correo, code, name: user.nombre });
};

const verifyResetCode = async ({ correo, code }) => {
  const user = await userRepository.findByEmail(correo);
  if (!user) {
    const error = new Error('Código inválido');
    error.status = 400;
    throw error;
  }

  const request = await passwordResetRepository.findActiveRequest(user.id);
  if (!request) {
    const error = new Error('Código inválido o expirado');
    error.status = 400;
    throw error;
  }

  const isValid = await compareCode(code, request.code);
  if (!isValid) {
    const error = new Error('Código inválido o expirado');
    error.status = 400;
    throw error;
  }

  const resetToken = signAccessToken({ sub: user.id, purpose: 'password-reset' }, { expiresIn: '10m' });
  await passwordResetRepository.markAsUsed(request.id);

  if (config.links.passwordResetUrl) {
    const link = `${config.links.passwordResetUrl}?token=${encodeURIComponent(resetToken)}&email=${encodeURIComponent(user.correo)}`;
    await sendPasswordResetLink({ to: user.correo, link, name: user.nombre });
  }

  return { resetToken };
};

const resetPassword = async ({ correo, resetToken, password }) => {
  let payload;
  try {
    payload = jwt.verify(resetToken, config.jwt.secret, { issuer: config.jwt.issuer });
  } catch (error) {
    const err = new Error('Token de restablecimiento inválido');
    err.status = 400;
    throw err;
  }

  if (payload.purpose !== 'password-reset') {
    const err = new Error('Token de restablecimiento inválido');
    err.status = 400;
    throw err;
  }

  const user = await userRepository.findByEmail(correo);
  if (!user || user.id !== payload.sub) {
    const err = new Error('Solicitud inválida');
    err.status = 400;
    throw err;
  }

  const hashed = await hashPassword(password);
  await userRepository.updatePassword(user.id, hashed);
  await refreshTokenRepository.revokeAllForUser(user.id);
};

module.exports = {
  register,
  login,
  googleSignIn,
  refreshSession,
  logout,
  requestPasswordReset,
  verifyResetCode,
  resetPassword
};
