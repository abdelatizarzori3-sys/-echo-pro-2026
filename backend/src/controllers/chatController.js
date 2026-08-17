/**
 * Chat Controller — HTTP Request Handlers
 */

const chatService = require('../services/chatService');
const aiService = require('../services/aiService');
const { asyncHandler } = require('../middleware/errorHandler');
const logger = require('../config/logger');

const chatController = {
  // GET /api/messages
  getMessages: asyncHandler(async (req, res) => {
    const { sessionId, limit, offset } = req.validated || req.query;
    const messages = await chatService.getMessages(sessionId, limit, offset);
    res.json({
      success: true,
      data: messages,
      meta: { count: messages.length, sessionId }
    });
  }),

  // POST /api/chat
  sendMessage: asyncHandler(async (req, res) => {
    const { text, sessionId } = req.validated || req.body;

    // Save user message
    await chatService.saveMessage(text, 'user', sessionId);

    // Get recent history for context
    const history = await chatService.getRecentHistory(sessionId, 10);

    // Get AI response
    const reply = await aiService.sendMessage(text, history);

    // Save AI response
    const aiMessage = await chatService.saveMessage(reply, 'agent', sessionId, {
      model: 'moonshot-v1-8k',
      processedAt: new Date().toISOString()
    });

    res.json({
      success: true,
      data: {
        reply,
        message: aiMessage
      }
    });
  }),

  // DELETE /api/messages
  clearChat: asyncHandler(async (req, res) => {
    const { sessionId } = req.validated || req.query;
    await chatService.clearSession(sessionId);
    res.json({ success: true, message: 'Chat cleared' });
  }),

  // GET /api/health
  healthCheck: asyncHandler(async (req, res) => {
    const aiHealth = await aiService.healthCheck();
    const dbHealth = await pool.query('SELECT 1').then(() => 'healthy').catch(() => 'unhealthy');

    res.json({
      success: true,
      data: {
        status: 'up',
        timestamp: new Date().toISOString(),
        services: {
          database: dbHealth,
          ai: aiHealth
        }
      }
    });
  }),

  // GET /api/stats
  getStats: asyncHandler(async (req, res) => {
    const stats = await chatService.getStats();
    res.json({ success: true, data: stats });
  })
};

module.exports = chatController;
