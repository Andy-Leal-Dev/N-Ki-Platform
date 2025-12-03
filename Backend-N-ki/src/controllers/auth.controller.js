const authService = require('../services/auth.service');

const register = async (req, res) => {
  const { user, tokens } = await authService.register(req.body);
  res.status(201).json({ user, tokens });
};

const login = async (req, res) => {
  const context = { userAgent: req.get('user-agent'), ipAddress: req.ip };
  const { user, tokens } = await authService.login(req.body, context);
  res.json({ user, tokens });
};

const googleSignIn = async (req, res) => {
  const context = { userAgent: req.get('user-agent'), ipAddress: req.ip };
  const { user, tokens } = await authService.googleSignIn(req.body, context);
  res.json({ user, tokens });
};

const refresh = async (req, res) => {
  const { user, tokens } = await authService.refreshSession(req.body);
  res.json({ user, tokens });
};

const logout = async (req, res) => {
  await authService.logout(req.body);
  res.status(204).send();
};

const forgotPassword = async (req, res) => {
  await authService.requestPasswordReset(req.body);
  res.status(202).json({ message: 'Si el correo existe, enviaremos un código.' });
};

const verifyResetCode = async (req, res) => {
  const result = await authService.verifyResetCode(req.body);
  res.json(result);
};

const resetPassword = async (req, res) => {
  await authService.resetPassword(req.body);
  res.status(204).send();
};

module.exports = {
  register,
  login,
  googleSignIn,
  refresh,
  logout,
  forgotPassword,
  verifyResetCode,
  resetPassword
};
