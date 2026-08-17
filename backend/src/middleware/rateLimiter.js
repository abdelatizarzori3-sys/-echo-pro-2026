/**
 * Rate Limiting Middleware
 * Prevents abuse and protects AI API costs
 */

const rateLimit = require('express-rate-limit');
const env = require('../config/env');

const apiLimiter = rateLimit({
  windowMs: env.RATE_LIMIT_WINDOW_MS,
  max: env.RATE_LIMIT_MAX,
  message: {
    error: 'Too many requests',
    retryAfter: 'Please try again later'
  },
  standardHeaders: true,
  legacyHeaders: false,
});

const chatLimiter = rateLimit({
  windowMs: 60000, // 1 minute
  max: 30, // 30 messages per minute per IP
  message: {
    error: 'Chat rate limit exceeded',
    retryAfter: 'Please slow down'
  }
});

module.exports = { apiLimiter, chatLimiter };
