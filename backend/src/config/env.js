/**
 * Environment Configuration
 * 🔑 All API keys MUST come from Railway Variables — never hardcoded
 */

require('dotenv').config();

const required = ['DATABASE_URL'];

const env = {
  NODE_ENV: process.env.NODE_ENV || 'development',
  PORT: parseInt(process.env.PORT, 10) || 3000,

  // 🔑 Database — Railway provides this automatically
  DATABASE_URL: process.env.DATABASE_URL,

  // 🔑 Redis — optional but recommended for caching
  REDIS_URL: process.env.REDIS_URL || null,

  // 🔑 Kimi AI API Key — REQUIRED, set in Railway Variables
  KIMI_API_KEY: process.env.KIMI_API_KEY,
  KIMI_BASE_URL: process.env.KIMI_BASE_URL || 'https://api.moonshot.cn/v1',
  KIMI_MODEL: process.env.KIMI_MODEL || 'moonshot-v1-8k',

  // 🔑 JWT — for future authentication
  JWT_SECRET: process.env.JWT_SECRET || 'echo-dev-secret-change-in-production',
  JWT_EXPIRES_IN: process.env.JWT_EXPIRES_IN || '7d',

  // CORS
  CORS_ORIGIN: process.env.CORS_ORIGIN || '*',

  // Rate Limiting
  RATE_LIMIT_WINDOW_MS: parseInt(process.env.RATE_LIMIT_WINDOW_MS, 10) || 60000,
  RATE_LIMIT_MAX: parseInt(process.env.RATE_LIMIT_MAX, 10) || 100,

  // Logging
  LOG_LEVEL: process.env.LOG_LEVEL || 'info',
};

// Validate required env vars
for (const key of required) {
  if (!env[key]) {
    console.error(`❌ Missing required environment variable: ${key}`);
    process.exit(1);
  }
}

// Warn about missing KIMI key
if (!env.KIMI_API_KEY) {
  console.warn('⚠️  KIMI_API_KEY not set — AI chat will fail. Add it in Railway Variables!');
}

module.exports = env;
