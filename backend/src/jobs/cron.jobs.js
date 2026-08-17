const cron = require('node-cron');
const { PrismaClient } = require('@prisma/client');
const logger = require('../utils/logger');

const prisma = new PrismaClient();

module.exports = {
  start() {
    // Cleanup old messages every day at 3 AM
    cron.schedule('0 3 * * *', async () => {
      logger.info('Running cleanup job...');
      const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
      const result = await prisma.message.deleteMany({
        where: { createdAt: { lt: thirtyDaysAgo } },
      });
      logger.info(`Cleaned up ${result.count} old messages`);
    });

    logger.info('Cron jobs started');
  },
};
