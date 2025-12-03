const path = require('path');
const dotenv = require('dotenv');

const envFile = process.env.NODE_ENV === 'test' ? '.env.test' : '.env';
dotenv.config({ path: path.resolve(process.cwd(), envFile) });

const requiredEnvVars = ['JWT_SECRET', 'JWT_EXPIRES_IN', 'REFRESH_TOKEN_SECRET', 'REFRESH_TOKEN_EXPIRES_IN'];

requiredEnvVars.forEach((key) => {
  if (!process.env[key]) {
    throw new Error(`Missing required environment variable: ${key}`);
  }
});

const config = {
  app: {
    port: parseInt(process.env.PORT ?? '4000', 10),
    env: process.env.NODE_ENV ?? 'development',
    frontendBaseUrl: process.env.FRONTEND_BASE_URL ?? '*'
  },
  jwt: {
    secret: process.env.JWT_SECRET,
    expiresIn: process.env.JWT_EXPIRES_IN,
    issuer: process.env.JWT_ISSUER ?? 'n-ki.api',
    refreshSecret: process.env.REFRESH_TOKEN_SECRET,
    refreshExpiresIn: process.env.REFRESH_TOKEN_EXPIRES_IN
  },
  mail: {
    host: process.env.SMTP_HOST,
    port: parseInt(process.env.SMTP_PORT ?? '587', 10),
    secure: process.env.SMTP_SECURE === 'true',
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASS,
    from: process.env.MAIL_FROM ?? 'N-Ki <no-reply@n-ki.com>'
  },
  google: {
    clientId: process.env.GOOGLE_CLIENT_ID,
    clientSecret: process.env.GOOGLE_CLIENT_SECRET,
    redirectUri: process.env.GOOGLE_REDIRECT_URI
  },
  links: {
    frontendBaseUrl: process.env.FRONTEND_BASE_URL,
    passwordResetUrl: process.env.PASSWORD_RESET_URL
  }
};

module.exports = { config };
