/**
 * Global Error Handler Middleware
 */

const logger = require('../config/logger');

const errorHandler = (err, req, res, next) => {
  logger.error('Unhandled Error:', {
    message: err.message,
    stack: err.stack,
    path: req.path,
    method: req.method,
  });

  // Prisma validation error
  if (err.code === 'P2002') {
    return res.status(409).json({ error: 'Unique constraint failed' });
  }

  // JWT error
  if (err.name === 'JsonWebTokenError') {
    return res.status(403).json({ error: 'Invalid token' });
  }

  // Default error
  res.status(err.status || 500).json({
    error: err.message || 'Internal Server Error',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack }),
  });
};

module.exports = errorHandler;
