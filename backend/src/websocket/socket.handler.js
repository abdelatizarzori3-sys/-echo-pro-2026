const aiService = require('../services/ai.service');
const logger = require('../utils/logger');

module.exports = (io, prisma) => {
  io.on('connection', (socket) => {
    logger.info(`Socket connected: ${socket.id}`);

    socket.on('join', (sessionId) => {
      socket.join(sessionId);
      socket.sessionId = sessionId;
    });

    socket.on('message', async (data) => {
      try {
        const { text, sessionId, userId } = data;

        // Save user msg
        await prisma.message.create({
          data: { content: text, sender: 'user', sessionId, userId },
        });
        io.to(sessionId).emit('message', { sender: 'user', content: text });
        io.to(sessionId).emit('typing', true);

        // AI response
        const history = await prisma.message.findMany({
          where: { sessionId }, orderBy: { createdAt: 'desc' }, take: 10,
        });
        const reply = await aiService.sendMessage(text, history.reverse());

        // Save AI msg
        const aiMsg = await prisma.message.create({
          data: { content: reply, sender: 'agent', sessionId, userId, metadata: { model: 'moonshot-v1-8k' } },
        });

        io.to(sessionId).emit('typing', false);
        io.to(sessionId).emit('message', aiMsg);
      } catch (err) {
        logger.error('Socket error:', err);
        socket.emit('error', { message: err.message });
        io.to(socket.sessionId).emit('typing', false);
      }
    });

    socket.on('disconnect', () => {
      logger.info(`Socket disconnected: ${socket.id}`);
    });
  });
};
