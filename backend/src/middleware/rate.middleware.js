const rateLimit = require('express-rate-limit');
const slowDown = require('express-slow-down');

const apiLimiter = rateLimit({
  windowMs: 60 * 1000,
  max: 60,
  message: { error: 'Too many requests. Please slow down.' },
});

const chatLimiter = rateLimit({
  windowMs: 60 * 1000,
  max: 20,
  message: { error: 'Chat rate limit exceeded. Max 20 msg/min.' },
});

const speedLimiter = slowDown({
  windowMs: 60 * 1000,
  delayAfter: 10,
  delayMs: () => 500,
});

module.exports = { apiLimiter, chatLimiter, speedLimiter };
