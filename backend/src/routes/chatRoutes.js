/**
 * Chat Routes
 */

const express = require('express');
const router = express.Router();
const chatController = require('../controllers/chatController');
const validate = require('../middleware/validate');
const { apiLimiter, chatLimiter } = require('../middleware/rateLimiter');

router.get('/health', chatController.healthCheck);

router.get('/messages', 
  apiLimiter,
  validate('getMessages'), 
  chatController.getMessages
);

router.post('/chat', 
  chatLimiter,
  validate('sendMessage'), 
  chatController.sendMessage
);

router.delete('/messages', 
  apiLimiter,
  validate('getMessages'),
  chatController.clearChat
);

router.get('/stats', apiLimiter, chatController.getStats);

module.exports = router;
