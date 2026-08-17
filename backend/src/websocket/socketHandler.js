/**
 * WebSocket Handler — Real-time Chat
 */

const chatService = require('../services/chatService');
const aiService = require('../services/aiService');
const logger = require('../config/logger');

const socketHandler = (io) => {
  io.on('connection', (socket) => {
    logger.info(`Client connected: ${socket.id}`);

    socket.on('join_session', (sessionId) => {
      socket.join(sessionId);
      socket.sessionId = sessionId;
      logger.info(`Client ${socket.id} joined session: ${sessionId}`);
    });

    socket.on('send_message', async (data) => {
      try {
        const { text, sessionId = 'default' } = data;

        // Save and broadcast user message
        const userMsg = await chatService.saveMessage(text, 'user', sessionId);
        io.to(sessionId).emit('message', userMsg);
        io.to(sessionId).emit('typing', true);

        // Get AI response
        const history = await chatService.getRecentHistory(sessionId, 10);
        const reply = await aiService.sendMessage(text, history);

        // Save and broadcast AI response
        const aiMsg = await chatService.saveMessage(reply, 'agent', sessionId);
        io.to(sessionId).emit('typing', false);
        io.to(sessionId).emit('message', aiMsg);

      } catch (error) {
        logger.error('WebSocket error:', error);
        socket.emit('error', { message: 'Failed to process message' });
        io.to(socket.sessionId || 'default').emit('typing', false);
      }
    });

    socket.on('clear_chat', async (sessionId = 'default') => {
      await chatService.clearSession(sessionId);
      io.to(sessionId).emit('chat_cleared');
    });

    socket.on('disconnect', () => {
      logger.info(`Client disconnected: ${socket.id}`);
    });
  });
};

module.exports = socketHandler;
