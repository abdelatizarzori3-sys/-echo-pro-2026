/**
 * Request Validation Middleware
 * Validates chat input to prevent injection and abuse
 */

const Joi = require('joi');
const { AppError } = require('./errorHandler');

const schemas = {
  sendMessage: Joi.object({
    text: Joi.string()
      .min(1)
      .max(4000)
      .required()
      .trim()
      .pattern(/^[^<>{}]*$/, 'no script tags'),
    sessionId: Joi.string().alphanum().max(50).optional()
  }),

  getMessages: Joi.object({
    sessionId: Joi.string().alphanum().max(50).optional(),
    limit: Joi.number().integer().min(1).max(100).default(50),
    offset: Joi.number().integer().min(0).default(0)
  })
};

const validate = (schemaName) => {
  return (req, res, next) => {
    const schema = schemas[schemaName];
    if (!schema) return next();

    const data = req.method === 'GET' ? req.query : req.body;
    const { error, value } = schema.validate(data, { abortEarly: false });

    if (error) {
      const message = error.details.map(d => d.message).join(', ');
      return next(new AppError(message, 400));
    }

    req.validated = value;
    next();
  };
};

module.exports = validate;
