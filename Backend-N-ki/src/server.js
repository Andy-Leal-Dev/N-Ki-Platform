require('./config');

const http = require('http');
const app = require('./app');
const { config } = require('./config');
const { logger } = require('./utils/logger');

const server = http.createServer(app);

server.listen(config.app.port, () => {
  logger.info(`N-Ki API running on port ${config.app.port} (${config.app.env})`);
});

const shutdown = (signal) => {
  logger.warn(`Received ${signal}, shutting down gracefully`);
  server.close(() => {
    logger.info('HTTP server closed');
    process.exit(0);
  });
};

process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT', () => shutdown('SIGINT'));

process.on('unhandledRejection', (reason) => {
  logger.error('Unhandled Rejection', { reason });
  shutdown('unhandledRejection');
});

process.on('uncaughtException', (error) => {
  logger.error('Uncaught Exception', { error });
  shutdown('uncaughtException');
});
