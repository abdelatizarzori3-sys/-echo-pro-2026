/**
 * Authentication Routes
 */

const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const { validateLogin, validateRegister } = require('../middleware/validation');
const { authLimiter } = require('../middleware/rateLimiter');

router.post('/register', authLimiter, validateRegister, (req, res) =>
  authController.register(req, res)
);

router.post('/login', authLimiter, validateLogin, (req, res) =>
  authController.login(req, res)
);

module.exports = router;
