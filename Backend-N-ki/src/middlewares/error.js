const { logger } = require('../utils/logger');

const notFoundHandler = (req, res, next) => {
  const error = new Error(`Route ${req.originalUrl} not found`);
  error.status = 404;
  next(error);
};

// eslint-disable-next-line no-unused-vars
const errorHandler = (error, req, res, _next) => {
  const statusCode = error.status ?? 500;
  if (statusCode >= 500) {
    logger.error('Unexpected error: %s', error.message, { stack: error.stack });
  } else {
    logger.warn('Handled error: %s', error.message, { statusCode });
  }

  res.status(statusCode).json({
    error: {
      message: error.message,
      details: error.details ?? undefined
    }
  });
};

module.exports = {
  notFoundHandler,
  errorHandler
};
