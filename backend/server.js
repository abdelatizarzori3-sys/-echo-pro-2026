/**
 * Echo Backend Server
 * Production-ready Node.js/Express API with PostgreSQL, Redis, WebSocket
 * 🔑 KIMI_API_KEY must be set in Railway Variables ONLY
 */

const app = require('./src/app');
const { createServer } = require('http');
const { Server } = require('socket.io');
const logger = require('./src/config/logger');
const { pool } = require('./src/config/database');
const socketHandler = require('./src/websocket/socketHandler');
const env = require('./src/config/env');

const PORT = env.PORT || 3000;

// Graceful shutdown handling
const gracefulShutdown = (server) => {
  return (signal) => {
    logger.info(`${signal} received. Starting graceful shutdown...`);
    server.close(async () => {
      logger.info('HTTP server closed.');
      await pool.end();
      logger.info('Database pool closed.');
      process.exit(0);
    });
  };
};

const startServer = async () => {
  try {
    // Test database connection
    const client = await pool.connect();
    logger.info('✅ PostgreSQL connected successfully');
    client.release();

    const httpServer = createServer(app);
    const io = new Server(httpServer, {
      cors: {
        origin: env.CORS_ORIGIN,
        methods: ['GET', 'POST']
      }
    });

    // Initialize WebSocket handler
    socketHandler(io);

    httpServer.listen(PORT, () => {
      logger.info(`🚀 Echo Backend running on port ${PORT} in ${env.NODE_ENV} mode`);
      logger.info(`🔑 Kimi AI Integration: ${env.KIMI_API_KEY ? 'ACTIVE' : 'MISSING — Set KIMI_API_KEY in Railway Variables!'}`);
    });

    process.on('SIGTERM', gracefulShutdown(httpServer));
    process.on('SIGINT', gracefulShutdown(httpServer));

  } catch (error) {
    logger.error('❌ Failed to start server:', error);
    process.exit(1);
  }
};

startServer();
