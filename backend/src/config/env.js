/**
 * Environment Configuration
 * Loads and validates all env variables
 */

const requiredEnvs = [
  'NODE_ENV',
  'PORT',
  'DATABASE_URL',
  'JWT_SECRET',
];

const optionalEnvs = {
  KIMI_API_KEY: '',
  KIMI_BASE_URL: 'https://api.moonshot.cn/v1',
  KIMI_MODEL: 'moonshot-v1-8k',
  CORS_ORIGIN: '*',
  LOG_LEVEL: 'info',
  REDIS_URL: '',
  SENTRY_DSN: '',
};

// Check required
requiredEnvs.forEach((key) => {
  if (!process.env[key]) {
    console.error(`❌ Missing required env: ${key}`);
    process.exit(1);
  }
});

module.exports = {
  NODE_ENV: process.env.NODE_ENV || 'development',
  PORT: process.env.PORT || 3000,
  DATABASE_URL: process.env.DATABASE_URL,
  JWT_SECRET: process.env.JWT_SECRET,
  KIMI_API_KEY: process.env.KIMI_API_KEY || '',
  KIMI_BASE_URL: process.env.KIMI_BASE_URL || optionalEnvs.KIMI_BASE_URL,
  KIMI_MODEL: process.env.KIMI_MODEL || optionalEnvs.KIMI_MODEL,
  CORS_ORIGIN: process.env.CORS_ORIGIN || optionalEnvs.CORS_ORIGIN,
  LOG_LEVEL: process.env.LOG_LEVEL || optionalEnvs.LOG_LEVEL,
  REDIS_URL: process.env.REDIS_URL || optionalEnvs.REDIS_URL,
  SENTRY_DSN: process.env.SENTRY_DSN || optionalEnvs.SENTRY_DSN,
  isDev: process.env.NODE_ENV === 'development',
  isProd: process.env.NODE_ENV === 'production',
};
