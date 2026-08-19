/**
 * Rate Limiting Middleware
 */

const rateLimit = require('express-rate-limit');
const RedisStore = require('rate-limit-redis');
const redis = require('redis');
const env = require('../config/env');

let redisClient;

if (env.REDIS_URL) {
  redisClient = redis.createClient({ url: env.REDIS_URL });
  redisClient.connect().catch(err => console.error('Redis error:', err));
}

const createLimiter = (windowMs, max, message = 'Too many requests') => {
  const options = {
    windowMs,
    max,
    message,
    standardHeaders: true,
    legacyHeaders: false,
  };

  if (redisClient) {
    return new rateLimit({
      ...options,
      store: new RedisStore({
        client: redisClient,
        prefix: 'rl:',
      }),
    });
  }

  return new rateLimit(options);
};

const apiLimiter = createLimiter(15 * 60 * 1000, 100);
const chatLimiter = createLimiter(60 * 1000, 20, 'Too many messages');
const authLimiter = createLimiter(15 * 60 * 1000, 5, 'Too many auth attempts');

module.exports = { apiLimiter, chatLimiter, authLimiter };
