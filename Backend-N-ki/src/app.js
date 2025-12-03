require('./config');

const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const morgan = require('morgan');
const routes = require('./routes');
const { notFoundHandler, errorHandler } = require('./middlewares/error');
const { logger } = require('./utils/logger');
const { config } = require('./config');

const app = express();

const allowedOrigins = config.app.frontendBaseUrl === '*' ? undefined : [config.app.frontendBaseUrl];
app.use(cors({ origin: allowedOrigins ?? true, credentials: true }));
app.use(helmet());
app.use(compression());
app.use(express.json({ limit: '1mb' }));
app.use(express.urlencoded({ extended: true }));
app.use(morgan('combined', {
  stream: {
    write: (message) => logger.http?.(message.trim()) ?? logger.info(message.trim())
  }
}));

app.get('/health', (req, res) => {
  res.json({ status: 'ok', uptime: process.uptime() });
});

app.use('/api/v1', routes);
app.use(notFoundHandler);
app.use(errorHandler);

module.exports = app;
