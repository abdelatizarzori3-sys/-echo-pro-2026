/**
 * Echo Backend Pro v3.0
 * Production-grade Node.js API with Prisma, JWT, WebSocket
 * 🔑 KIMI_API_KEY in Railway Variables ONLY
 */

require('dotenv').config();
const app = require('./app');
const { createServer } = require('http');
const { Server } = require('socket.io');
const { PrismaClient } = require('@prisma/client');
const logger = require('./utils/logger');
const socketHandler = require('./websocket/socket.handler');
const cronJobs = require('./jobs/cron.jobs');

const PORT = process.env.PORT || 3000;
const prisma = new PrismaClient();

const start = async () => {
  try {
    await prisma.$connect();
    logger.info('✅ Database connected via Prisma');

    const httpServer = createServer(app);
    const io = new Server(httpServer, {
      cors: { origin: process.env.CORS_ORIGIN || '*', methods: ['GET', 'POST'] },
      transports: ['websocket', 'polling'],
    });

    socketHandler(io, prisma);
    cronJobs.start();

    httpServer.listen(PORT, () => {
      logger.info(`🚀 Echo Pro on port ${PORT} [${process.env.NODE_ENV}]`);
      logger.info(`🔑 Kimi: ${process.env.KIMI_API_KEY ? 'ACTIVE' : 'MISSING — Set in Railway Variables!'}`);
    });

    const graceful = (signal) => {
      logger.info(`${signal} received. Shutting down gracefully...`);
      httpServer.close(async () => {
        await prisma.$disconnect();
        logger.info('Cleanup complete.');
        process.exit(0);
      });
    };
    process.on('SIGTERM', () => graceful('SIGTERM'));
    process.on('SIGINT', () => graceful('SIGINT'));

  } catch (err) {
    logger.error('Failed to start:', err);
    process.exit(1);
  }
};

start();
