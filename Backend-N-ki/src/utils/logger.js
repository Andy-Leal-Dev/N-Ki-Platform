const { createLogger, format, transports } = require('winston');

const logger = createLogger({
  level: process.env.NODE_ENV === 'production' ? 'info' : 'debug',
  format: format.combine(
    format.timestamp(),
    format.errors({ stack: true }),
    format.splat(),
    format.json()
  ),
  defaultMeta: { service: 'n-ki-api' },
  transports: [
    new transports.Console({
      format: format.combine(
        format.colorize(),
        format.printf(({ level, message, timestamp, stack, ...metadata }) => {
          if (stack) {
            return `${timestamp} [${level}] ${message}\n${stack}`;
          }
          const rest = Object.keys(metadata).length ? ` ${JSON.stringify(metadata)}` : '';
          return `${timestamp} [${level}] ${message}${rest}`;
        })
      )
    })
  ]
});

logger.http = (message, meta) => logger.log('http', message, meta);

module.exports = { logger };
