const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const { config } = require('../config');

const signAccessToken = (payload, options = {}) => {
  return jwt.sign(payload, config.jwt.secret, {
    expiresIn: config.jwt.expiresIn,
    issuer: config.jwt.issuer,
    ...options
  });
};

const signRefreshToken = (payload, options = {}) => {
  return jwt.sign(payload, config.jwt.refreshSecret, {
    expiresIn: config.jwt.refreshExpiresIn,
    issuer: config.jwt.issuer,
    ...options
  });
};

const verifyAccessToken = (token) => jwt.verify(token, config.jwt.secret, { issuer: config.jwt.issuer });
const verifyRefreshToken = (token) => jwt.verify(token, config.jwt.refreshSecret, { issuer: config.jwt.issuer });

const generateRandomToken = (size = 48) => crypto.randomBytes(size).toString('hex');

const hashToken = (token) => crypto.createHash('sha256').update(token).digest('hex');

module.exports = {
  signAccessToken,
  signRefreshToken,
  verifyAccessToken,
  verifyRefreshToken,
  generateRandomToken,
  hashToken
};
