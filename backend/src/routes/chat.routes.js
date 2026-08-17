const express = require('express');
const router = express.Router();
const chatController = require('../controllers/chat.controller');
const { auth } = require('../middleware/auth.middleware');
const { chatLimiter } = require('../middleware/rate.middleware');
const { asyncHandler } = require('../middleware/error.middleware');

router.get('/messages', auth, asyncHandler(chatController.getMessages));
router.post('/send', auth, chatLimiter, asyncHandler(chatController.sendMessage));
router.delete('/messages', auth, asyncHandler(chatController.clearChat));
router.get('/sessions', auth, asyncHandler(chatController.getSessions));

module.exports = router;
