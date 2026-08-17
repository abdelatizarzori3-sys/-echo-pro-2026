/**
 * Input Validation Middleware
 * Uses express-validator for request validation
 */
const { body, param, validationResult } = require('express-validator');

const handleValidationErrors = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({
      success: false,
      message: 'Validation failed',
      errors: errors.array().map(err => ({
        field: err.path,
        message: err.msg,
      })),
    });
  }
  next();
};

const authValidators = {
  register: [
    body('email')
      .isEmail()
      .normalizeEmail()
      .withMessage('Valid email is required'),
    body('password')
      .isLength({ min: 8 })
      .withMessage('Password must be at least 8 characters')
      .matches(/[A-Z]/)
      .withMessage('Password must contain at least one uppercase letter')
      .matches(/[0-9]/)
      .withMessage('Password must contain at least one number'),
    body('name')
      .optional()
      .trim()
      .isLength({ min: 2, max: 50 })
      .withMessage('Name must be between 2 and 50 characters'),
    handleValidationErrors,
  ],
  login: [
    body('email')
      .isEmail()
      .normalizeEmail()
      .withMessage('Valid email is required'),
    body('password')
      .notEmpty()
      .withMessage('Password is required'),
    handleValidationErrors,
  ],
};

const chatValidators = {
  sendMessage: [
    body('content')
      .trim()
      .isLength({ min: 1, max: 4000 })
      .withMessage('Message must be between 1 and 4000 characters'),
    body('sessionId')
      .optional()
      .isUUID()
      .withMessage('Invalid session ID'),
    handleValidationErrors,
  ],
  createSession: [
    body('title')
      .optional()
      .trim()
      .isLength({ max: 100 })
      .withMessage('Title must not exceed 100 characters'),
    handleValidationErrors,
  ],
  getMessages: [
    param('sessionId')
      .isUUID()
      .withMessage('Invalid session ID'),
    handleValidationErrors,
  ],
};

module.exports = {
  authValidators,
  chatValidators,
  handleValidationErrors,
};
