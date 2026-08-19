/**
 * WebSocket Socket.io Handler
 */

const logger = require('../config/logger');

const socketHandler = (io) => {
  io.on('connection', (socket) => {
    logger.info(`✅ User connected: ${socket.id}`);

    socket.on('join-room', (roomId) => {
      socket.join(roomId);
      logger.info(`✅ User ${socket.id} joined room ${roomId}`);
    });

    socket.on('send-message', (data) => {
      io.to(data.roomId).emit('receive-message', {
        from: socket.id,
        message: data.message,
        timestamp: new Date(),
      });
    });

    socket.on('disconnect', () => {
      logger.info(`❌ User disconnected: ${socket.id}`);
    });
  });
};

module.exports = socketHandler;
