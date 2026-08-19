/**
 * Messages Routes
 */

const express = require('express');
const router = express.Router();
const messageController = require('../controllers/messageController');
const { verifyToken } = require('../middleware/auth');
const { validateMessage } = require('../middleware/validation');
const { chatLimiter } = require('../middleware/rateLimiter');

router.post(
  '/send',
  verifyToken,
  chatLimiter,
  validateMessage,
  (req, res) => messageController.sendMessage(req, res)
);

router.get('/history/:conversationId', verifyToken, (req, res) =>
  messageController.getMessages(req, res)
);

module.exports = router;
