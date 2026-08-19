/**
 * Input Validation Middleware
 */

const { body, validationResult } = require('express-validator');

const validateRequest = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  next();
};

const validateLogin = [
  body('email')
    .isEmail()
    .normalizeEmail()
    .withMessage('Invalid email'),
  body('password')
    .isLength({ min: 6 })
    .withMessage('Password must be at least 6 characters'),
  validateRequest,
];

const validateRegister = [
  body('email')
    .isEmail()
    .normalizeEmail()
    .withMessage('Invalid email'),
  body('password')
    .isLength({ min: 8 })
    .withMessage('Password must be at least 8 characters'),
  body('name')
    .trim()
    .isLength({ min: 2 })
    .withMessage('Name must be at least 2 characters'),
  validateRequest,
];

const validateMessage = [
  body('content')
    .trim()
    .notEmpty()
    .withMessage('Message cannot be empty')
    .isLength({ max: 2000 })
    .withMessage('Message too long'),
  validateRequest,
];

module.exports = {
  validateLogin,
  validateRegister,
  validateMessage,
};
