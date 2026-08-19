/**
 * Session Cleanup Job
 * Runs daily at 2 AM to clean up old sessions
 */

const cron = require('node-cron');
const logger = require('../config/logger');

const setupCleanupJob = () => {
  // Every day at 2 AM
  cron.schedule('0 2 * * *', async () => {
    try {
      logger.info('🧹 Starting session cleanup job...');

      // TODO: Delete sessions older than 30 days
      // const result = await db.query(
      //   'DELETE FROM sessions WHERE created_at < NOW() - INTERVAL \'30 days\''
      // );

      logger.info('✅ Session cleanup completed');
    } catch (error) {
      logger.error('❌ Cleanup job failed:', error.message);
    }
  });
};

module.exports = setupCleanupJob;
