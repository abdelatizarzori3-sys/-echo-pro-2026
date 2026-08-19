/**
 * Messages Controller
 */

const kimiService = require('../services/kimiService');
const logger = require('../config/logger');

class MessageController {
  async sendMessage(req, res) {
    try {
      const { content, conversationId } = req.body;
      const userId = req.user?.userId;

      if (!userId) {
        return res.status(401).json({ error: 'Unauthorized' });
      }

      logger.info(`💬 Message from ${userId}: ${content.substring(0, 50)}...`);

      // TODO: Save user message to database
      // TODO: Get conversation history from database

      const aiResponse = await kimiService.chat(content, []);

      // TODO: Save AI response to database

      res.status(200).json({
        userMessage: content,
        aiResponse,
        timestamp: new Date(),
      });
    } catch (error) {
      logger.error(`❌ Message error: ${error.message}`);
      res.status(500).json({ error: 'Failed to process message' });
    }
  }

  async getMessages(req, res) {
    try {
      const { conversationId } = req.params;
      const userId = req.user?.userId;

      // TODO: Fetch messages from database
      // const messages = await db.query(
      //   'SELECT * FROM messages WHERE conversation_id = $1 AND user_id = $2',
      //   [conversationId, userId]
      // );

      res.status(200).json({
        messages: [],
        total: 0,
      });
    } catch (error) {
      logger.error(`❌ Get messages error: ${error.message}`);
      res.status(500).json({ error: 'Failed to fetch messages' });
    }
  }
}

module.exports = new MessageController();
